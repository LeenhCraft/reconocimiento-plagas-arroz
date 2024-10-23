<?php

namespace App\FileHandlers;

use App\FileHandlers\FileHandler;

class ImageHandler extends FileHandler
{
    private $minWidth;
    private $maxWidth;
    private $minHeight;
    private $maxHeight;
    private $convertToWebp = false;
    private $convertToPng = false;
    private $imageQuality = 80;

    public function setDimension($minWidth, $maxWidth, $minHeight, $maxHeight)
    {
        $this->minWidth = $minWidth;
        $this->maxWidth = $maxWidth;
        $this->minHeight = $minHeight;
        $this->maxHeight = $maxHeight;
        return $this;
    }

    public function convertToWebp($quality = 80)
    {
        $this->convertToWebp = true;
        $this->imageQuality = $quality;
        return $this;
    }

    public function convertToPng()
    {
        $this->convertToPng = true;
        return $this;
    }

    public function upload()
    {
        try {
            if (!$this->validateFile() || !$this->validateImageDimensions()) {
                return false;
            }

            $destination = $this->getStorage();
            if (!is_dir($destination)) {
                mkdir($destination, $this->storagePermission, true);
            }

            $newFileName = $this->generateFileName();
            $uploaded = false;

            // Procesar conversión a WebP o PNG si es necesario
            if ($this->convertToWebp) {
                $uploaded = $this->convertImageToFormat('webp', $this->imageQuality);
            } elseif ($this->convertToPng) {
                $uploaded = $this->convertImageToFormat('png');
            }

            if (!$uploaded) {
                $uploaded = move_uploaded_file($this->file['tmp_name'], $destination . '/' . $newFileName);
            }

            return $uploaded ? $newFileName : false;
        } catch (FileValidationException $e) {
            $this->errorMessage = $e->getMessage();
            return false;
        }
    }

    private function validateImageDimensions()
    {
        $imageInfo = $this->getImageInfo();
        if (!$imageInfo) {
            throw new FileValidationException("Error obteniendo las dimensiones de la imagen.");
        }

        list($width, $height) = $imageInfo;
        return ($this->minWidth === null || $width >= $this->minWidth) &&
            ($this->maxWidth === null || $width <= $this->maxWidth) &&
            ($this->minHeight === null || $height >= $this->minHeight) &&
            ($this->maxHeight === null || $height <= $this->maxHeight);
    }

    private function convertImageToFormat($format, $quality = 80)
    {
        $sourceImage = $this->file['tmp_name'];
        $imageInfo = $this->getImageInfo();
        $width = $imageInfo[0];
        $height = $imageInfo[1];

        $newImage = imagecreatetruecolor($width, $height);
        if (!$newImage) {
            return false;
        }

        $sourceExtension = strtolower(pathinfo($this->file['name'], PATHINFO_EXTENSION));
        switch ($sourceExtension) {
            case 'jpg':
            case 'jpeg':
                $sourceImage = imagecreatefromjpeg($sourceImage);
                break;
            case 'png':
                $sourceImage = imagecreatefrompng($sourceImage);
                imagealphablending($newImage, false);
                imagesavealpha($newImage, true);
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

        $path = $this->getStorage() . '/' . $this->generateFileName($format);
        switch ($format) {
            case 'webp':
                $success = imagewebp($newImage, $path, $quality);
                break;
            case 'png':
                $success = imagepng($newImage, $path);
                break;
            default:
                $success = false;
        }

        imagedestroy($newImage);
        return $success;
    }

    private function getImageInfo()
    {
        if (!function_exists('getimagesize')) {
            return false;
        }

        return getimagesize($this->file['tmp_name']);
    }
}
