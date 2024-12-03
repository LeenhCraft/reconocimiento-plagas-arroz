<?php

namespace App\Controllers\ModuloIA;

use Exception;

use Slim\Psr7\Request;
use Slim\Psr7\Response;

use App\Core\Controller;
use App\Classes\DetectYoloClass;
use App\Models\TableModel;

class IAController extends Controller
{
    public function __construct()
    {
        parent::__construct();
    }

    public function index($request, $response)
    {
        return $this->render($response, 'ModuloIA.IA.IA', [
            'titulo_web' => 'Predicción:.',
            "url" => $request->getUri()->getPath(),
            "js" => [
                "/js/ModuloIA/prediccion.js"
            ],
            "data" => []
        ]);
    }

    /**
     * Maneja la detección de objetos en una imagen
     */
    public function detect(Request $request, Response $response): Response
    {
        try {
            // inicio de ejecución
            $start = time();

            // Validar que se recibió un archivo
            $uploadedFiles = $request->getUploadedFiles();

            if (empty($uploadedFiles['image'])) {
                throw new Exception('No se recibió ninguna imagen');
            }

            /** @var UploadedFileInterface $uploadedFile */
            $uploadedFile = $uploadedFiles['image'];

            // Validar el tipo MIME
            $mimeType = $uploadedFile->getClientMediaType();
            if (!in_array($mimeType, ['image/jpeg', 'image/png', 'image/jpg'])) {
                throw new Exception('Tipo de archivo no permitido. Solo se aceptan imágenes JPEG y PNG');
            }

            // Obtener parámetros adicionales
            $params = $request->getParsedBody();
            $confidenceThreshold = isset($params['confidence']) ?
                floatval($params['confidence']) : 0.15;

            // Obtener rutas de la base de datos (ejemplo)
            $modelPaths = $this->getModelPathsFromDB();

            // Crear directorio temporal para la imagen
            $tmpDir = sys_get_temp_dir() . '/' . uniqid(urls_amigables($_ENV["APP_NAME"]) . '_upload_', true);
            mkdir($tmpDir, 0777, true);

            // Guardar imagen temporal
            $tmpImagePath = $tmpDir . '/' . $uploadedFile->getClientFilename();
            $uploadedFile->moveTo($tmpImagePath);

            // Inicializar detector
            $detector = new DetectYoloClass(
                $modelPaths['python_path'],
                $modelPaths['script_path'],
                $modelPaths['output_base_dir'],
                $modelPaths['weights_path'],
                $modelPaths['data_yaml_path']
            );

            // Ejecutar detección
            $result = $detector->detect($tmpImagePath, $confidenceThreshold);

            // Limpiar archivo temporal
            unlink($tmpImagePath);
            rmdir($tmpDir);

            // Si es exitoso, agregar información adicional de la base de datos
            if (isset($result['success']) && $result['success']) {
                $result = $this->enrichDetectionResults($result);
            }

            // Fin de ejecución
            $tiempo = getExecutionTime($start);
            $result['execution_time'] = $tiempo["detallado"];

            // registramos el historial de la detección
            $result["idmodelo"] = $modelPaths["idmodelo"];
            $historial = $this->registerHistory($result);
            $result["cod"] = $historial["idhistorial"];

            // Preparar respuesta
            $responseData = [
                'success' => true,
                'data' => $result
            ];

            // Escribir respuesta
            return $this->respondWithJson($response, $responseData);
        } catch (Exception $e) {
            // Preparar respuesta de error
            $errorResponse = [
                'success' => false,
                'error' => $e->getMessage(),
                'timestamp' => date('Y-m-d H:i:s')
            ];

            $response->getBody()->write(json_encode($errorResponse));
            return $response
                ->withHeader('Content-Type', 'application/json')
                ->withStatus(400);
        }
    }



    /**
     * Obtiene las rutas necesarias de la base de datos
     */
    private function getModelPathsFromDB(): array
    {
        // Aquí deberías implementar la lógica para obtener las rutas de la base de datos
        $model = new TableModel;
        $model->setTable("re_configuracion");
        $model->setId("idconfig");
        $textdata = $model->first();
        if (!empty($textdata)) {
            $rutas = json_decode($textdata['valor'], true);
        }

        $model->emptyQuery();
        $model->setTable("re_detalle_modelo");
        $model->setId("id_detalle_modelo");
        $modeloEntrenado = $model->where("det_default", "1")->first();
        if (!empty($modeloEntrenado)) {
            $paths = json_decode($modeloEntrenado['det_salida'], true);
        }

        // Este es solo un ejemplo
        return [
            'python_path' => $_ENV["PYTHON_PATH"],
            'script_path' => __DIR__ . '/../ScriptIA/DetectYolo.py',
            // 'script_path' => __DIR__ . '/../ScriptIA/detect_yolo_v2.py',
            'output_base_dir' => $rutas["ruta_detecciones"] ?? "",
            'weights_path' => $paths["stats"]["model_paths"]["best"],
            'data_yaml_path' => $paths["config"]["data_yaml"],
            'name' => $modeloEntrenado['det_nombre'],
            'idmodelo' => $modeloEntrenado['id_detalle_modelo'],
        ];
    }

    /**
     * Enriquece los resultados con información adicional de la base de datos
     */
    private function enrichDetectionResults(array $result): array
    {
        unset($result['model_info']);
        // Aquí deberías implementar la lógica para agregar información
        // adicional de la base de datos para cada clase detectada
        if (isset($result['detections'])) {
            foreach ($result['detections'] as &$detection) {

                $className = $detection['class'];
                // Obtener información adicional de la base de datos
                $detection['additional_info'] = $this->getClassInfoFromDB($className);
            }
        }

        return $result;
    }

    /**
     * Obtiene información adicional de una clase desde la base de datos
     * @param string $className Nombre de la clase
     * @return array Información adicional de la clase
     */
    private function getClassInfoFromDB(string $className): array
    {
        // Implementar la lógica para obtener información adicional de la base de datos
        $model = new TableModel;
        $model->setTable("re_enfermedades");
        $model->setId("idenfermedad");
        $data = $model
            ->where("nombre", "LIKE", $className)
            ->first();

        // Este es solo un ejemplo
        return [
            // 'description' => 'Descripción de la clase ' . $className,
            'description' => $data['descripcion'] ?? '',
            'url' => base_url() . "admin/plagas/" . $data['slug'] ?? '',
            'image' => base_url() . $data['imagen_url'] ?? '',
            // ... más información ...
        ];
    }

    /**
     * Registra el historial de detecciones
     * @param array $result Resultado de la detección
     * @return array Información del historial registrado
     */
    private function registerHistory(array $result)
    {
        // Implementar la lógica para registrar el historial de detecciones
        $model = new TableModel;
        $model->setTable("re_historial_identificacion");
        $model->setId("idhistorial");

        $data = [
            "id_detalle_modelo" => $result["idmodelo"],
            "idusuario" => $_SESSION["app_id"],
            "his_img" => "",
            "his_tiempo" => $result["execution_time"],
            "his_inicio" => "no disponible",
            "his_fin" => "no disponible",
            "his_index" => "0",
            "his_prediccion" => json_encode($result),
        ];

        return $model->create($data);
    }

    public function generarPdf($request, $response, $args)
    {
        try {
            $data = $this->sanitize($args);

            if (!$data["id"]) {
                throw new Exception("ID de ocurrencia no proporcionado");
            }

            $model = new TableModel;
            $model->setTable('re_historial_identificacion');
            $model->setId("idhistorial");

            $arrData = $model
                ->select(
                    "re_historial_identificacion.*",
                    "re_modelo.mo_nombre as modelo"
                )
                ->join("re_detalle_modelo", "re_detalle_modelo.id_detalle_modelo", "re_historial_identificacion.id_detalle_modelo")
                ->join("re_modelo", "re_modelo.idmodelo", "re_detalle_modelo.idmodelo")
                ->where("re_historial_identificacion.idhistorial", $data["id"])
                ->first();

            if (empty($arrData)) {
                throw new Exception("Informe de Detección no encontrada");
            }

            $prediccion = json_decode($arrData["his_prediccion"], true);
            $detecciones = $prediccion["detections"][0];
            // dep($arrData);
            // dep($prediccion, 1);

            // Generar el nombre del archivo
            $fileName = urls_amigables("Informe de Detección - " . addCeros($arrData["idhistorial"], 6));

            // Crear instancia de mPDF
            $mpdf = new \Mpdf\Mpdf([
                'margin_left' => 15,
                'margin_right' => 15,
                'margin_top' => 15,
                'margin_bottom' => 15,
                'format' => 'A4',
            ]);

            // Establecer el título del documento PDF
            $mpdf->SetTitle($fileName);

            // Estilos CSS
            $css = '
                body {
                    font-family: Arial, sans-serif;
                    line-height: 1.6;
                    color: #333;
                }
                .header {
                    text-align: center;
                    padding: 20px;
                    background: #f8f9fa;
                    margin-bottom: 30px;
                }
                .logo {
                    max-width: 50px;
                    margin-bottom: 15px;
                }
                .container {
                    padding: 20px;
                }
                .detection-info {
                    margin-bottom: 30px;
                }
                .detection-box {
                    background: #fff;
                    border: 1px solid #ddd;
                    padding: 15px;
                    margin: 10px 0;
                    border-radius: 5px;
                }
                .stats-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 15px;
                    margin: 20px 0;
                }
                .stat-item {
                    background: #f8f9fa;
                    padding: 10px;
                    border-radius: 5px;
                }
                .confidence-bar {
                    background: #e9ecef;
                    height: 20px;
                    border-radius: 10px;
                    overflow: hidden;
                }
                .confidence-level {
                    background: #4CAF50;
                    height: 20px;
                }
                .timestamp {
                    color: #666;
                    font-size: 0.9em;
                }
                .execution-time {
                    color: #007bff;
                    font-weight: bold;
                }
                .additional-info {
                    margin-top: 30px;
                    padding: 20px;
                    background: #f8f9fa;
                    border-left: 4px solid #007bff;
                }
                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin: 20px 0;
                }
                th, td {
                    padding: 12px;
                    text-align: left;
                    border-bottom: 1px solid #ddd;
                }
                .detection-image {
                    max-width: 100%;
                    height: auto;
                    margin: 20px 0;
                }';

            $mpdf->WriteHTML($css, \Mpdf\HTMLParserMode::HEADER_CSS);

            // Contenido HTML actualizado
            $html = '
                <body>
                    <div class="header">
                        <img src="/img/logo-dark.png" class="logo" alt="Logo">
                        <h1>Reporte de Detección de Plagas</h1>
                    </div>

                    <div class="container">
                        <div class="detection-info">
                            <div class="detection-box">
                                <h2>Detección Principal</h2>
                                <p>Clase: <strong>' . $detecciones["class"] . '</strong></p>
                                
                                <div class="confidence-bar">
                                    <div class="confidence-level" style="width: ' . ($detecciones["confidence"] * 100) . '%"></div>
                                </div>
                                <p>Confianza: ' . ($detecciones["confidence"] * 100) . '%</p>
                                
                                <img src="' . $detecciones["additional_info"]["image"] . '" class="detection-image" alt="Imagen detectada">
                            </div>

                            <div class="stats-grid">
                                <div class="stat-item">
                                    <p>Total de detecciones: ' . $prediccion["summary"]["total_detections"] . ' </p>
                                </div>
                                <div class="stat-item">
                                    <p>Tiempo de ejecución: <span class="execution-time">' . $prediccion["execution_time"] . '</span></p>
                                </div>
                            </div>

                            <table>
                                <tr>
                                    <th>Timestamp</th>
                                    <th>ID Modelo</th>
                                    <th>Directorio de salida</th>
                                </tr>
                                <tr>
                                    <td>' . $arrData["his_fecha"] . '</td>
                                    <td>' . $arrData["modelo"] . '</td>
                                    <td>' . $prediccion["output_dir"] . '</td>
                                </tr>
                            </table>
                        </div>

                        <div class="additional-info">
                            <h3>Información Adicional</h3>
                            ' . $detecciones["additional_info"]["description"] . '
                        </div>
                    </div>
                </body>';

            $mpdf->WriteHTML($html);

            // Generar PDF
            $pdfContent = $mpdf->Output('', 'S');
            // Configurar headers para mostrar en línea
            $response = $response->withHeader('Content-Type', 'application/pdf')
                ->withHeader('Content-Disposition', 'inline; filename="' . $fileName . '.pdf"');
            $pdfContent = $mpdf->Output('', 'S');
            $response->getBody()->write($pdfContent);
            return $response;
        } catch (Exception $e) {
            return $this->respondWithJson($response, ["error" => $e->getMessage()]);
        }
    }
}
