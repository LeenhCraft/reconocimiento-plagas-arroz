<?php

namespace App\Controllers\ModuloIA;

use App\Core\Controller;
use App\Models\TableModel;

class GenerarDatosController extends Controller
{
    public function __construct()
    {
        parent::__construct();
    }

    public function index($request, $response)
    {
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
            "data" => $arrData
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
}
