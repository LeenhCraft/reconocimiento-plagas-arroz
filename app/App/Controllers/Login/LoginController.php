<?php

namespace App\Controllers\Login;

use App\Core\Controller;
use App\Models\TableModel;

class LoginController extends Controller
{
    public function __construct()
    {
        parent::__construct();
    }

    public function index($request,  $response, $args)
    {
        return $this->render($response, "App.Login.Login", [
            "titulo_web" => "Iniciar Sesión",
            "url" => $request->getUri()->getPath(),
            "js" => [
                "/js/admin/login.js"
            ]
        ]);
    }

    public function store($request, $response)
    {
        $data = $this->sanitize($request->getParsedBody());
        $errors = $this->validar($data);
        if (!$errors) {
            $msg = "Verifique los datos ingresados";
            return $this->respondWithError($response, $msg);
        }
        $model = new TableModel;
        $model->setTable("sis_usuarios");
        $model->setId("idusuario");
        $userData = $model
            ->select(
                "sis_usuarios.idusuario",
                "sis_usuarios.idrol",
                "sis_usuarios.usu_usuario",
                "sis_usuarios.usu_pass",
                "sis_usuarios.usu_estado",
                "sis_usuarios.usu_activo",
                "sis_personal.per_nombre",
            )
            ->join("sis_personal", "sis_usuarios.idpersona", "sis_personal.idpersona")
            ->where('usu_usuario', "LIKE", $data['email'])
            ->first();
        if (empty($userData)) {
            return $this->respondWithError($response, "El usuario o contraseña son incorrectos.");
        }
        if (!password_verify($data["password"], $userData["usu_pass"])) {
            return $this->respondWithError($response, "El usuario o contraseña son incorrectos.");
        }
        if ($userData["usu_estado"] == 0) {
            return $this->respondWithError($response, "El usuario se encuentra deshabilitado.");
        }
        if ($userData["usu_estado"] == 1 && $userData["usu_activo"] == 1) {
            $_SESSION['app_id'] = $userData['idusuario'];
            $_SESSION['app_r'] = $userData['idrol'];
            $_SESSION['app_session'] = true;
            $_SESSION["app_user"] = $userData["per_nombre"];
            return $this->respondWithJson($response, ["status" => true, "message" => "Bienvenido!!", "data" => $userData["per_nombre"]]);
        }
        return $this->respondWithError($response, "Error inesperado.");
    }

    private function validar($data)
    {
        // if (empty($data["email"]) || !filter_var($data["email"], FILTER_VALIDATE_EMAIL)) {
        //     return false;
        // }
        if (empty($data["email"])) {
            return false;
        }
        if (empty($data["password"])) {
            return false;
        }
        return true;
    }
}
