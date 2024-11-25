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
            $tmpDir = sys_get_temp_dir() . '/' . uniqid('upload_', true);
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

            // Preparar respuesta
            $responseData = [
                'success' => true,
                'data' => $result
            ];

            // Escribir respuesta
            $response->getBody()->write(json_encode($responseData));
            return $response->withHeader('Content-Type', 'application/json');
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
            'output_base_dir' => $rutas["ruta_detecciones"] ?? "",
            'weights_path' => $paths["stats"]["model_paths"]["best"],
            'data_yaml_path' => $paths["config"]["data_yaml"],
        ];
    }

    /**
     * Enriquece los resultados con información adicional de la base de datos
     */
    private function enrichDetectionResults(array $result): array
    {
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
     */
    private function getClassInfoFromDB(string $className): array
    {
        // Implementar la lógica para obtener información adicional de la base de datos
        // Este es solo un ejemplo
        return [
            'description' => 'Descripción de la clase ' . $className,
            'category' => 'Categoría ejemplo',
            // ... más información ...
        ];
    }
}
