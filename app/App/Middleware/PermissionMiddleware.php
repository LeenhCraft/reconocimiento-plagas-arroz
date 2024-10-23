<?php

namespace App\Middleware;

use App\Models\TableModel;
use JetBrains\PhpStorm\Deprecated;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;
use Slim\Psr7\Response;
use Slim\Routing\RouteContext;

class PermissionMiddleware
{
    public function __invoke(Request $request, RequestHandler $handler)
    {
        $routeContext = RouteContext::fromRequest($request);
        $routeData = $routeContext->getRoute();
        $routeCallable = $routeData->getCallable();
        $routeCallable = str_replace("\\", "/", $routeCallable);
        $routeArray = explode('/', $routeCallable);
        $explode = explode(':', end($routeArray));
        $route = $explode[0];
        $method = $explode[1];
        // dep([$route, $method]);

        $model = new TableModel;
        $permisos = $model->query("SELECT b.* FROM sis_submenus a INNER JOIN sis_permisos b ON a.idsubmenu=b.idsubmenu WHERE a.sub_controlador=? AND b.idrol = ?", [$route, $_SESSION['app_r']])->first();
        // echo "Ruta actual: $path<br>";
        // dep($request->getMethod());
        // dep($permisos, 1);

        if (empty($permisos)) {
            $response = new Response();
            return $response
                ->withHeader('Location', base_url() . 'admin')
                ->withStatus(302);
        }
        if (!isset($permisos['perm_r']) || $permisos['perm_r'] != 1) {
            $response = new Response();
            return $response
                ->withHeader('Location', base_url() . 'admin')
                ->withStatus(302);
        }

        $response = $handler->handle($request);
        return $response;
    }
}
