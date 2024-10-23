<?php

namespace App\Core;

class Controller
{

    public function __construct()
    {
        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }
        centinela();
    }

    public function view($route, $data = [])
    {
        $route = str_replace(".", "/", $route);
        if (file_exists("../app/Resources/{$route}.php")) {
            ob_start();
            include_once "../app/Resources/{$route}.php";
            $content = ob_get_clean();
            return $content;
        } else {
            return "404 el archivo no existe";
        }
    }

    public function render($response, $route, $data = [])
    {
        $payload = $this->view($route, $data);
        $payload = empty($payload) ? "payload vacio, verificar la ruta" : $payload;
        $response->getBody()->write($payload);
        return $response
            ->withHeader('Content-Type', 'text/html')
            ->withStatus(200);
    }

    public function respondWithError($response, $message)
    {
        return $this->respondWithJson($response, ["status" => false, "message" => $message]);
    }

    public function respondWithSuccess($response, $message)
    {
        return $this->respondWithJson($response, ["status" => true, "message" => $message]);
    }

    public function respondWithJson($response, $data)
    {
        $payload = json_encode($data);
        $response->getBody()->write($payload);
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withStatus(200);
    }

    public function sanitize($data)
    {
        if (empty($data)) {
            return $data;
        }
        foreach ($data as $key => $value) {
            if (is_array($value)) {
                $data[$key] = $this->sanitize($value);
                continue;
            }
            if (preg_match('/^(http|https):\/\/\S+$/i', $value) || preg_match('/(http|https):\/\/\S+/i', $value)) {
                $data[$key] = $value;
            } else {
                $cleanedValue = $this->extractAndCleanURLs($value);
                $data[$key] = $cleanedValue;
            }
        }
        return $data;
    }

    private function extractAndCleanURLs($text)
    {
        $cleanedText = preg_replace_callback('/(http|https):\/\/\S+/i', function ($match) {
            return strClean($match[0]);
        }, $text);
        $cleanedText = strClean($cleanedText);
        return $cleanedText;
    }

    public function get_method($cadena)
    {
        $methodName = explode('::', $cadena);
        return end($methodName);
    }

    public function className($cadena)
    {
        $cadena = get_class($cadena);
        $class = explode('\\', $cadena);
        return end($class);
    }
}
