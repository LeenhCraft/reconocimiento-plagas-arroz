<?php

// use Slim\App;

// Controllers
use App\Controllers\Login\LoginController;

// Middlewares
use App\Middleware\AdminMiddleware;

$app->get('/', LoginController::class . ':index')->add(new AdminMiddleware);
