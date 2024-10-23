<?php

namespace App\FileHandlers;

use finfo;

class FileValidationException extends \Exception {}

class FileHandler
{
    protected $file;
    protected $name;
    protected $minSize;
    protected $maxSize;
    protected $allowedTypes = [];
    protected $storageFolder;
    protected $storagePermission;
    protected $errorMessage;

    public function __construct($file)
    {
        $this->file = $file;
    }

    public function setName($name)
    {
        $this->name = $name;
        return $this;
    }

    // Función para establecer el tamaño mínimo
    public function setMinSize($min)
    {
        $this->minSize = $min;
        return $this;
    }

    // Función para establecer el tamaño máximo
    public function setMaxSize($max)
    {
        $this->maxSize = $max;
        return $this;
    }

    public function setMime(array $mimeTypes)
    {
        $this->allowedTypes = $mimeTypes;
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

    public function getStorage()
    {
        return $this->storageFolder;
    }

    public function getPath()
    {
        return $this->storageFolder . '/' . $this->generateFileName();
    }

    public function getJson()
    {
        $fileInfo = [
            'name' => $this->getName(),
            'size' => $this->getSize(),
            'mime' => $this->getMime(),
            'storage' => $this->getStorage(),
            'path' => $this->getPath(),
        ];

        return json_encode($fileInfo);
    }

    public function upload()
    {
        dep("filehandler");
        try {
            if (!$this->validateFile()) {
                return false;
            }
            $destination = $this->getStorage();

            if (!is_dir($destination)) {
                mkdir($destination, $this->storagePermission, true);
            }

            $newFileName = $this->generateFileName();
            $uploaded = move_uploaded_file($this->file['tmp_name'], $destination . '/' . $newFileName);

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
            throw new FileValidationException("Error en la estructura del archivo.");
        }
        if ($this->file['error'] !== UPLOAD_ERR_OK) {
            throw new FileValidationException("Error al cargar el archivo en el servidor.");
        }

        if (!is_uploaded_file($this->file['tmp_name'])) {
            throw new FileValidationException("Intento de ataque sospechoso (archivo no cargado mediante HTTP POST).");
        }

        if (!$this->checkFileSize()) {
            throw new FileValidationException("Tamaño de archivo excedido o es demasiado pequeño.");
        }

        if (!$this->checkFileType()) {
            throw new FileValidationException("Tipo de archivo no permitido.");
        }

        return true;
    }

    protected function checkFileSize()
    {
        $sizeInBytes = $this->file['size'];
        return ($this->minSize === null || $sizeInBytes >= $this->minSize) && ($this->maxSize === null || $sizeInBytes <= $this->maxSize);
    }

    protected function checkFileType()
    {
        if (empty($this->allowedTypes)) {
            return true;
        }

        $fileInfo = new finfo(FILEINFO_MIME_TYPE);
        $mimeType = $fileInfo->file($this->file['tmp_name']);

        return in_array($mimeType, $this->allowedTypes);
    }

    protected function generateFileName($extension = null)
    {
        if ($extension === null) {
            $extension = strtolower(pathinfo($this->file['name'], PATHINFO_EXTENSION));
        }

        if ($this->name !== null) {
            return $this->name . '.' . $extension;
        }

        return uniqid() . '.' . $extension;
    }

    public function getErrorMessage()
    {
        return $this->errorMessage;
    }
}
