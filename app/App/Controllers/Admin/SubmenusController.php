<?php

namespace App\Controllers\Admin;

use Slim\Csrf\Guard;
use Slim\Psr7\Factory\ResponseFactory;

use App\Core\Controller;

use App\Models\MenuModel;
use App\Models\Admin\SubmenuModel;
use App\Models\TableModel;

class SubMenusController extends Controller
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
        return $this->render($response, 'App.Submenus.Submenus', [
            'titulo_web' => 'Submenus',
            "url" => $request->getUri()->getPath(),
            "permisos" => $this->permisos,
            "js" => ["/js/admin/nw_submenus.js"],
        ]);
    }

    public function list($request, $response)
    {
        $model = new TableModel;
        $model->setTable("sis_submenus");
        $model->setId("idsubmenu");
        $arrData = $model
            ->join("sis_menus", "sis_submenus.idmenu", "sis_menus.idmenu")
            ->orderBy("sis_submenus.idsubmenu", "DESC")
            ->get();
        foreach ($arrData as $key => $value) {
            $arrData[$key]["edit"] = 0;
            $arrData[$key]["delete"] = 0;
            if ($this->permisos['perm_u'] == "1") {
                $arrData[$key]["edit"] = 1;
            }
            if ($this->permisos['perm_d'] == "1") {
                $arrData[$key]["delete"] = 1;
            }
            $arrData[$key]['menu'] = '<i class="bx ' . $arrData[$key]['men_icono'] . '"></i> ' . ucwords($arrData[$key]['men_nombre']);
            $arrData[$key]['url'] = strtolower($arrData[$key]['sub_url']);
            $arrData[$key]['submenu'] = '<i class="bx ' . $arrData[$key]['sub_icono'] . '"></i> ' . ucfirst($arrData[$key]['sub_nombre']);
            $arrData[$key]['orden'] = $arrData[$key]['sub_orden'];
        }
        return $this->respondWithJson($response, $arrData);
    }

    public function store($request, $response)
    {
        $data = $this->sanitize($request->getParsedBody());
        // return $this->respondWithJson($response, $data);
        $errors = $this->validar($data);
        if (!$errors) {
            return $this->respondWithError($response, "Verifique los datos ingresados");
        }
        $model = new TableModel;
        $model->setTable("sis_submenus");
        $model->setId("idsubmenu");
        $existe = $model
            ->where("sub_nombre", "LIKE", $data['name'])
            ->where("idmenu", $data['idmenu'])
            ->first();
        if (!empty($existe)) {
            return $this->respondWithError($response, "Ya tiene un submenu con el mismo nombre");
        }
        $rq = $model->create([
            "idmenu" => $data["idmenu"],
            "sub_nombre" => $data["name"],
            "sub_url" => $data['url'],
            "sub_externo" => isset($data['sub_externo']) && $data['sub_externo'] == "on" ? 1 : 0,
            "sub_controlador" => $data['controller'],
            "sub_icono" => $data['icon'] ?: "bx-circle",
            "sub_orden" => $data['order'] ?: 1,
            "sub_visible" => $data['visible'] ?: 0,
        ]);
        if (!empty($rq)) {
            return $this->respondWithSuccess($response, "Datos guardados correctamente");
        }
        return $this->respondWithJson($response, "Error al guardar los datos");
    }

    private function validar($data)
    {
        if (empty($data["idmenu"])) {
            return false;
        }
        if (empty($data["name"])) {
            return false;
        }
        if (empty($data["url"])) {
            return false;
        }
        if (empty($data["controller"])) {
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
        $model->setTable("sis_submenus");
        $model->setId("idsubmenu");
        $rq = $model
            ->where("idsubmenu", $data["id"])
            ->first();
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

    public function menus($request, $response)
    {
        $model = new TableModel;
        $model->setTable("sis_menus");
        $model->setId("idmenu");
        $arrData = $model
            ->select(
                "idmenu as id",
                "men_nombre as nombre"
            )
            ->orderBy("men_orden")
            ->get();
        return $this->respondWithJson($response, ["status" => true, "data" => $arrData]);
    }

    public function update($request, $response)
    {
        $data = $this->sanitize($request->getParsedBody());
        // return $this->respondWithJson($response, $data);
        $errors = $this->validarUpdate($data);
        if (!$errors) {
            return $this->respondWithError($response, "Verifique los datos ingresados");
        }
        $model = new TableModel;
        $model->setTable("sis_submenus");
        $model->setId("idsubmenu");
        $existe = $model
            ->where("sub_nombre", "LIKE", $data['name'])
            ->where("idsubmenu", "!=", $data['id'])
            ->first();
        if (!empty($existe)) {
            return $this->respondWithError($response, "Ya tiene un submenu con el mismo nombre");
        }
        $rq = $model->update($data['id'], [
            "idmenu" => $data["idmenu"],
            "sub_nombre" => $data["name"],
            "sub_url" => $data['url'],
            "sub_controlador" => $data['controller'],
            "sub_icono" => $data['icon'] ?: "bx-circle",
            "sub_orden" => $data['order'] ?: 1,
            "sub_visible" => $data['visible'] ?: 0,
        ]);
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
        if (empty($data["idmenu"])) {
            return false;
        }
        if (empty($data["name"])) {
            return false;
        }
        if (empty($data["url"])) {
            return false;
        }
        if (empty($data["controller"])) {
            return false;
        }
        return true;
    }

    public function delete($request, $response)
    {
        $data = $this->sanitize($request->getParsedBody());
        if (empty($data["id"])) {
            return $this->respondWithError($response, "Error de validación, por favor recargue la página");
        }
        $model = new TableModel;
        $model->setTable("sis_submenus");
        $model->setId("idsubmenu");
        $rq = $model->find($data["id"]);
        if (!empty($rq)) {
            $model = new TableModel;
            $model->setTable("sis_submenus");
            $model->setId("idsubmenu");
            $arrData = $model
                ->join("sis_permisos", "sis_permisos.idsubmenu", "sis_submenus.idsubmenu")
                ->where("sis_submenus.idsubmenu", $data["id"])
                ->first();
            if (!empty($arrData)) {
                return $this->respondWithError($response, "No se puede eliminar el submenu, ya que tiene permisos asignados");
            }
            $rq = $model->delete($data["id"]);
            if (!empty($rq)) {
                return $this->respondWithSuccess($response, "Datos eliminados correctamente");
            }
            return $this->respondWithError($response, "Error al eliminar los datos");
        }
        return $this->respondWithError($response, "No se encontraron datos para eliminar.");
    }
}
