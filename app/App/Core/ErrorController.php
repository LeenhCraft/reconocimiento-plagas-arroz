<?php

namespace App\Core;

use App\Core\Controller;
use Slim\Psr7\Response;

class ErrorController extends Controller
{
    public function notFound($resquest, $exception, $displayErrorDetails)
    {
        $response = new Response();
        return $this->render($response, '404.404');
    }
}
