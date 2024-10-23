<?php

// use Slim\App;

// Controllers
use App\Controllers\Home\HomeController;

// Middlewares

$app->get('/', HomeController::class . ':index');