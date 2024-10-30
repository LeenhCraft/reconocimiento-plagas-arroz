<?php

namespace App\Controllers\ModuloIA;

use App\Core\Controller;

class EntrenamientoController extends Controller
{
    public function __construct()
    {

        parent::__construct();
    }

    public function index($request, $response)
    {
        return $this->render($response, 'ModuloIA.Entrenamiento.Entrenamiento', [
            'titulo_web' => 'Entrenamiento',
            "url" => $request->getUri()->getPath(),
            "js" => [
                "/js/moduloIA/entrenamiento.js"
            ]
        ]);
    }
}
