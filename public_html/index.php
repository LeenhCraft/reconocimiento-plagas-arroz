<?php
date_default_timezone_set('America/Lima');

// Slim

use Slim\Factory\AppFactory;
use Psr\Http\Message\ServerRequestInterface;
use Slim\Exception\HttpNotFoundException;
use Slim\Exception\HttpMethodNotAllowedException;
use Slim\Psr7\Response;

// Controller
use App\Core\ErrorController;

require_once '../app/vendor/autoload.php';
require_once '../app/App/Helpers/Helpers.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/../app');
$dotenv->load();
$app = AppFactory::create();

$app->addBodyParsingMiddleware();
$app->addRoutingMiddleware();

$errorMiddleware = $app->addErrorMiddleware(true, true, true);
$errorMiddleware->setErrorHandler(
    HttpNotFoundException::class,
    ErrorController::class . ':notFound'
);

$errorMiddleware->setErrorHandler(
    HttpMethodNotAllowedException::class,
    function (ServerRequestInterface $request, Throwable $exception, bool $displayErrorDetails) {
        $response = new Response();
        $response->getBody()->write('405 NOT ALLOWED');

        return $response->withStatus(405);
    }
);

require_once __DIR__ . '/../app/Routes/Web.php';
require_once __DIR__ . '/../app/Routes/Admin.php';

$app->run();
