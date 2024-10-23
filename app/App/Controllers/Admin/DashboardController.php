<?php

namespace App\Controllers\Admin;

use App\Core\Controller;

class DashboardController extends Controller
{
    public function __construct()
    {
        parent::__construct();
    }

    public function index($request, $response, $args)
    {
        return $this->render($response, 'App.Dashboard.Dashboard', [
            'titulo_web' => 'Dashboard',
            "url" => $request->getUri()->getPath()
        ]);
    }
}
