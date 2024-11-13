<?php

namespace App\Controllers\ModuloIA;

use App\Core\Controller;
use App\Models\TableModel;
use DateTime;

class EntrenamientoController extends Controller
{
    public function __construct()
    {
        parent::__construct();
    }

    public function index($request, $response)
    {
        $_SESSION["UUID"] = uniqid("csrf_token_", true);
        return $this->render($response, 'ModuloIA.Entrenamiento.Entrenamiento', [
            'titulo_web' => 'Entrenamiento',
            "url" => $request->getUri()->getPath(),
            "js" => [
                "/js/moduloIA/entrenamiento.js"
            ],
            "uuid" => $_SESSION["UUID"]
        ]);
    }

    public function entrenarModelo($request, $response)
    {
        $data = $this->sanitize($request->getParsedBody());
        if (!isset($data["uuid"]) || $data["uuid"] != $_SESSION["UUID"]) {
            return $this->respondWithError($response, "Error al generar los datos, le sugerimos recargar la página");
        }
        if ($data["uuid"] != $_SESSION["UUID"]) {
            return $this->respondWithError($response, "Error al generar los datos, le sugerimos recargar la página");
        }

        $marcaTiempo = date("Ymd_His");
        $tiempoInicio = time();
        $model = new TableModel;
        $model->setTable("re_configuracion");
        $model->setId("idconfig");
        $textdata = $model->first();
        if (empty($textdata)) {
            return $this->respondWithError($response, "No existe una configuración para las rutas de los datos");
        }

        $arrDataTrain = $this->obtenerDataTrain();

        $rutas = json_decode($textdata['valor'], true);
        $pythonPath = "C:/Users/LEENH/anaconda3/envs/plagas/python.exe";
        $scriptPath = __DIR__ . "/../ScriptIA/EntrenarYOLO.py";
        // $scriptPath = __DIR__ . "/../ScriptIA/Demo.py";

        // Parámetros de entrenamiento
        $nombre = $rutas["nombre_modelo"] . "_" . $marcaTiempo;
        $arg = [
            '--data' => $arrDataTrain["yaml"]["yaml_path"],
            // '--base-path' => "C:/laragon/www/plagas-arroz/public_html",
            '--output' => $rutas["ruta_modelo"],
            '--name' => $nombre,
            '--epochs' => 10,
            '--batch-size' => 32,
            '--img-size' => 416,
            '--device' => '0',  // vacío para auto-detección
            '--model-size' => 'n', // n, s, m, l, x
            '--log-file' => "log/train.log",
            // pesos pre entrenados
            '--weights' => 'models/yolov5n.pt',
        ];

        // Agregar --debug solo si está activo
        $debug = false; // o true para ver logs
        if ($debug) {
            $arg['--debug'] = '';
        }

        // Construir el comando
        $command = sprintf(
            '"%s" "%s" %s',
            $pythonPath,
            $scriptPath,
            implode(' ', array_map(
                function ($key, $value) {
                    // Si el valor es null o cadena vacía
                    if ($value === null || $value === '') {
                        return $key;
                    }
                    // Si es numérico (incluye 0)
                    if (is_numeric($value)) {
                        return sprintf('%s %s', $key, $value);
                    }
                    // Para otros valores
                    return sprintf('%s %s', $key, escapeshellarg($value));
                },
                array_keys($arg),
                array_values($arg)
            ))
        );

        // Ejecutar el comando
        $output = [];
        $returnCode = -1;
        // exec($command . " 2>&1", $output, $returnCode);
        exec($command, $output, $returnCode);

        $marcaTiempo2 = date("Ymd_His");

        $tiempoFin = time();

        // Procesar la salida
        if ($returnCode === 0) {
            $result = json_decode(implode("\n", $output), true);
            // dep([
            //     'marca 1' => DateTime::createFromFormat('Ymd_His', $marcaTiempo)->format('Y-m-d H:i:s'),
            //     'marca 2' => DateTime::createFromFormat('Ymd_His', $marcaTiempo2)->format('Y-m-d H:i:s'),
            //     'command' => $command,
            //     'output' => $output,
            //     'result' => $result,
            //     'return_code' => $returnCode,
            // ], 1);
            // Procesar $result
            if ($result["success"]) {

                $model = new TableModel;
                $model->setTable("re_datos_generados");
                $model->setId("identrenamiento");
                $datosGenerados = $model->where("ent_default", "1")->first();

                $model = new TableModel;
                $model->setTable("re_detalle_modelo");
                $model->setId("id_detalle_modelo");
                $respuesta = $model->create([
                    "idmodelo" => "1",
                    "identrenamiento" => $datosGenerados["identrenamiento"],
                    "det_ruta" => $result["config"]["output_path"],
                    "det_nombre" => $nombre,
                    "det_default" => "1",
                    "det_tiempo" => $tiempoFin - $tiempoInicio,
                    "det_inicio" => DateTime::createFromFormat('Ymd_His', $marcaTiempo)->format('Y-m-d H:i:s'),
                    "det_fin" => DateTime::createFromFormat('Ymd_His', $marcaTiempo2)->format('Y-m-d H:i:s'),
                    "det_salida" => json_encode($result),
                ]);
                if (!empty($respuesta)) {
                    $model->query("UPDATE re_detalle_modelo SET det_default = 0 WHERE id_detalle_modelo != ?", [$respuesta["id_detalle_modelo"]]);
                    return $this->respondWithSuccess($response, "Modelo entrenado con éxito.");
                }
                return $this->respondWithError($response, "Error al guardar el modelo entrenado.");
            }
            return $this->respondWithError($response, $result["error"]);
        } else {
            // Manejar error
            $error = [
                'success' => false,
                'error' => 'Error ejecutando el entrenamiento',
                'output' => $output,
                'return_code' => $returnCode
            ];
        }
    }

    private function obtenerDataTrain()
    {
        $dataTrain = new TableModel;
        $dataTrain->setTable("re_datos_generados");
        $dataTrain->setId("identrenamiento");
        $arrDataTrain = $dataTrain
            ->where("ent_default", "1")
            ->first();
        $arrDataTrain["stats"] = json_decode($arrDataTrain["stats"], true);
        $arrDataTrain["yaml"] = json_decode($arrDataTrain["yaml"], true);
        $arrDataTrain["summary"] = json_decode($arrDataTrain["summary"], true);
        return $arrDataTrain;
    }
}
