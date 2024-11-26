<?php

namespace App\Controllers\ModuloIA;

use App\Core\Controller;
use App\Models\TableModel;
use Exception;

class GenerarDatosController extends Controller
{
    protected $uuid;

    public function __construct()
    {
        parent::__construct();
    }

    public function index($request, $response)
    {
        $_SESSION["UUID"] = uniqid("csrf_token_", true);
        $model = new TableModel;
        $model->setTable("re_configuracion");
        $model->setId("idconfig");
        $textdata = $model->first();
        if (empty($textdata)) {
            $textdata = [
                'valor' => '{"carpeta_img_entrenamiento":"","ruta_datos_entrenamiento":"","nombre_datos_entrenamiento":""}'
            ];
        }
        $arrData = json_decode($textdata['valor'], true);
        return $this->render($response, 'ModuloIA.GenerarDatos.GenerarDatos', [
            'titulo_web' => 'Generar Datos',
            "url" => $request->getUri()->getPath(),
            "js" => [
                "/js/moduloIA/generarDatos.js"
            ],
            "data" => $arrData,
            "uuid" => $_SESSION["UUID"]
        ]);
    }

    public function store($request, $response, $args)
    {
        $data = $this->sanitize($request->getParsedBody());
        $errors = $this->validar($data);
        if (!$errors) {
            return $this->respondWithError($response, "Los campos con * son obligatorios");
        }

        $model = new TableModel;
        $model->setTable("re_configuracion");
        $model->setId("idconfig");
        $textdata = $model->first();
        $arrData = json_decode($textdata['valor'], true);
        $arrData["carpeta_img_entrenamiento"] = $data["carpeta_img_entrenamiento"];
        $arrData["ruta_datos_entrenamiento"] = $data["ruta_datos_entrenamiento"];
        $arrData["nombre_datos_entrenamiento"] = urls_amigables($data["nombre_datos_entrenamiento"]);
        $arrData["ruta_datos_generados"] = $data["ruta_datos_generados"];
        $rq = $model->update($textdata['idconfig'], [
            'valor' => json_encode($arrData),
        ]);
        $msg = (!empty($rq)) ? "Datos actualizados" : "Error al guardar los datos";
        return (!empty($rq)) ? $this->respondWithSuccess($response, $msg) : $this->respondWithError($response, $msg);
    }

    private function validar($data)
    {
        return true;
    }

    public function generarDatos($request, $response)
    {
        $data = $this->sanitize($request->getParsedBody());
        // dep(["uuid" => $_SESSION["UUID"], "data" => $data], 1);
        if (!isset($data["uuid"]) || $data["uuid"] != $_SESSION["UUID"]) {
            return $this->respondWithError($response, "Error al generar los datos, le sugerimos recargar la página");
        }
        // compara uuid del front con el uuid del back
        if ($data["uuid"] != $_SESSION["UUID"]) {
            return $this->respondWithError($response, "Error al generar los datos, le sugerimos recargar la página");
        }

        // obtener rutas de los datos
        $model = new TableModel;
        $model->setTable("re_configuracion");
        $model->setId("idconfig");
        $textdata = $model->first();
        if (empty($textdata)) {
            return $this->respondWithError($response, "No existe una configuración para las rutas de los datos");
        }
        $rutas = json_decode($textdata['valor'], true);
        // END - obtener rutas de los datos

        // Obtener las clases de plagas y guardarlas en un json
        $modelEnfer = new TableModel;
        $modelEnfer->setTable("re_enfermedades");
        $modelEnfer->setId("idenfermedad");
        $classes = $modelEnfer
            ->select("nombre")
            ->orderBy("nombre")
            ->where("desactivado", "0")
            ->get();

        $nombres = [];
        foreach ($classes as $item) {
            $nombres[] = $item['nombre'];
        }
        $marcaTiempo = date("YmdHis");
        $jsoncreado = $this->crearJson([
            "path" => $rutas["ruta_datos_generados"],
            // "nombre_archivo" => uniqid("clases_", true),
            "nombre_archivo" => "clases_plagas_" . $marcaTiempo,
            // "nombre_archivo" => "Clases",
            "contenido" => json_encode($nombres)
        ]);
        // END - Obtener las clases de plagas y guardarlas en un json

        // Ejecutar script de python para generar los datos
        $pythonPath = $_ENV["PYTHON_PATH"];
        $scriptPath = __DIR__ . "/../ScriptIA/GenerarDatos.py";
        $arg = [
            '--images' => $rutas["carpeta_img_entrenamiento"],
            '--output' => $rutas["ruta_datos_entrenamiento"] . "/" . $marcaTiempo, // carpeta de salida cuando se generan los datos
            // '--output' => $rutas["ruta_datos_entrenamiento"] . "/Clases", // carpeta de salida cuando se hacen pruebas
            '--classes' => $jsoncreado["ruta_completa"],
            '--val-split' => 0.2
        ];

        // Agregar --debug solo si es true
        $debug = false; // o true para activar depuración
        if ($debug) {
            $arg['--debug'] = '';  // --debug no necesita valor
        }

        $command = sprintf(
            '"%s" %s %s',
            escapeshellcmd($pythonPath),
            escapeshellarg($scriptPath),
            implode(' ', array_map(
                function ($key, $value) {
                    // Si el valor está vacío (como en --debug), solo retornar la clave
                    return empty($value) ? $key : sprintf('%s %s', $key, escapeshellarg($value));
                },
                array_keys($arg),
                array_values($arg)
            ))
        );

        // $command = sprintf('"%s" "%s"', $pythonPath, $scriptPath);

        // Ejecutar comando
        $output = [];
        $returnVar = 0;
        // exec($command . " 2>&1", $output, $returnVar);
        exec($command, $output, $returnVar);
        // dep([
        //     "command" => $command,
        //     "output" => $output,
        // ], 1);
        // decodificar el json
        $salida = json_decode(implode("\n", $output), true);

        // Procesar respuesta
        if ($returnVar !== 0) {
            return $this->respondWithJson($response, [
                'status' => false,
                'message' => 'Error al generar los datos',
                'output' => $output,
                'returnVar' => $returnVar
            ]);
        }

        $model = new TableModel;
        $model->setTable("re_datos_generados");
        $model->setId("identrenamiento");
        $dataInsert = [
            "code" => $marcaTiempo,
            "stats" => json_encode($salida["stats"]),
            "yaml" => json_encode($salida["yaml"]),
            "summary" => json_encode($salida["summary"]),
            "ent_default" => "1"
        ];

        $rq = $model->create($dataInsert);
        $model->query("UPDATE re_datos_generados SET ent_default = 0 WHERE identrenamiento != ?", [$rq["identrenamiento"]]);

        return $this->respondWithJson($response, $salida);
    }

    private function crearJson($data)
    {
        try {
            // Definir el nombre del archivo y ruta
            $nombreArchivo = $data["nombre_archivo"] . ".json";

            // Crear el directorio si no existe
            if (!file_exists($data["path"])) {
                mkdir($data["path"], 0777, true);
            }

            $rutaCompleta = $data["path"] . $nombreArchivo;

            // Abrir/crear el archivo en modo escritura
            $archivo = fopen($rutaCompleta, "w");

            // Escribir el contenido en el archivo
            fwrite($archivo, $data["contenido"]);

            // Cerrar el archivo
            fclose($archivo);

            return [
                'success' => true,
                'mensaje' => "Archivo creado exitosamente",
                'nombre_archivo' => $nombreArchivo,
                'ruta_completa' => $rutaCompleta
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'mensaje' => "Error al crear el archivo: " . $e->getMessage()
            ];
        }
    }

    public function list($request, $response)
    {
        $model = new TableModel;
        $model->setTable("re_datos_generados");
        $model->setId("identrenamiento");
        return $this->respondWithJson($response, $model
            ->orderBy("fecha_registro", "DESC")
            ->get());
    }
}
