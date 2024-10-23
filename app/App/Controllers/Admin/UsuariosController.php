<?php

namespace App\Controllers\Admin;

use App\Core\Controller;
use App\Models\TableModel;
use Slim\Csrf\Guard;
use Slim\Psr7\Factory\ResponseFactory;

class UsuariosController extends Controller
{
    protected $permisos;
    protected $responseFactory;
    protected $guard;

    public function __construct()
    {
        parent::__construct();
        $this->permisos = getPermisos($this->className($this));
        $this->responseFactory = new ResponseFactory();
        $this->guard = new Guard($this->responseFactory);
    }

    public function index($request, $response)
    {
        return $this->render($response, 'App.Usuarios.usuarios', [
            'titulo_web' => 'Usuarios',
            "url" => $request->getUri()->getPath(),
            "permisos" => $this->permisos,
            "css" => [
                "/vendor/select2/select2/dist/css/select2.min.css",
                "/css/select2-custom.css",
            ],
            "js" => [
                "/vendor/select2/select2/dist/js/select2.full.min.js",
                "/js/admin/nw_usu.js"
            ],
        ]);
    }

    public function list($request, $response)
    {
        if ($this->permisos['perm_r'] !== "1") {
            return $this->respondWithError($response, "No tiene permisos para realizar esta acción");
        }
        $model = new TableModel;
        $model->setTable("sis_usuarios");
        $model->setId("idusuario");
        $arrData = $model
            ->select(
                "sis_usuarios.idusuario as id",
                "sis_usuarios.usu_usuario as user",
                "sis_rol.rol_nombre as rol",
                "sis_usuarios.usu_activo as activo",
                "sis_usuarios.usu_estado as estado",
            )
            ->join("sis_rol", "sis_usuarios.idrol", "sis_rol.idrol")
            ->get();

        $num = 1;
        for ($i = 0; $i < count($arrData); $i++) {
            $arrData[$i]['delete'] = 0;
            $arrData[$i]['edit'] = 0;

            if ($this->permisos['perm_d'] == 1) {
                $arrData[$i]['delete'] = 1;
            }

            if ($this->permisos['perm_u'] == 1) {
                $arrData[$i]['edit'] = 1;
            }
        }
        return $this->respondWithJson($response, $arrData);
    }

    public function store($request, $response)
    {
        if ($this->permisos['perm_w'] !== "1") {
            return $this->respondWithError($response, "No tiene permisos para realizar esta acción");
        }
        $data = $this->sanitize($request->getParsedBody());
        if (isset($data["id"]) && !empty($data["id"])) {
            return $this->update($request, $response);
        }
        // return $this->respondWithJson($response, $data);
        $errors = $this->validar($data);
        if (!$errors) {
            $msg = "Verifique los datos ingresados";
            return $this->respondWithError($response, $msg);
        }

        $model = new TableModel;
        $model->setTable("sis_usuarios");
        $model->setId("idusuario");
        $existe = $model
            ->where("usu_usuario", "LIKE", $data['user'])
            ->first();
        if (!empty($existe)) {
            $msg = "Existe un usuario con el mismo nombre";
            return $this->respondWithError($response, $msg);
        }

        $rq = $model->create([
            "idrol" => $data["idrol"],
            "idpersona" => ucwords($data['idpersona']),
            "usu_usuario" => $data['user'],
            "usu_pass" => password_hash($data['password'], PASSWORD_DEFAULT),
            "usu_activo" => $data['status'] ?: 0,
            "usu_primera" => 0,
            "usu_twoauth" => 0,
            "usu_code_twoauth" => 0,
            "usu_estado" => 1,
        ]);
        if (!empty($rq)) {
            $msg = "Datos guardados correctamente";
            return $this->respondWithSuccess($response, $msg);
        }
        $msg = "Error al guardar los datos";
        return $this->respondWithJson($response, $existe);
    }

    private function validar($data)
    {
        if (empty($data["idpersona"])) {
            return false;
        }
        if (empty($data["user"])) {
            return false;
        }
        if (empty($data["password"])) {
            return false;
        }
        if (empty($data["idrol"])) {
            return false;
        }
        if ($data["status"] != 0 && $data["status"] != 1) {
            return false;
        }
        return true;
    }

    public function search($request, $response)
    {
        if ($this->permisos['perm_r'] !== "1") {
            return $this->respondWithError($response, "No tiene permisos para realizar esta acción");
        }
        $data = $this->sanitize($request->getParsedBody());
        $errors = $this->validarSearch($data);
        if (!$errors) {
            $msg = "Verifique los datos ingresados";
            return $this->respondWithError($response, $msg);
        }

        $model = new TableModel;
        $model->setTable("sis_usuarios");
        $model->setId("idusuario");
        $rq = $model
            ->select(
                "sis_usuarios.idusuario",
                "sis_usuarios.idpersona",
                "sis_usuarios.usu_usuario",
                "sis_usuarios.usu_estado",
                "sis_usuarios.idrol",
            )
            ->find($data['id']);
        if (!empty($rq)) {
            return $this->respondWithJson($response, ["status" => true, "data" => $rq]);
        }
        $msg = "No se encontraron datos";
        return $this->respondWithError($response, $msg);
    }

    public function validarSearch($data)
    {
        if (empty($data["id"])) {
            return false;
        }
        return true;
    }

    public function update($request, $response)
    {
        if ($this->permisos['perm_u'] !== "1") {
            return $this->respondWithError($response, "No tiene permisos para realizar esta acción");
        }
        $data = $this->sanitize($request->getParsedBody());
        $errors = $this->validarUpdate($data);
        if (!$errors) {
            $msg = "Verifique los datos ingresados";
            return $this->respondWithError($response, $msg);
        }
        $model = new TableModel;
        $model->setTable("sis_usuarios");
        $model->setId("idusuario");
        $existe = $model
            ->where("usu_usuario", "LIKE", $data['user'])
            ->where("idusuario", "!=", $data['id'])
            ->first();
        if (!empty($existe)) {
            return $this->respondWithError($response, "Ya tiene un usuario registrado con ese nombre");
        }
        $columns = [
            "idrol" => $data["idrol"],
            "idpersona" => intval($data['idpersona']),
            "usu_usuario" => $data['user'],
            "usu_estado" => $data['status'] ?? 0,
            "usu_activo" => 1,
        ];

        if (!empty($data['password'])) {
            $columns['usu_pass'] = password_hash($data['password'], PASSWORD_DEFAULT);
        }

        $rq = $model->update($data['id'], $columns);
        if (!empty($rq)) {
            return $this->respondWithSuccess($response, "Datos actualizados");
        }
        return $this->respondWithJson($response, "Error al guardar los datos");
    }

    private function validarUpdate($data)
    {
        if (empty($data["id"])) {
            return false;
        }
        if (empty($data["idpersona"])) {
            return false;
        }
        if (empty($data["user"])) {
            return false;
        }
        if (empty($data["idrol"])) {
            return false;
        }
        if ($data["status"] != 0 && $data["status"] != 1) {
            return false;
        }
        return true;
    }

    public function delete($request, $response)
    {
        if ($this->permisos['perm_d'] !== "1") {
            return $this->respondWithError($response, "No tiene permisos para realizar esta acción");
        }
        $data = $this->sanitize($request->getParsedBody());
        if (isset($data["id"]) && empty($data["id"])) {
            return $this->respondWithError($response, "Error de validación, por favor recargue la página");
        }
        $model = new TableModel;
        $model->setTable("sis_usuarios");
        $model->setId("idusuario");
        $rq = $model->find($data["id"]);
        if (!empty($rq)) {
            $rq = $model->delete($data["id"]);
            if (!empty($rq)) {
                return $this->respondWithSuccess($response, "Datos eliminados correctamente.");
            }
            return $this->respondWithError($response, "Error al eliminar los datos.");
        }
        return $this->respondWithError($response, "No se encontraron datos para eliminar.");
    }

    public function roles($request, $response)
    {
        $model = new TableModel;
        return $this->respondWithJson(
            $response,
            [
                "status" => true,
                "data" => $model
                    ->query("SELECT idrol as id, rol_nombre as nombre FROM sis_rol ORDER BY idrol DESC")
                    ->get()
            ]
        );
    }

    public function person($request, $response)
    {
        $model = new TableModel;
        return $this->respondWithJson(
            $response,
            [
                "status" => true,
                "data" => $model
                    ->query("SELECT idpersona as id, per_nombre as nombre FROM sis_personal WHERE per_estado = 1")
                    ->get()
            ]
        );
    }
}
