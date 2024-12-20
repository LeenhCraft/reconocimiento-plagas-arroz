<?php

namespace App\Controllers\ModuloIA;

use App\Core\Controller;
use setasign\Fpdi\PdfParser\Type\PdfTypeException;

class ReemplazoController extends Controller
{

    public function index($request, $response)
    {
        $ruta = "C:/Users/LEENH/Desktop/etiquetado/caracol-manzana";
        $carpeta_imagenes = "C:/laragon/www/plagas-arroz/public_html/datos_entrenamiento/20241201221605/train/labels";
        $archivos = scandir($ruta);
        // dep($archivos, 1);

        // para cada archivo abrirlo y mostrar su contenido de solo los txt
        foreach ($archivos as $archivo) {
            if (is_file($ruta . "/" . $archivo)) {
                $extension = pathinfo($archivo, PATHINFO_EXTENSION);
                if ($extension == "txt") {
                    $contenido = file_get_contents($ruta . "/" . $archivo);
                    $contenido = explode("\n", $contenido);

                    // buscar el archivo en la segunda carpeta
                    $archivo2 = $carpeta_imagenes . "/" . $archivo;
                    // si lo encuentra mostrar el contenido
                    if (is_file($archivo2)) {
                        $contenido2 = file_get_contents($archivo2);
                        $contenido2 = explode("\n", $contenido2);
                        dep([
                            "archivo" => $archivo,
                            "contenido" => $contenido2
                        ]);
                    } else {
                        echo "No se encontro el archivo: " . $archivo . "<br>";
                    }
                }
            }
        }
        exit;
    }
}
