<?php

namespace App\Classes;

use Exception;
use RuntimeException;
use DateTime;

class DetectYoloClass
{
    private string $pythonPath;
    private string $scriptPath;
    private string $baseOutputDir;
    private string $weightsPath;
    private string $dataYamlPath;
    private ?string $currentOutputDir = null;

    /**
     * Constructor
     *
     * @param string $pythonPath Ruta al ejecutable de Python
     * @param string $scriptPath Ruta al script detectYOLO.py
     * @param string $baseOutputDir Directorio base para las predicciones
     * @param string $weightsPath Ruta a los pesos del modelo
     * @param string $dataYamlPath Ruta al archivo data.yaml
     */
    public function __construct(
        string $pythonPath,
        string $scriptPath,
        string $baseOutputDir,
        string $weightsPath,
        string $dataYamlPath
    ) {
        $this->validatePaths([
            'Python' => $pythonPath,
            'Script' => $scriptPath,
            'Weights' => $weightsPath,
            'Data YAML' => $dataYamlPath
        ]);

        $this->pythonPath = $pythonPath;
        $this->scriptPath = $scriptPath;
        $this->baseOutputDir = rtrim($baseOutputDir, '/');
        $this->weightsPath = $weightsPath;
        $this->dataYamlPath = $dataYamlPath;
    }

    /**
     * Valida las rutas necesarias
     *
     * @param array $paths Arreglo de rutas a validar
     * @throws RuntimeException Si alguna ruta no es válida
     */
    private function validatePaths(array $paths): void
    {
        foreach ($paths as $name => $path) {
            if (!file_exists($path)) {
                throw new RuntimeException("Error: {$name} path no encontrado: {$path}");
            }
        }
    }

    /**
     * Crea y obtiene el directorio de salida para la detección actual
     *
     * @return string Ruta al directorio de salida
     */
    private function getOutputDir(): string
    {
        if ($this->currentOutputDir === null) {
            $timestamp = (new DateTime())->format('YmdHis');
            $this->currentOutputDir = "{$this->baseOutputDir}/{$timestamp}";

            if (!mkdir($this->currentOutputDir, 0777, true) && !is_dir($this->currentOutputDir)) {
                throw new RuntimeException("Error creando directorio de salida: {$this->currentOutputDir}");
            }
        }
        return $this->currentOutputDir;
    }

    /**
     * Valida una imagen antes de procesarla
     *
     * @param string $imagePath Ruta a la imagen
     * @throws RuntimeException Si la imagen no es válida
     */
    private function validateImage(string $imagePath): void
    {
        if (!file_exists($imagePath)) {
            throw new RuntimeException("Imagen no encontrada: {$imagePath}");
        }

        $filesize = filesize($imagePath);
        if ($filesize > 10 * 1024 * 1024) { // 10MB
            throw new RuntimeException("La imagen excede el tamaño máximo permitido de 10MB");
        }

        $finfo = finfo_open(FILEINFO_MIME_TYPE);
        $mimeType = finfo_file($finfo, $imagePath);
        finfo_close($finfo);

        if (!str_starts_with($mimeType, 'image/')) {
            throw new RuntimeException("El archivo no es una imagen válida");
        }
    }

    /**
     * Ejecuta la detección YOLO en una imagen
     *
     * @param string $imagePath Ruta a la imagen
     * @param float $confidenceThreshold Umbral de confianza (opcional)
     * @return array Resultados de la detección
     * @throws Exception Si ocurre algún error durante la detección
     */
    public function detect(string $imagePath, float $confidenceThreshold = 0.25): array
    {
        try {
            // Validar imagen
            $this->validateImage($imagePath);

            // Preparar directorio de salida
            $outputDir = $this->getOutputDir();

            // Construir comando
            $command = sprintf(
                // '%s %s --image %s --output %s --weights %s --data %s --conf %.2f 2>&1',
                '%s %s --image %s --output %s --weights %s --data %s --conf %.2f',
                escapeshellarg($this->pythonPath),
                escapeshellarg($this->scriptPath),
                escapeshellarg($imagePath),
                escapeshellarg($outputDir),
                escapeshellarg($this->weightsPath),
                escapeshellarg($this->dataYamlPath),
                $confidenceThreshold
            );

            // Ejecutar comando
            $output = [];
            $returnCode = -1;
            exec($command, $output, $returnCode);

            // Procesar salida
            $outputStr = implode("\n", $output);
            $result = json_decode($outputStr, true);

            if ($returnCode !== 0 || json_last_error() !== JSON_ERROR_NONE) {
                throw new RuntimeException("Error ejecutando detección: {$outputStr}");
            }

            if (isset($result['error'])) {
                throw new RuntimeException($result['error']);
            }

            // Agregar información adicional
            $result['output_dir'] = $outputDir;
            $result['command_executed'] = $command;

            return $result;
        } catch (Exception $e) {
            // Registrar error en el log si existe el directorio
            if ($this->currentOutputDir !== null && is_dir($this->currentOutputDir)) {
                file_put_contents(
                    "{$this->currentOutputDir}/error.log",
                    date('Y-m-d H:i:s') . " - Error: " . $e->getMessage() . "\n" .
                        "Stack trace:\n" . $e->getTraceAsString() . "\n"
                );
            }

            // Retornar error en formato JSON
            return [
                'success' => false,
                'error' => $e->getMessage(),
                'timestamp' => date('Y-m-d H:i:s'),
                'output_dir' => $this->currentOutputDir ?? null
            ];
        }
    }

    /**
     * Obtiene el directorio actual de salida
     *
     * @return string|null Directorio actual de salida
     */
    public function getCurrentOutputDir(): ?string
    {
        return $this->currentOutputDir;
    }
}
