<?php

namespace App\FileHandlers;

use finfo;

class FileValidationException extends \Exception {}

class ImageGPT
{
    private $file;
    private $name;
    private $minSize;
    private $maxSize;
    private $allowedTypes = [];
    private $minWidth;
    private $maxWidth;
    private $minHeight;
    private $maxHeight;
    private $storageFolder;
    private $storagePermission;
    private $convertToWebp = false;
    private $webpQuality = 80;
    private $errorMessage;

    public function __construct($file)
    {
        $this->file = $file;
    }

    public function setName($name)
    {
        $this->name = $name;
        return $this;
    }

    public function setSize($min, $max)
    {
        $this->minSize = $min;
        $this->maxSize = $max;
        return $this;
    }

    public function setMime(array $mimeTypes)
    {
        $this->allowedTypes = $mimeTypes;
        return $this;
    }

    public function setDimension($width, $height)
    {
        // $this->minWidth = $width;
        $this->maxWidth = $width;
        // $this->minHeight = $height;
        $this->maxHeight = $height;
        return $this;
    }

    public function setStorage($folderName, $permission = null)
    {
        $this->storageFolder = $folderName;
        $this->storagePermission = $permission;
        return $this;
    }

    public function getName()
    {
        return $this->name;
    }

    public function getSize()
    {
        return $this->file['size'];
    }

    public function getMime()
    {
        return $this->file['type'];
    }

    public function getWidth()
    {
        $imageInfo = $this->getImageInfo();
        return $imageInfo ? $imageInfo[0] : null;
    }

    public function getHeight()
    {
        $imageInfo = $this->getImageInfo();
        return $imageInfo ? $imageInfo[1] : null;
    }

    public function getStorage()
    {
        return $this->storageFolder;
    }

    public function getPath()
    {
        if ($this->convertToWebp) {
            return $this->storageFolder . '/' . $this->generateFileName("webp");
        }
        return $this->storageFolder . '/' . $this->generateFileName();
    }

    public function getJson()
    {
        $fileInfo = [
            'name' => $this->getName(),
            'size' => $this->getSize(),
            'mime' => $this->getMime(),
            'storage' => $this->getStorage(),
            'path' => $this->getPath()
        ];

        // Verificar si el archivo es una imagen antes de agregar las dimensiones (width, height) al array
        if ($this->isImage()) {
            $fileInfo['width'] = $this->getWidth();
            $fileInfo['height'] = $this->getHeight();
        }

        return json_encode($fileInfo);
    }


    public function upload()
    {
        try {
            if (!$this->validateFile()) {
                return false;
            }
            $destination = $this->getStorage();

            if (!is_dir($destination)) {
                mkdir($destination, $this->storagePermission, true);
            }

            $newFileName = $this->generateFileName();
            $uploaded = false;

            // Procesar la conversión a WebP si se desea
            if ($this->convertToWebp) {
                $imageExtension = strtolower(pathinfo($this->file['name'], PATHINFO_EXTENSION));
                $uploaded = $this->convertToWebp($imageExtension, $this->webpQuality);
            }

            if (!$uploaded) {
                $uploaded = move_uploaded_file($this->file['tmp_name'], $destination . '/' . $newFileName);
            }

            if ($uploaded) {
                return $newFileName;
            } else {
                return false;
            }
        } catch (FileValidationException $e) {
            $this->errorMessage = $e->getMessage();
            return false;
        }
    }

    public function validateFile()
    {
        if (!isset($this->file['error']) || is_array($this->file['error'])) {
            // return false; // Error en la estructura del archivo
            throw new FileValidationException("Error en la estructura del archivo.");
        }
        if ($this->file['error'] !== UPLOAD_ERR_OK) {
            // return false; // Error al cargar el archivo en el servidor
            throw new FileValidationException("Error al cargar el archivo en el servidor.");
        }

        if (!is_uploaded_file($this->file['tmp_name'])) {
            throw new FileValidationException("Intento de ataque sospechoso (archivo no cargado mediante HTTP POST).");
            // return false; // Intento de ataque sospechoso (archivo no cargado mediante HTTP POST)
        }

        if (!$this->checkFileSize()) {
            throw new FileValidationException("Tamaño de archivo excedido.");
            // return false; // Tamaño de archivo excedido
        }

        // Aquí se puede agregar alguna validación específica para archivos según tus necesidades.
        // Por ejemplo, puedes agregar una lista de extensiones permitidas y verificar si la extensión del archivo está en esa lista.

        if (!$this->checkFileType()) {
            throw new FileValidationException("Tipo de archivo no permitido.");
            // return false; // Tipo de archivo no permitido
        }

        // Si es un archivo de imagen, podemos verificar su tamaño.
        if ($this->isImage() && !$this->checkImageSize()) {
            throw new FileValidationException("Tamaño de imagen excedido.");
            // return false; // Tamaño de imagen excedido
        }

        // Otras validaciones específicas que desees realizar para ciertos tipos de archivos.

        return true; // El archivo ha pasado todas las validaciones, es válido.
    }

    private function isImage()
    {
        // Obtener la extensión del archivo
        $fileExtension = strtolower(pathinfo($this->file['name'], PATHINFO_EXTENSION));

        // Lista de extensiones de imágenes permitidas
        $allowedExtensions = array('jpg', 'jpeg', 'png', 'gif', 'bmp');

        // Verificar si la extensión está en la lista de extensiones permitidas
        return in_array($fileExtension, $allowedExtensions);
    }


    private function checkFileSize()
    {
        $sizeInBytes = $this->file['size'];
        return ($this->minSize === null || $sizeInBytes >= $this->minSize) && ($this->maxSize === null || $sizeInBytes <= $this->maxSize);
    }

    private function checkFileType()
    {
        if (empty($this->allowedTypes)) {
            return true;
        }

        $fileInfo = new finfo(FILEINFO_MIME_TYPE);
        $mimeType = $fileInfo->file($this->file['tmp_name']);

        foreach ($this->allowedTypes as $type) {
            if ($mimeType === $type) {
                return true;
            }
        }

        return false;
    }

    private function checkImageSize()
    {
        $imageInfo = $this->getImageInfo();

        if (!$imageInfo) {
            return false;
        }

        $width = $imageInfo[0];
        $height = $imageInfo[1];

        return ($this->minWidth === null || $width >= $this->minWidth) &&
            ($this->maxWidth === null || $width <= $this->maxWidth) &&
            ($this->minHeight === null || $height >= $this->minHeight) &&
            ($this->maxHeight === null || $height <= $this->maxHeight);
    }

    private function getImageInfo()
    {
        if (!function_exists('getimagesize')) {
            return false;
        }

        return getimagesize($this->file['tmp_name']);
    }

    private function generateFileName($extension = null)
    {
        // $extension = pathinfo($this->file['name'], PATHINFO_EXTENSION);

        // if ($this->name !== null) {
        //     $newFileName = $this->name . '.' . $extension;
        // } else {
        //     $newFileName = uniqid() . '.' . $extension;
        // }

        // return $newFileName;

        if ($extension === null) {
            $extension = strtolower(pathinfo($this->file['name'], PATHINFO_EXTENSION));
        }

        if ($this->name !== null) {
            $newFileName = $this->name . '.' . $extension;
        } else {
            $newFileName = uniqid() . '.' . $extension;
        }

        return $newFileName;
    }

    public function convertWebp($quality = 80)
    {
        $this->convertToWebp = true; // Habilitar la conversión a WebP
        $this->webpQuality = $quality; // Establecer la calidad para WebP
        return $this;
    }

    private function convertToWebp($sourceExtension, $quality = 80)
    {
        if (!in_array($sourceExtension, ['jpg', 'jpeg', 'png', 'gif', 'bmp'])) {
            return false;
        }

        $sourceImage = $this->file['tmp_name'];
        $imageInfo = $this->getImageInfo();
        $width = $imageInfo[0];
        $height = $imageInfo[1];
        $newImage = imagecreatetruecolor($width, $height);

        if (!$newImage) {
            return false;
        }
        // Para manejar imágenes PNG con fondo transparente
        if ($sourceExtension === 'png') {
            imagealphablending($newImage, false);
            imagesavealpha($newImage, true);
        }
        switch ($sourceExtension) {
            case 'jpg':
            case 'jpeg':
                $sourceImage = imagecreatefromjpeg($sourceImage);
                break;
            case 'png':
                $sourceImage = imagecreatefrompng($sourceImage);
                break;
            case 'gif':
                $sourceImage = imagecreatefromgif($sourceImage);
                break;
            case 'bmp':
                $sourceImage = imagecreatefrombmp($sourceImage);
                break;
        }

        if (!$sourceImage) {
            return false;
        }

        imagecopy($newImage, $sourceImage, 0, 0, 0, 0, $width, $height);
        imagedestroy($sourceImage);

        $webpPath = $this->storageFolder . '/' . $this->generateFileName('webp');
        $success = imagewebp($newImage, $webpPath, $quality);

        if (!$success) {
            return false;
        }

        imagedestroy($newImage);

        return true;
    }

    public function getErrorMessage()
    {
        return $this->errorMessage;
    }
}
