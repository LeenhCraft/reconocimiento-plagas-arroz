<?php

namespace App\Controllers\ModuloIA;

use App\Core\Controller;
use App\Models\TableModel;

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

        $model = new TableModel;
        $model->setTable("re_configuracion");
        $model->setId("idconfig");
        $textdata = $model->first();
        if (empty($textdata)) {
            return $this->respondWithError($response, "No existe una configuración para las rutas de los datos");
        }

        $arrDataTrain = $this->obtenerDataTrain();

        $rutas = json_decode($textdata['valor'], true);
        $pythonPath = "C:/Users/LEENH/anaconda3/envs/plagazArroz/python.exe";
        $scriptPath = __DIR__ . "/../ScriptIA/EntrenarYOLO.py";
        // $scriptPath = __DIR__ . "/../ScriptIA/Demo.py";

        // Parámetros de entrenamiento
        $arg = [
            '--data' => $arrDataTrain["yaml"]["yaml_path"],
            // '--base-path' => "C:/laragon/www/plagas-arroz/public_html",
            '--output' => $rutas["ruta_modelo"],
            // '--epochs' => 300,
            // '--batch-size' => 16,
            // '--img-size' => 640,
            // '--device' => 'cpu',  // vacío para auto-detección
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
                    return empty($value) ? $key : sprintf('%s %s', $key, escapeshellarg($value));
                },
                array_keys($arg),
                array_values($arg)
            ))
        );

        // Ejecutar el comando
        $output = [];
        $returnCode = -1;
        exec($command . " 2>&1", $output, $returnCode);

        dep([
            'command' => $command,
            'output' => $output,
            'return_code' => $returnCode
        ], 1);

        // Procesar la salida
        if ($returnCode === 0) {
            $result = json_decode(implode("\n", $output), true);
            // Procesar $result
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
