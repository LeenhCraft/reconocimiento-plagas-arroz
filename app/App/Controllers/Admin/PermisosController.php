<?php

namespace App\Controllers\Admin;

use Slim\Csrf\Guard;
use Slim\Psr7\Factory\ResponseFactory;

use App\Core\Controller;
use App\Models\TableModel;

class PermisosController extends Controller
{
    protected $permisos = [];
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
        return $this->render($response, 'App.Permisos.Permisos', [
            'titulo_web' => 'Permisos',
            "url" => $request->getUri()->getPath(),
            "permisos" => $this->permisos,
            "css" => [
                "/vendor/select2/select2/dist/css/select2.min.css",
                "/css/select2-custom.css",
                // 'css/custom.css'
            ],
            "js" => [
                "/vendor/select2/select2/dist/js/select2.full.min.js",
                "/js/admin/nw_permisos.js"
            ],
        ]);
    }

    public function list($request, $response)
    {
        $menuModel = new TableModel;
        $arrData = $menuModel->query("SELECT a.idpermisos AS id, d.rol_nombre AS rol, c.men_nombre AS menu, b.sub_nombre AS submenu, a.perm_r AS r, a.perm_w AS w, a.perm_u AS u, a.perm_d AS d FROM sis_permisos a INNER JOIN sis_submenus b ON a.idsubmenu = b.idsubmenu INNER JOIN sis_menus c ON c.idmenu = b.idmenu INNER JOIN sis_rol d ON a.idrol = d.idrol ORDER BY a.idpermisos DESC
        ")->orderBy("men_orden")->get();
        $nmr = 0;
        for ($i = 0; $i < count($arrData); $i++) {
            $btnView = "";
            $btnEdit = "";
            $btnDelete = "";
            $nmr++;
            // if ($this->permisos['perm_r'] == 1) {
            //     $btnView = '<button class="btn btn-info btn-sm" onClick="fntView(' . $arrData[$i]['idpermisos'] . ')" title="Ver Permisos"><i class="far fa-eye"></i></button>';
            // }
            // if ($this->permisos['perm_u'] == 1) {
            //     $btnEdit = '<button class="btn btn-success btn-sm" onClick="fntEdit(' . $arrData[$i]['idpermisos'] . ')" title="Editar Permisos"><i class="fas fa-pencil-alt"></i></button>';
            // }
            $arrData[$i]['r'] = $this->toggle($arrData[$i]['r'], $arrData[$i]['id'], 20);
            $arrData[$i]['w'] = $this->toggle($arrData[$i]['w'], $arrData[$i]['id'], 21);
            $arrData[$i]['u'] = $this->toggle($arrData[$i]['u'], $arrData[$i]['id'], 22);
            $arrData[$i]['d'] = $this->toggle($arrData[$i]['d'], $arrData[$i]['id'], 23);

            if ($this->permisos['perm_d'] == 1) {
                $btnDelete = '<button class="btn btn-danger btn-sm" onClick="fntDel(' . $arrData[$i]['id'] . ')" title="Eliminar Permisos"><i class="bx bx-minus-circle"></i></button>';
            }

            $arrData[$i]['options'] = '<div class="btn-group text-center" role="group" aria-label="Basic example">' . $btnView . ' ' . $btnEdit . ' ' . $btnDelete . '</div>';
            $arrData[$i]['nmr'] = $nmr;
            $arrData[$i]['menu'] = ucwords($arrData[$i]['menu']);
            $arrData[$i]['submenu'] = ucwords($arrData[$i]['submenu']);
            $arrData[$i]['rol'] = ucwords($arrData[$i]['rol']);
        }
        return $this->respondWithJson($response, $arrData);
    }

    private function toggle($arr, $id, $acc)
    {
        $activo = '';
        /*<div class="form-check form-switch mb-2">
            <input class="form-check-input" type="checkbox" id="flexSwitchCheckDefault">
            <label class="form-check-label" for="flexSwitchCheckDefault">Default switch checkbox input</label>
        </div> */
        $toggle = '<div class="form-check form-switch"><input class="form-check-input" type="checkbox"';
        $end_toggle = ' onclick="fntActv(this,' . $id . ',' . $acc . ')" ></div>';
        if ($arr == 1) {
            $activo = 'checked';
            $arr =  $toggle . $activo . $end_toggle;
        } else {
            $activo = '';
            $arr =  $toggle . $activo . $end_toggle;
        }
        return $arr;
    }

    public function roles($request, $response)
    {
        $model = new TableModel;
        return $this->respondWithJson($response, ["status" => true, "data" => $model->query("SELECT idrol as id, rol_nombre as nombre FROM sis_rol")->get()]);
    }

    public function submenus($request, $response)
    {
        $data = $this->sanitize($request->getParsedBody());
        // return $this->respondWithJson($response, $data);
        $model = new TableModel;
        return $this->respondWithJson($response, ['status' => true, 'data' => $model->query("SELECT idsubmenu as id, sub_nombre as nombre FROM sis_submenus WHERE idmenu = '{$data["idmenu"]}'")->get()]);
    }

    public function menus($request, $response)
    {
        $model = new TableModel;
        return $this->respondWithJson($response, ['status' => true, 'data' => $model->query("SELECT * FROM sis_menus")->get()]);
    }

    public function store($request, $response, $args)
    {
        $data = $this->sanitize($request->getParsedBody());
        // return $this->respondWithJson($response, $data);
        $errors = $this->validar($data);
        if (!$errors) {
            $msg = "Verifique los datos ingresados";
            return $this->respondWithError($response, $msg);
        }
        $model = new TableModel;
        $model->setTable("sis_permisos");
        $model->setId("idpermisos");
        $existe = $model
            ->where("idrol", $data['idrol'])
            ->where("idsubmenu", $data['idsubmenu'])
            ->first();
        if (!empty($existe)) {
            return $this->respondWithError($response, "Ya tiene asigando el submenu al rol actual");
        }
        $rq = $model->create([
            "idrol" => $data["idrol"],
            "idsubmenu" => $data["idsubmenu"],
            "perm_r" => 0,
            "perm_w" => 0,
            "perm_u" => 0,
            "perm_d" => 0,
        ]);
        if (!empty($rq)) {
            return $this->respondWithSuccess($response, "Datos guardados correctamente.");
        }
        return $this->respondWithJson($response, "Error al guardar los datos.");
    }

    private function validar($data)
    {
        if (empty($data["idrol"])) {
            return false;
        }
        if (empty($data["idsubmenu"])) {
            return false;
        }
        return true;
    }

    public function active($request, $response, $args)
    {
        $data = $this->sanitize($request->getParsedBody());
        // return $this->respondWithJson($response, $data);
        // $validate = $this->guard->validateToken($data['csrf_name'], $data['csrf_value']);
        // if (!$validate) {
        //     $msg = "Error de validación, por favor recargue la página";
        //     return $this->respondWithError($response, $msg);
        // }

        $model = new TableModel;
        $model->setTable("sis_permisos");
        $model->setId("idpermisos");
        $dataPermisos = $model->find($data['id']);
        if (!empty($dataPermisos)) {
            switch ($data['ac']) {
                case $data['ac'] == 20:
                    $set = 'perm_r';
                    break;
                case $data['ac'] == 21:
                    $set = 'perm_w';
                    break;
                case $data['ac'] == 22:
                    $set = 'perm_u';
                    break;
                case $data['ac'] == 23:
                    $set = 'perm_d';
                    break;
                default:
                    $set = 'perm_r=0,perm_w=0,perm_u=0,perm_d=0';
                    break;
            }
            $respuesta = $model->update($data['id'], [
                $set => $data['ab'] == 'true' ? '1' : '0',
            ]);
            if (!empty($respuesta)) {
                return $this->respondWithSuccess($response, "Datos guardados correctamente.");
            }
            return $this->respondWithError($response, "Error al guardar los datos.");
        }
        return $this->respondWithError($response, "No se encontraron datos para actualizar.");
    }

    public function delete($reqeust, $response, $args)
    {
        $data = $this->sanitize($reqeust->getParsedBody());
        if (empty($data["id"])) {
            return $this->respondWithError($response, "Error de validación, por favor recargue la página");
        }
        $model = new TableModel;
        $model->setTable("sis_permisos");
        $model->setId("idpermisos");
        $rq = $model->find($data["id"]);
        if (!empty($rq)) {
            $rq = $model->delete($data["id"]);
            if (!empty($rq)) {
                return $this->respondWithSuccess($response, "Datos eliminados correctamente");
            }
            return $this->respondWithError($response, "Error al eliminar los datos");
        }
        return $this->respondWithError($response, "No se encontraron datos para eliminar.");
    }
}
