<?php

namespace App\Controllers\Admin;

use App\Core\Controller;
use App\Models\TableModel;
use Slim\Csrf\Guard;
use Slim\Psr7\Factory\ResponseFactory;

class RolesController extends Controller
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
        return $this->render($response, 'App.Usuarios.Roles', [
            'titulo_web' => 'Roles',
            "url" => $request->getUri()->getPath(),
            "permisos" => $this->permisos,
            "js" => ["/js/admin/nw_rol.js"],
            "tk" => [
                "name" => $this->guard->getTokenNameKey(),
                "value" => $this->guard->getTokenValueKey(),
                "key" => $this->guard->generateToken()
            ]
        ]);
    }

    public function list($request, $response)
    {
        $model = new TableModel;
        $model->setTable("sis_rol");
        $model->setId("idrol");
        if ($_SESSION['app_r'] != '1') {
            $model->where("rol_estado", "=", 1);
        }
        $arrData = $model
            ->select(
                "idrol as id",
                "rol_nombre as nombre",
                "rol_estado as estado"
            )
            ->orderBy("rol_nombre")
            ->get();

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
        $errors = $this->validar($data);
        if (!$errors) {
            $msg = "Verifique los datos ingresados";
            return $this->respondWithError($response, $msg);
        }

        $model = new TableModel;
        $model->setTable("sis_rol");
        $model->setId("idrol");

        $existe = $model->where("rol_nombre", "LIKE", $data['name'])->first();
        if (!empty($existe)) {
            $msg = "Ya tiene un usuario registrado con ese nombre";
            return $this->respondWithError($response, $msg);
        }

        $rq = $model->create([
            "rol_cod" => $data["code"],
            "rol_nombre" => ucwords(trim($data['name'])),
            "rol_descripcion" => ucwords(trim($data['description'])),
            "rol_estado" => $data['status'] ?: 0,
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
        if (empty($data["name"])) {
            return false;
        }
        if ($data["status"] != 0 && $data["status"] != 1) {
            return false;
        }
        return true;
    }

    public function search($request, $response)
    {
        $data = $this->sanitize($request->getParsedBody());
        $errors = $this->validarSearch($data);
        if (!$errors) {
            $msg = "Verifique los datos ingresados";
            return $this->respondWithError($response, $msg);
        }
        $model = new TableModel;
        $model->setTable("sis_rol");
        $model->setId("idrol");
        $rq = $model->find($data['id']);
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
        $model->setTable("sis_rol");
        $model->setId("idrol");
        $existe = $model
            ->where("rol_nombre", "LIKE", $data['name'])
            ->where("idrol", "!=", $data['id'])
            ->first();
        if (!empty($existe)) {
            $msg = "Ya tiene un usuario registrado con ese nombre";
            return $this->respondWithError($response, $msg);
        }
        $rq = $model->update($data['id'], [
            "rol_cod" => $data["code"],
            "rol_nombre" => ucwords(trim($data['name'])),
            "rol_descripcion" => ucwords(trim($data['description'])),
            "rol_estado" => $data['status'] ?: 0,
        ]);
        if (!empty($rq)) {
            $msg = "Datos actualizados";
            return $this->respondWithSuccess($response, $msg);
        }
        $msg = "Error al guardar los datos";
        return $this->respondWithJson($response, $existe);
    }

    private function validarUpdate($data)
    {
        if (empty($data["id"])) {
            return false;
        }
        if (empty($data["name"])) {
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
        if (empty($data["id"])) {
            return $this->respondWithError($response, "Error de validación, por favor recargue la página");
        }
        $model = new TableModel;
        $model->setTable("sis_rol");
        $model->setId("idrol");

        $rq = $model->find($data["id"]);
        if (!empty($rq)) {
            $rq = $model
                ->query("SELECT * FROM `sis_usuarios` WHERE `idrol` = {$data["id"]}")
                ->first();
            if (!empty($rq)) {
                $msg = "No se puede eliminar el rol, ya que tiene usuarios asignados.";
                return $this->respondWithError($response, $msg);
            }
            $rq = $model->delete($data["id"]);
            if (!empty($rq)) {
                $msg = "Datos eliminados correctamente";
                return $this->respondWithSuccess($response, $msg);
            }
            $msg = "Error al eliminar los datos";
            return $this->respondWithError($response, $msg);
        }
        $msg = "No se encontraron datos para eliminar.";
        return $this->respondWithError($response, $msg);
    }
}
