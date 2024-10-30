<?php

namespace App\Controllers\ModuloIA;

use App\Core\Controller;

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
}