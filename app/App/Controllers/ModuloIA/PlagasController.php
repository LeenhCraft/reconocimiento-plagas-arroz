<?php

namespace App\Controllers\ModuloIA;

use App\Core\Controller;
use App\Core\ErrorController;
use App\FileHandlers\ImageHandler;
use App\Models\TableModel;

class PlagasController extends Controller
{
    protected $permisos = [];

    public function __construct()
    {
        parent::__construct();
        $this->permisos = getPermisos($this->className($this));
    }

    public function index($request, $response)
    {
        $js = [];
        if ($this->permisos['perm_w'] == 1 || $this->permisos['perm_u'] == 1) {
            $js = [
                '/js/ckeditor/ckeditor.js',
                "/js/moduloIA/inicializarCkeditor.js",
                '/js/moduloIA/addplagas.js'
            ];
        }

        $js[] = '/js/moduloIA/plagas.js';
        return $this->render($response, 'ModuloIA.Plagas.Plagas', [
            'titulo_web' => 'Plagas',
            "url" => $request->getUri()->getPath(),
            'permisos' => $this->permisos,
            'css' => ['/css/spinkit.css'],
            'js' => $js,
            'list' => $this->listGet()
        ]);
    }

    private function listGet()
    {
        $model = new TableModel;
        $model->setTable("re_enfermedades");
        $model->setId("idenfermedad");
        return $model
            ->where("desactivado", "0")
            ->orderBy("idenfermedad", "DESC")
            ->paginate(10);
    }

    public function store($request, $response, $args)
    {
        $data = $this->sanitize($request->getParsedBody());
        $data["foto"] = $_FILES["es_imagen_url"];
        if (isset($data["nombre"]) && empty($data["nombre"])) {
            return $this->respondWithError($response, "Todos los campos con (*) son obligatorios.");
        }
        $model = new TableModel;
        $model->setTable("re_enfermedades");
        $model->setId("idenfermedad");
        $existe = $model->where("nombre", "LIKE", $data["nombre"])->where("desactivado", "0")->first();
        if ($existe) {
            return $this->respondWithError($response, "Ya existe una plaga o enfermedad con el nombre: {$data['nombre']}");
        }
        $imagen = "/img/default.png";
        if ($data["foto"]["error"] === 0) {
            try {
                $imageHandler = new ImageHandler($data["foto"]);
                $responseUpload = $imageHandler
                    ->setName(urls_amigables($data["nombre"]))
                    ->setMinSize(1024) // Mínimo de 1KB
                    ->setMaxSize(10485760) // Máximo de 10MB
                    ->setMime(['image/jpeg', 'image/png', 'image/gif'])
                    ->setStorage('img/enfermedades', 0755) // Carpeta de almacenamiento
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

        $rq = $model->create([
            "nombre" => $data["nombre"],
            "slug" => urls_amigables($data["nombre"]),
            "imagen_url" => $imagen,
            "descripcion" => $data["description"],
        ]);
        if (!empty($rq)) {
            return $this->respondWithSuccess($response, "Datos guardados correctamente");
        }
        return $this->respondWithJson($response, "Error al guardar los datos");
    }

    /**
     * Muestra la vista individual de un registro
     */
    public function verPlaga($request, $response)
    {
        $model = new TableModel;
        $model->setTable("re_enfermedades");
        $model->setId("idenfermedad");
        $url = $request->getUri()->getPath();
        $slug = explode("/", $url);
        $data = $model
            ->where("desactivado", "0")
            ->where("slug", "LIKE", end($slug))
            ->first();
        if (empty($data)) {
            $error = new ErrorController;
            return $error->notFound($request, $response, true);
        }

        $model->emptyQuery();
        $model->setTable("re_configuracion");
        $model->setId("idconfig");

        $url = '/' . $slug[1] . '/' . $slug[2];
        return $this->render($response, "ModuloIA.Plagas.VerPlaga", [
            "titulo_web" => $data["nombre"] . ":.",
            "url" => $url,
            "permisos" => $this->permisos,
            // 'css' => ['css/app/dropzone.css'],
            "js" => [
                "/js/dropzone-min.js",
                "/js/ckeditor/ckeditor.js",
                "/js/moduloIA/inicializarCkeditor.js",
                "/js/moduloIA/verplagas.js"
            ],
            "data" => $data
        ]);
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
        $model->setTable("re_enfermedades");
        $model->setId("idenfermedad");
        $rq = $model->find($data['idenfermedad']);
        if (!empty($rq)) {
            return $this->respondWithJson($response, ["status" => true, "data" => $rq]);
        }
        return $this->respondWithError($response, "No se encontraron datos");
    }

    public function validarSearch($data)
    {
        if (empty($data["idenfermedad"])) {
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
        $data["foto"] = $_FILES["es_imagen_url"];
        $errors = $this->validarUpdate($data);
        if (!$errors) {
            return $this->respondWithError($response, "Los datos don * son obligatorios");
        }
        $model = new TableModel;
        $model->setTable("re_enfermedades");
        $model->setId("idenfermedad");
        $existe = $model
            ->where("idenfermedad", "!=", $data["idenfermedad"])
            ->where("nombre", "LIKE", $data["nombre"])
            ->where("desactivado", "0")
            ->first();
        if ($existe) {
            return $this->respondWithError($response, "Ya existe una plaga o enfermedad con el nombre: {$data['nombre']}");
        }
        $imagen = "";
        if ($data["eliminar_img"] === "1") {
            $imagen = "/img/default.png";
        }
        if (isset($data["foto"]) && $data["foto"]["error"] === 0) {
            try {
                $imageHandler = new ImageHandler($data["foto"]);
                $responseUpload = $imageHandler
                    ->setName(urls_amigables($data["nombre"]))
                    ->setMinSize(1024) // Mínimo de 1KB
                    ->setMaxSize(10485760) // Máximo de 10MB
                    ->setMime(['image/jpeg', 'image/png', 'image/gif'])
                    ->setStorage('img/enfermedades', 0755) // Carpeta de almacenamiento
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
            "nombre" => $data["nombre"],
            "slug" => urls_amigables($data["nombre"]),
            "descripcion" => $data["description"],
        ];
        if (!empty($imagen)) {
            $dataInsert["imagen_url"] = $imagen;
        }
        $rq = $model->update($data["idenfermedad"], $dataInsert);
        if (!empty($rq)) {
            return $this->respondWithSuccess($response, "Datos actualizados correctamente");
        }
        return $this->respondWithJson($response, "Error al actualizar los datos");
    }

    private function validarUpdate($data)
    {
        if (empty($data["idenfermedad"])) {
            return false;
        }
        if (empty($data["nombre"])) {
            return false;
        }
        return true;
    }

    public function viewImgEntre($request, $response)
    {
        try {
            // Obtener y validar datos de entrada
            $data = $this->sanitize($request->getParsedBody());
            if (!isset($data['idenfermedad'])) {
                throw new \Exception("ID de enfermedad no proporcionado");
            }

            // Obtener información de la enfermedad
            $model = new TableModel;
            $model->setTable("re_enfermedades");
            $model->setId("idenfermedad");
            $rq = $model->find($data['idenfermedad']);

            if (!$rq) {
                throw new \Exception("Enfermedad no encontrada");
            }

            $nombre_carpeta = urls_amigables($rq["nombre"]);

            // Obtener configuración
            $model2 = new TableModel;
            $model2->setTable("re_configuracion");
            $model2->setId("idconfig");

            $textData = $model2->first();
            if (!$textData) {
                throw new \Exception("No se encontró la configuración");
            }

            $arrData = json_decode($textData['valor'], true);
            if (json_last_error() !== JSON_ERROR_NONE) {
                throw new \Exception("Error al decodificar la configuración");
            }

            // Validar que existe la carpeta base
            $baseFolder = $arrData['carpeta_img_entrenamiento'];
            if (!is_dir($baseFolder)) {
                throw new \Exception("La carpeta base de imágenes no existe");
            }

            // Validar que existe la carpeta de la enfermedad
            $folderPath = $baseFolder . '/' . $nombre_carpeta;
            if (!is_dir($folderPath)) {
                throw new \Exception("La carpeta de la enfermedad no existe");
            }

            // Escanear directorio
            $ruta = @scandir($folderPath);
            if ($ruta === false) {
                throw new \Exception("Error al leer el directorio");
            }

            $list = [];
            foreach ($ruta as $archivo) {
                // Ignora los archivos "." y ".."
                if ($archivo !== '.' && $archivo !== '..') {
                    $filePath = $folderPath . '/' . $archivo;

                    // Verificar si el archivo existe y es legible
                    if (!is_readable($filePath)) {
                        continue;
                    }

                    // Verificar si es una imagen
                    try {
                        if (@exif_imagetype($filePath)) {
                            $list[] = $filePath;
                        }
                    } catch (\Exception $e) {
                        // Si hay error al leer el archivo, lo ignoramos y continuamos
                        continue;
                    }
                }
            }

            if (empty($list)) {
                return $this->respondWithJson($response, [
                    'status' => 'warning',
                    'message' => 'No se encontraron imágenes en la carpeta',
                    'data' => []
                ]);
            }

            return $this->respondWithJson($response, [
                'status' => 'success',
                'data' => $list
            ]);
        } catch (\Exception $e) {
            return $this->respondWithJson($response, [
                'status' => 'error',
                'message' => $e->getMessage()
            ]);
        }
    }

    public function uploadImgEntre($request, $response)
    {
        $data = ($request->getParsedBody());
        $msg = "Error al guardar los datos";
        $model = new TableModel;
        $model->setTable("re_enfermedades");
        $model->setId("idenfermedad");
        $rq = $model->find($data['idenfermedad']);
        $nombre_carpeta = urls_amigables($rq["nombre"]);

        $model2 = new TableModel;
        $model2->setTable("re_configuracion");
        $model2->setId("idconfig");

        $textData = $model2->first();
        $arrData = json_decode($textData['valor'], true);

        try {
            $imageHandler = new ImageHandler($_FILES["file"]);
            $responseUpload = $imageHandler
                ->setName($nombre_carpeta . '-' . uniqid())
                ->setMinSize(1024) // Mínimo de 1KB
                ->setMaxSize(10485760) // Máximo de 10MB
                ->setMime(['image/jpeg', 'image/png'])
                ->setStorage($arrData['carpeta_img_entrenamiento'] . '/' . $nombre_carpeta, 0755) // Carpeta de almacenamiento
                ->upload();

            if (!$responseUpload) {
                return $this->respondWithError($response, $imageHandler->getErrorMessage());
            }
            if ($responseUpload) {
                return $this->respondWithSuccess($response, "Imagen guardada correctamente");
            }
        } catch (\Throwable $th) {
            return $this->respondWithError($response, $th->getMessage());
        }
        return $this->respondWithError($response, $msg);
    }
}
