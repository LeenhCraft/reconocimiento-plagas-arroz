<?php
include_once __DIR__ . "/GenerarNumeros.php";
include_once __DIR__ . "/HelpersCore.php";

function base_url()
{
    return trim($_ENV['APP_URL'], '/') . '/';
}

function  header_web($view, $data = [])
{
    $view = str_replace('.', '/', $view);
    $view_header = "../app/Resources/$view.php";
    require_once $view_header;
}

function footer_web($view, $data = [])
{
    $view = str_replace('.', '/', $view);
    $view_footer =  "../app/Resources/$view.php";
    require_once $view_footer;
}

function getModal($ruta, $data = "")
{
    $view_modal = "../app/Resources/Modals/{$ruta}.php";
    require_once $view_modal;
}

function strClean($strCadena)
{
    $string = preg_replace(['/\s+/', '/^\s|\s$/'], [' ', ''], $strCadena);
    $string = trim($string); //Elimina espacios en blanco al inicio y al final
    $string = stripslashes($string); // Elimina las \ invertidas
    $string = str_ireplace("<script>", "", $string);
    $string = str_ireplace("</script>", "", $string);
    $string = str_ireplace("<script src>", "", $string);
    $string = str_ireplace("<script type=>", "", $string);
    $string = str_ireplace("SELECT * FROM", "", $string);
    $string = str_ireplace("DELETE FROM", "", $string);
    $string = str_ireplace("INSERT INTO", "", $string);
    $string = str_ireplace("SELECT COUNT(*) FROM", "", $string);
    $string = str_ireplace("DROP TABLE", "", $string);
    $string = str_ireplace("OR '1'='1", "", $string);
    $string = str_ireplace('OR "1"="1"', "", $string);
    $string = str_ireplace('OR ´1´=´1´', "", $string);
    $string = str_ireplace("is NULL; --", "", $string);
    $string = str_ireplace("is NULL; --", "", $string);
    $string = str_ireplace("LIKE '", "", $string);
    $string = str_ireplace('LIKE "', "", $string);
    $string = str_ireplace("LIKE ´", "", $string);
    $string = str_ireplace("OR 'a'='a", "", $string);
    $string = str_ireplace('OR "a"="a', "", $string);
    $string = str_ireplace("OR ´a´=´a", "", $string);
    $string = str_ireplace("OR ´a´=´a", "", $string);
    $string = str_ireplace("--", "", $string);
    $string = str_ireplace("^", "", $string);
    $string = str_ireplace("[", "", $string);
    $string = str_ireplace("]", "", $string);
    $string = str_ireplace("==", "", $string);
    $string = str_ireplace("//", "", $string);
    $string = str_ireplace("\\", "", $string);
    $string = str_ireplace("'", "", $string);
    return $string;
}

function dep($data, $exit = 0)
{
    // agregar codificación utf-8
    header('Content-Type: text/html; charset=utf-8');
    $format  = print_r('<pre>');
    $format .= print_r($data);
    $format .= print_r('</pre>');
    ($exit != 0) ? $format .= exit : '';
    return $format;
}

function urls_amigables($url)
{
    // Tranformamos todo a minusculas
    $url = strtolower($url);
    //Rememplazamos caracteres especiales latinos
    $find = array('á', 'é', 'í', 'ó', 'ú', 'ñ');
    $repl = array('a', 'e', 'i', 'o', 'u', 'n');
    $url = str_replace($find, $repl, $url);
    // Añadimos los guiones
    $find = array(' ', '&', '\r\n', '\n', '+');
    $url = str_replace($find, '-', $url);
    // Eliminamos y Reemplazamos demás caracteres especiales
    $find = array('/[^a-z0-9\-<>]/', '/[\-]+/', '/<[^>]*>/');
    $repl = array('', '-', '');
    $url = preg_replace($find, $repl, $url);
    return $url;
}

/**
 * Calcula y formatea el tiempo de ejecución con precisión
 */
function getExecutionTime($start, $end = null)
{
    if ($end === null) {
        $end = time(); // Usamos `time()` en lugar de `microtime()`
    }

    // Diferencia en segundos
    $diff = $end - $start;

    // Cálculo de componentes de tiempo
    $hours = (int)floor($diff / 3600); // Horas
    $minutes = (int)floor(($diff % 3600) / 60); // Minutos
    $seconds = (int)($diff % 60); // Segundos

    // Formateo detallado
    $detailed = '';
    if ($hours > 0) $detailed .= $hours . 'h ';
    if ($minutes > 0) $detailed .= $minutes . 'm ';
    if ($seconds > 0) $detailed .= $seconds . 's ';
    $detailed = trim($detailed);

    // Retorno de los resultados
    return [
        'reloj' => sprintf('%02d:%02d:%02d', $hours, $minutes, $seconds),
        'detallado' => $detailed,
        'segundos' => $diff,  // Tiempo en segundos
        'unidad_optima' => match (true) {
            $diff >= 3600 => $hours . ' horas',
            $diff >= 60 => $minutes . ' minutos',
            default => $seconds . ' segundos'
        }
    ];
}

function addCeros(int $int, $cantidadCeros = 2)
{
    $intString = (string)$int; // Convertir el número a cadena
    $length = strlen($intString); // Obtener la longitud de la cadena

    if ($length < $cantidadCeros) {
        // Agregar ceros a la izquierda si la longitud es menor que la cantidad especificada
        $ceros = str_repeat('0', $cantidadCeros - $length);
        return $ceros . $intString;
    } else {
        // Devolver el número como cadena si la longitud es mayor o igual
        return $intString;
    }
}
