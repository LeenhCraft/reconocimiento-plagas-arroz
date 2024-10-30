<?php

namespace App\Controllers\Admin;

use Slim\Csrf\Guard;
use Slim\Psr7\Factory\ResponseFactory;

use App\Core\Controller;
use App\FileHandlers\ImageHandler;
use App\Helpers\Snowflake;
use App\Models\TableModel;

class PersonasController extends Controller
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
        return $this->render($response, 'App.Usuarios.Personal', [
            'titulo_web' => 'Personal',
            "url" => $request->getUri()->getPath(),
            "permisos" => $this->permisos,
            "css" => [
                "/vendor/select2/select2/dist/css/select2.min.css",
                "/css/select2-custom.css",
            ],
            "js" => [
                "/vendor/select2/select2/dist/js/select2.full.min.js",
                "/js/admin/nw_personal.js"
            ],
        ]);
    }

    public function list($request, $response)
    {
        $model = new TableModel;
        $model->setTable("sis_personal");
        $model->setId("idpersona");
        $arrData = $model
            ->select(
                "idpersona as id",
                "per_nombre as nombre",
                "per_email as email",
                "per_estado as estado"
            )
            ->orderBy("per_nombre")
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
        $data["per_foto"] = $_FILES["photo"];
        if (isset($data["id"]) && !empty($data["id"])) {
            return $this->update($request, $response);
        }
        $errors = $this->validar($data);
        if (!$errors) {
            return $this->respondWithError($response, "Verifique los datos ingresados.");
        }
        $model = new TableModel;
        $model->setTable("sis_personal");
        $model->setId("idpersona");
        $existe = $model
            ->where("per_nombre", "LIKE", $data['name'])
            ->where("per_dni", $data['dni'])
            ->where("per_estado", 1)
            ->first();
        if (!empty($existe)) {
            return $this->respondWithError($response, "Ya tiene un usuario registrado con ese nombre.");
        }
        $imagen = "/img/default.png";
        if ($data["per_foto"]["error"] === 0) {
            try {
                $imageHandler = new ImageHandler($data["per_foto"]);
                $responseUpload = $imageHandler
                    ->setName(urls_amigables($data["name"]))
                    ->setMinSize(1024) // Mínimo de 1KB
                    ->setMaxSize(10485760) // Máximo de 10MB
                    ->setMime(['image/jpeg', 'image/png', 'image/gif'])
                    ->setStorage('images/personal', 0755) // Carpeta de almacenamiento
                    ->upload();

                if (!$responseUpload) {
                    return $this->respondWithError($response, $imageHandler->getErrorMessage());
                }
                if ($responseUpload) {
                    $imagen = "/" . $imageHandler->getPath();
                }
            } catch (\Throwable $th) {
                return $this->respondWithError($response, $th->getMessage());
            }
        }

        $dataInsert = [
            "per_dni" => $data["dni"] ?? NULL,
            "per_nombre" => ucwords($data['name']),
            "per_celular" => $data['phone'],
            "per_email" => strtolower($data['email']),
            "per_direcc" => ucwords($data['address']),
            "per_estado" => $data['status'] ?? 0,
            "per_foto" => $imagen,
        ];

        $rq = $model->create($dataInsert);
        if (!empty($rq)) {
            return $this->respondWithSuccess($response, "Datos guardados correctamente");
        }
        return $this->respondWithJson($response, "Error al guardar los datos");
    }

    private function validar($data)
    {
        if (empty($data["dni"])) {
            return false;
        }
        if (empty($data["name"])) {
            return false;
        }
        // if (empty($data["email"])) {
        //     return false;
        // }
        // if (empty($data["phone"])) {
        //     return false;
        // }
        // if (empty($data["address"])) {
        //     return false;
        // }
        // if ($data["status"] != 0 && $data["status"] != 1) {
        //     return false;
        // }
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
        $model->setTable("sis_personal");
        $model->setId("idpersona");
        $rq = $model
            ->select(
                "idpersona as id",
                "per_dni as dni",
                "per_nombre as name",
                "per_celular as phone",
                "per_email as email",
                "per_direcc as address",
                "per_estado as status",
                "per_foto as foto"
            )
            ->find($data['id']);
        if (!empty($rq)) {
            // adjuntar imagen de sis_imagen
            // $objImg = new TableModel;
            // $objImg->setTable("sis_imagenes");
            // $objImg->setId("idimagen");
            // $img = $objImg->where("img_propietario", $rq['idpersona'])->where("img_type", "USER::AVATAR")->first();
            // if (!empty($img)) {
            //     $rq = array_merge($rq, $img);
            // }
            $rq["foto"] = !empty($rq["foto"]) ? $rq["foto"] : "/img/default.png";
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
        $data["per_foto"] = $_FILES["photo"];
        $errors = $this->validarUpdate($data);
        if (!$errors) {
            $msg = "Verifique los datos ingresados";
            return $this->respondWithError($response, $msg);
        }
        $model = new TableModel;
        $model->setTable("sis_personal");
        $model->setId("idpersona");
        $existe = $model
            ->where("idpersona", "!=", $data['id'])
            ->where("per_nombre", "LIKE", $data['name'])
            ->where("per_dni", $data['dni'])
            ->where("per_estado", 1)
            ->first();
        if (!empty($existe)) {
            return $this->respondWithError($response, "Ya tiene un usuario registrado con ese nombre.");
        }
        $imagen = "";
        if ($data["per_foto"]["error"] === 0) {
            try {
                $imageHandler = new ImageHandler($data["per_foto"]);
                $responseUpload = $imageHandler
                    ->setName(urls_amigables($data["name"]))
                    ->setMinSize(1024) // Mínimo de 1KB
                    ->setMaxSize(10485760) // Máximo de 10MB
                    ->setMime(['image/jpeg', 'image/png', 'image/gif'])
                    ->setStorage('images/personal', 0755) // Carpeta de almacenamiento
                    ->upload();

                if (!$responseUpload) {
                    return $this->respondWithError($response, $imageHandler->getErrorMessage());
                }
                if ($responseUpload) {
                    $imagen = "/" . $imageHandler->getPath();
                }
            } catch (\Throwable $th) {
                return $this->respondWithError($response, $th->getMessage());
            }
        }
        $dataUpdate = [
            "per_dni" => $data["dni"] ?? '0',
            "per_nombre" => ucwords($data['name']),
            "per_celular" => $data['phone'] ?? '0',
            "per_email" => strtolower($data['email']),
            "per_direcc" => ucwords($data['address']),
        ];
        if ($imagen) {
            $dataUpdate["per_foto"] = $imagen;
        }
        $rq = $model->update($data['id'], $dataUpdate);
        if (!empty($rq)) {
            // $image = new ImageClass;
            // $img = ['text' => ''];
            // if ($image->verificar($_FILES['photo'])) {
            //     $img = $image->cargarImagenUsuario($_FILES['photo'], $rq, "img/person");
            // }
            // return $this->respondWithSuccess($response, "Datos actualizados correctamente");
            return $this->respondWithJson($response, [
                "status" => true,
                "msg" => "Datos actualizados correctamente",
                "data" => $data
            ]);
        }
        $msg = "Error al guardar los datos";
        return $this->respondWithJson($response, $existe);
    }

    private function validarUpdate($data)
    {
        if (empty($data["id"])) {
            return false;
        }
        if (empty($data["dni"])) {
            return false;
        }
        if (empty($data["name"])) {
            return false;
        }
        // if (empty($data["email"])) {
        //     return false;
        // }
        // if (empty($data["phone"])) {
        //     return false;
        // }
        // if (empty($data["address"])) {
        //     return false;
        // }
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
        $model->setTable("sis_personal");
        $model->setId("idpersona");
        $rq = $model->find($data["id"]);
        if (!empty($rq)) {
            $rq = $model
                ->query("SELECT * FROM `sis_usuarios` WHERE `idpersona` = {$data["id"]}")
                ->first();

            if (!empty($rq)) {
                $msg = "No se puede eliminar el registro, ya que tiene usuarios asociados.";
                return $this->respondWithError($response, $msg);
            }

            if ($_SESSION["app_r"] === 1) {
                $rq = $model->delete($data["id"]);
            } else {
                $rq = $model->update(
                    $data["id"],
                    [
                        "per_estado" => 0
                    ]
                );
            }
            if (!empty($rq)) {
                return $this->respondWithSuccess($response, "Por seguridad, el registro ha sido desactivado");
            }
            return $this->respondWithError($response, "Error al eliminar los datos");
        }
        return $this->respondWithError($response, "No se encontraron datos");
    }
}
