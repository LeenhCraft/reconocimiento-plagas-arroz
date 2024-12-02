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
        // Obtener datos de entrenamiento
        $model = new TableModel;
        $model->setTable("re_datos_generados");
        $model->setId("identrenamiento");
        $arrDataTrain = $model->where("ent_default", "1")->first();
        // Si no hay datos de entrenamiento
        if (empty($arrDataTrain)) {
            // Crear datos de entrenamiento por defecto
            $arrDataTrain = [
                "stats" => [],
                "yaml" => '{"yaml_path":""}',
                "summary" => []
            ];
        }
        // Limpiar la consulta
        $model->emptyQuery();
        // Obtener configuración
        $model->setTable("re_configuracion");
        $model->setId("idconfig");
        $arrConfig = $model->first();

        $modelModelo = new TableModel;
        $modelModelo->setTable("re_detalle_modelo");
        $modelModelo->setId("id_detalle_modelo");
        $precision = $modelModelo
            ->where("det_default", "1")
            ->first();
        $cantidad = count($modelModelo->all());

        return $this->render($response, 'ModuloIA.Entrenamiento.Entrenamiento', [
            'titulo_web' => 'Entrenamiento',
            "url" => $request->getUri()->getPath(),
            "js" => [
                "/js/moduloIA/entrenamiento.js"
            ],
            "uuid" => $_SESSION["UUID"],
            "datatrain" => $arrDataTrain,
            "config" => $arrConfig,
            "cantidad_modelos" => $cantidad,
            "precision" => $precision["det_precision"] ?? "0",
            "nombre_modelo" => $precision["det_nombre"] ?? "Ninguno",
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
        $pythonPath = $_ENV["PYTHON_PATH"];
        $scriptPath = __DIR__ . "/../ScriptIA/EntrenarYOLO.py";
        // $scriptPath = __DIR__ . "/../ScriptIA/Demo.py";

        // Parámetros de entrenamiento
        $nombre = $rutas["nombre_modelo"] . "_" . $marcaTiempo;
        $arg = [
            '--data' => $arrDataTrain["yaml"]["yaml_path"],
            // '--base-path' => "C:/laragon/www/plagas-arroz/public_html",
            '--output' => $rutas["ruta_modelo"],
            '--name' => $nombre,
            '--epochs' => $rutas["epochs"],
            '--batch-size' => $rutas["batch_size"],
            '--img-size' => $rutas["img_size"],
            '--device' => '0',  // vacío para auto-detección
            '--model-size' => $rutas["model_size"], // n, s, m, l, x
            '--log-file' => "log/train_" . $marcaTiempo . ".log",
            // pesos pre entrenados
            '--weights' => 'models/yolov5n.pt',
        ];

        // Agregar --debug solo si está activo
        $debug = $rutas["debug"]; // o true para ver logs
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
                // $precision = $result["evaluation"]["precision"];
                $precision = $this->getMaxValue($result);

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
                    "det_precision" => $precision * 100,
                    "det_default" => "1",
                    "det_tiempo" => gmdate("H:i:s", $tiempoFin - $tiempoInicio),
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
            return $this->respondWithError($response, $error);
        }
        return $this->respondWithError($response, "Error al ejecutar el entrenamiento, revisar código");
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

    public function store($request, $response)
    {
        $data = $this->sanitize($request->getParsedBody());
        $data["yaml_path"] = str_replace("/", "\\", $data["yaml_path"]);
        $data["path_weights"] = str_replace("/", "\\", $data["path_weights"]);
        if (!isset($data["uuid"]) || $data["uuid"] != $_SESSION["UUID"]) {
            return $this->respondWithError($response, "Error al generar los datos, le sugerimos recargar la página");
        }
        if ($data["uuid"] != $_SESSION["UUID"]) {
            return $this->respondWithError($response, "Error al generar los datos, le sugerimos recargar la página");
        }
        $errors = $this->validar($data);
        if (!$errors) {
            $msg = "Los campos con * son obligatorios.";
            return $this->respondWithError($response, $msg);
        }

        $model = new TableModel;
        $model->setTable("re_configuracion");
        $model->setId("idconfig");

        $arrConfig = $model->first();
        $valores = json_decode($arrConfig["valor"], true);

        if (empty($valores)) {
            return $this->respondWithError($response, "No se encontró la configuración de los datos.");
        }

        $valores["epochs"] = $data["epochs"];
        $valores["img_size"] = $data["img_size"];
        $valores["batch_size"] = $data["batch_size"];
        $valores["model_size"] = $data["model_size"];
        $valores["weights"] = isset($data["weights"]) ? 1 : 0;
        $valores["debug"] = isset($data["debug"]) ? 1 : 0;
        $valores["path_weights"] = $data["path_weights"];

        $respuesta = $model->update($arrConfig["idconfig"], [
            'valor' => json_encode($valores),
        ]);

        if ($respuesta) {
            return $this->respondWithSuccess($response, "Datos guardados con éxito.");
        }
        return $this->respondWithError($response, "Error al guardar los datos.");
    }

    private function validar($data)
    {
        if (empty($data["ruta_modelo"])) {
            return false;
        }
        if (empty($data["nombre_modelo"])) {
            return false;
        }
        if (empty($data["epochs"])) {
            return false;
        }
        if (empty($data["img_size"])) {
            return false;
        }
        if (empty($data["batch_size"])) {
            return false;
        }
        if (empty($data["model_size"])) {
            return false;
        }
        if (isset($data["weights"]) && $data["weights"] != "on") {
            if (empty($data["path_weights"])) {
                return false;
            }
        }
        return true;
    }

    private function getMaxValue($array)
    {
        if (!isset($array['evaluation']['precision']) || empty($array['evaluation']['precision'])) {
            return 0; // o null, dependiendo de tu necesidad
        }
        return max($array['evaluation']['precision']);
    }

    public function list($request, $response)
    {
        $model = new TableModel;
        $model->setTable("re_detalle_modelo");
        $model->setId("id_detalle_modelo");
        $arrData = $model
            ->select(
                "re_detalle_modelo.id_detalle_modelo as id",
                "det_nombre as nombre",
                "det_tiempo as tiempo",
                "det_precision as preci",
                "det_fecha as fecha",
                "re_modelo.mo_nombre as modelo",
                "det_default as def",
            )
            ->leftJoin("re_datos_generados", "re_datos_generados.identrenamiento", "re_detalle_modelo.identrenamiento")
            ->join("re_modelo", "re_modelo.idmodelo", "re_detalle_modelo.idmodelo")
            // ->orderBy("re_detalle_modelo.det_default", "DESC")
            ->get();
        return $this->respondWithJson($response, $arrData);
    }

    public function activarModelo($request, $response)
    {
        $data = $this->sanitize($request->getParsedBody());
        if (!isset($data["id"])) {
            return $this->respondWithError($response, "Error al activar el modelo. El valor del ID es incorrecto.");
        }
        $model = new TableModel;
        $model->setTable("re_detalle_modelo");
        $model->setId("id_detalle_modelo");

        $existe = $model->where("id_detalle_modelo", $data["id"])->first();
        if (empty($existe)) {
            return $this->respondWithError($response, "Error al activar el modelo. El modelo no existe.");
        }

        $model->query("UPDATE re_detalle_modelo SET det_default = 0 WHERE id_detalle_modelo != ?", [$data["id"]]);
        $respuesta = $model->update($data["id"], [
            "det_default" => 1
        ]);
        if ($respuesta) {
            return $this->respondWithSuccess($response, "Modelo activado con éxito.");
        }
        return $this->respondWithError($response, "Error al activar el modelo.");
    }
}
