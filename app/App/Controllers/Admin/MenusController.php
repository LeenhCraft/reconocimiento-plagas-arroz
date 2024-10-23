<?php

namespace App\Controllers\Admin;

use Slim\Csrf\Guard;
use Slim\Psr7\Factory\ResponseFactory;

use App\Core\Controller;
use App\Models\TableModel;

class MenusController extends Controller
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
        return $this->render($response, 'App.Menus.Menus', [
            'titulo_web' => 'Menus',
            "url" => $request->getUri()->getPath(),
            "permisos" => $this->permisos,
            "js" => ["/js/admin/nw_menus.js"],
        ]);
    }

    public function list($request, $response)
    {
        $model = new TableModel;
        $model->setTable("sis_menus");
        $model->setId("idmenu");
        $arrData = $model
            ->orderBy("men_orden")
            ->get();

        foreach ($arrData as $key => $row) {
            $arrData[$key]["edit"] = 0;
            $arrData[$key]["delete"] = 0;

            if ($this->permisos['perm_u'] == "1") {
                $arrData[$key]["edit"] = 1;
            }
            if ($this->permisos['perm_d'] == "1") {
                $arrData[$key]["delete"] = 1;
            }
        }
        return $this->respondWithJson($response, $arrData);
    }

    public function store($request, $response, $args)
    {
        $data = $this->sanitize($request->getParsedBody());
        $errors = $this->validar($data);
        if (!$errors) {
            $msg = "Verifique los datos ingresados";
            return $this->respondWithError($response, $msg);
        }

        $model = new TableModel;
        $model->setTable("sis_menus");
        $model->setId("idmenu");
        $existe = $model
            ->where("men_nombre", $data['name'])
            ->first();
        if (!empty($existe)) {
            $msg = "El nombre del menú ya existe";
            return $this->respondWithError($response, $msg);
        }

        $rq = $model->create([
            "men_nombre" => ucfirst($data['name']) ?? "UNDEFINED",
            "men_url" => $data['url'] ?? "#",
            "men_controlador" => $data['controller'] ?? null,
            // "men_icono" => !empty($data['icon']) ? $data['icon'] : "bx-circle",
            "men_icono" => $data['icon'] ?: "bx-circle",
            "men_url_si" => isset($data['url_si']) && $data['url_si'] == "on" ? '1' : "0",
            "men_orden" => $data['order'] ?: '1',
            "men_visible" => $data['visible'] ?: "0"
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
        if (isset($data['url_si']) && $data['url_si'] == "on") {
            if (empty($data["url"])) {
                return false;
            }
            if (empty($data["controller"])) {
                return false;
            }
        }
        if (empty($data["visible"])) {
            return false;
        }
        return true;
    }

    public function search($request, $response)
    {
        $data = $this->sanitize($request->getParsedBody());

        $errors = $this->validarSearch($data);
        if (!$errors) {
            return $this->respondWithError($response, "Verifique los datos ingresados");
        }
        $model = new TableModel;
        $model->setTable("sis_menus");
        $model->setId("idmenu");
        $rq = $model->find($data['id']);
        if (!empty($rq)) {
            return $this->respondWithJson($response, ["status" => true, "data" => $rq]);
        }
        return $this->respondWithError($response, "No se encontraron datos");
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
        $data = $this->sanitize($request->getParsedBody());
        $errors = $this->validarUpdate($data);
        if (!$errors) {
            $msg = "Verifique los datos ingresados";
            return $this->respondWithError($response, $msg);
        }

        $model = new TableModel;
        $model->setTable("sis_menus");
        $model->setId("idmenu");
        $existe = $model
            ->where("men_nombre", "LIKE", $data['name'])
            ->where("idmenu", "!=", $data['id'])->first();
        if (!empty($existe)) {
            $msg = "Ya tiene un submenu con el mismo nombre";
            return $this->respondWithError($response, $msg);
        }

        $rq = $model->update($data['id'], [
            "men_nombre" => ucfirst($data['name']) ?? "UNDEFINED",
            "men_url" => $data['url'] ?? "#",
            "men_controlador" => $data['controller'] ?? null,
            // "men_icono" => !empty($data['icon']) ? $data['icon'] : "bx-circle",
            "men_icono" => $data['icon'] ?: "bx-circle",
            "men_url_si" => isset($data['url_si']) && $data['url_si'] == "on" ? '1' : "0",
            "men_orden" => $data['order'] ?: '1',
            "men_visible" => $data['visible'] ?: "0"
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
        if (isset($data['url_si']) && $data['url_si'] == "on") {
            if (empty($data["url"])) {
                return false;
            }
            if (empty($data["controller"])) {
                return false;
            }
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
        $model->setTable("sis_menus");
        $model->setId("idmenu");
        $rq = $model->find($data["id"]);
        if (!empty($rq)) {
            $menusModel = new TableModel;
            $menusModel->setTable("sis_menus");
            $menusModel->setId("idmenu");
            $arrData = $menusModel
                ->select("sis_menus.men_nombre")
                ->join("sis_submenus", "sis_menus.idmenu", "sis_submenus.idmenu")
                ->join("sis_permisos ", "sis_submenus.idsubmenu", "sis_permisos.idsubmenu")
                ->where("sis_menus.idmenu", $data["id"])
                ->get();
            if (!empty($arrData)) {
                return $this->respondWithError($response, "No se puede eliminar el menú, tiene submenus o permisos asociados");
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
