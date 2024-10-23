<?php

/**
 * Genera números aleatorios con diversas opciones de configuración
 * 
 * @param array $options Arreglo de opciones de configuración
 *      - min: (int) Número mínimo (default: 0)
 *      - max: (int) Número máximo (default: PHP_INT_MAX)
 *      - quantity: (int) Cantidad de números a generar (default: 1)
 *      - unique: (bool) Si los números deben ser únicos (default: false)
 *      - decimals: (int) Cantidad de decimales (default: 0)
 *      - formatted: (bool) Si debe dar formato con separadores de miles (default: false)
 *      - length: (int) Longitud específica del número (default: null)
 *      - padChar: (string) Carácter para rellenar si length está definido (default: '0')
 * @return mixed Número único o array de números según quantity
 * @throws InvalidArgumentException Si los parámetros son inválidos
 */
function generar_numeros(array $options = []): mixed
{
    // Valores por defecto
    $defaults = [
        'min' => 0,
        'max' => PHP_INT_MAX,
        'quantity' => 1,
        'unique' => false,
        'decimals' => 0,
        'formatted' => false,
        'length' => null,
        'padChar' => '0'
    ];

    // Combinar opciones con defaults
    $config = array_merge($defaults, $options);

    // Validaciones básicas
    if (!is_int($config['min']) || !is_int($config['max'])) {
        throw new InvalidArgumentException('Los límites min y max deben ser enteros');
    }

    if ($config['min'] >= $config['max']) {
        throw new InvalidArgumentException('El mínimo debe ser menor que el máximo');
    }

    if ($config['quantity'] < 1) {
        throw new InvalidArgumentException('La cantidad debe ser mayor a 0');
    }

    if ($config['decimals'] < 0) {
        throw new InvalidArgumentException('Los decimales no pueden ser negativos');
    }

    // Validación de longitud
    if ($config['length'] !== null) {
        if (!is_int($config['length']) || $config['length'] <= 0) {
            throw new InvalidArgumentException('La longitud debe ser un número entero positivo');
        }
        if (strlen($config['padChar']) !== 1) {
            throw new InvalidArgumentException('El carácter de relleno debe ser un único carácter');
        }

        // Ajustar min y max según la longitud especificada
        $minLength = pow(10, $config['length'] - 1);
        $maxLength = pow(10, $config['length']) - 1;

        // Ajustar los límites para respetar tanto la longitud como los límites especificados
        $config['min'] = max($config['min'], $minLength);
        $config['max'] = min($config['max'], $maxLength);

        if ($config['min'] > $config['max']) {
            throw new InvalidArgumentException(
                "No es posible generar números de {$config['length']} dígitos con los límites especificados"
            );
        }
    }

    // Si piden números únicos, validar que haya suficientes posibles
    if ($config['unique'] && $config['quantity'] > ($config['max'] - $config['min'] + 1)) {
        throw new InvalidArgumentException('No hay suficientes números únicos en el rango especificado');
    }

    $numbers = [];

    // Generar números
    while (count($numbers) < $config['quantity']) {
        if ($config['decimals'] > 0) {
            $number = round(
                $config['min'] + mt_rand() / mt_getrandmax() * ($config['max'] - $config['min']),
                $config['decimals']
            );
        } else {
            $number = mt_rand($config['min'], $config['max']);
        }

        // Si tiene longitud específica, aplicar padding
        if ($config['length'] !== null && !$config['formatted'] && $config['decimals'] === 0) {
            $number = str_pad($number, $config['length'], $config['padChar'], STR_PAD_LEFT);
        }

        // Si requiere únicos, verificar que no exista
        if ($config['unique']) {
            if (!in_array($number, $numbers)) {
                $numbers[] = $number;
            }
        } else {
            $numbers[] = $number;
        }
    }

    // Aplicar formato si se requiere
    if ($config['formatted']) {
        $numbers = array_map(function ($num) {
            return number_format($num, $num == floor($num) ? 0 : 2, '.', ',');
        }, $numbers);
    }

    // Retornar según cantidad
    return $config['quantity'] === 1 ? $numbers[0] : $numbers;
}