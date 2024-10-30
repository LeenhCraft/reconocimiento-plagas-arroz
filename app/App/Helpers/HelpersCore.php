<?php

use App\Models\TableModel;

function centinela()
{
    $model = new TableModel();
    $model->setTable('sis_centinela');
    $model->setId('idcentinela');
    $method = $_SERVER['REQUEST_METHOD'] ?? 'none';
    $url = $_SERVER['REQUEST_URI'] ?? 'no existe';
    $agente = $_SERVER['HTTP_USER_AGENT'] ?? 'No existe';
    $ipHeaders = array(
        'REMOTE_ADDR' => 'IP',
        'HTTP_CLIENT_IP' => 'IP',
        'HTTP_X_FORWARDED_FOR' => 'IP',
        'HTTP_X_FORWARDED' => 'IP',
        'HTTP_CF_CONNECTING_IP' => 'ip'
    );
    $ip = '';
    foreach ($ipHeaders as $header => $label) {
        if (isset($_SERVER[$header]) && $_SERVER[$header] !== '') {
            $ip .= " $label: " . $_SERVER[$header];
        }
    }
    $model->create(
        [
            "codigo" => generar_numeros(['length' => 4, "unique" => true]),
            "ip" => $ip,
            "agente" => $agente,
            "method" => $method,
            "url" => $url,
        ],
    );
}

function menus()
{
    $model = new TableModel();
    $model->setTable('sis_menus');
    $model->setId('idmenu');
    $arrData = $model
        ->query(
            "SELECT * FROM sis_menus 
        WHERE idmenu IN( SELECT DISTINCT (c.idmenu) 
        FROM sis_permisos a INNER JOIN sis_submenus b ON a.idsubmenu = b.idsubmenu 
        LEFT JOIN sis_menus c ON c.idmenu = b.idmenu 
        WHERE a.idrol = ?  AND a.perm_r = ? AND c.men_visible = ? ) ORDER BY men_orden ASC",
            [$_SESSION['app_r'] ?? 0, 1, 1]
        )->get();
    $data = [];
    for ($i = 0; $i < count($arrData); $i++) {
        $data[$i] = [
            'idmenu' => $arrData[$i]['idmenu'],
            'men_nombre' => (!empty($arrData[$i]['men_nombre'])) ? ucfirst($arrData[$i]['men_nombre']) : ucfirst('sin nombre'),
            'men_icono' => (!empty($arrData[$i]['men_icono'])) ? $arrData[$i]['men_icono'] : 'fa-solid fa-circle-notch',
            'men_url_si' => (!empty($arrData[$i]['men_url_si'])) ? $arrData[$i]['men_url_si'] : 0,
            'men_url' => (!empty($arrData[$i]['men_url'])) ? $arrData[$i]['men_url'] : '#'
        ];
    }
    return $data;
}

function submenus($idmenu)
{
    $model = new TableModel();
    $idrol = $_SESSION['app_r'] ?? '0';
    $arrData = $model
        ->query(
            "SELECT b.idsubmenu,b.idmenu,b.sub_nombre,b.sub_icono,b.sub_url,b.sub_externo FROM sis_permisos a 
            INNER JOIN sis_submenus b ON a.idsubmenu=b.idsubmenu 
            WHERE b.idmenu = ? AND b.sub_visible = ? AND a.perm_r = ? AND a.idrol = ? ORDER BY b.sub_orden ASC
            ",
            [
                $idmenu,
                1,
                1,
                $idrol
            ]
        )
        ->get();

    $return = [];
    for ($i = 0; $i < count($arrData); $i++) {
        $return[$i] = [
            'idmenu' => $arrData[$i]['idmenu'],
            'idsubmenu' => $arrData[$i]['idsubmenu'],
            'sub_nombre' => (!empty($arrData[$i]['sub_nombre']) ? ucfirst($arrData[$i]['sub_nombre']) : ucfirst('sin nombre')),
            'sub_icono' => (!empty($arrData[$i]['sub_icono']) ? $arrData[$i]['sub_icono'] : 'fa-solid fa-circle-notch'),
            'sub_url' => (!empty($arrData[$i]['sub_url']) ? $arrData[$i]['sub_url'] : '#'),
            'sub_externo' => (!empty($arrData[$i]['sub_externo']) ? $arrData[$i]['sub_externo'] : '#')
        ];
    }
    return $return;
}

function pertenece($submenu, $menu)
{
    $model = new TableModel();
    $request = $model
        ->query(
            "SELECT * FROM sis_submenus WHERE idmenu = ? AND sub_url like BINARY ?",
            [
                $menu,
                $submenu
            ]
        )
        ->first();
    return (!empty($request)) ? true : false;
}

function usuario()
{
    $model = new TableModel();
    $model->setTable('sis_usuarios');
    $model->setId('idusuario');
    return $model
        ->select(
            "sis_personal.per_nombre as nombre",
            "sis_rol.rol_nombre as rol",
            "sis_personal.per_foto as foto",
        )
        ->join("sis_personal", "sis_personal.idpersona", "sis_usuarios.idpersona")
        ->join("sis_rol", "sis_rol.idrol", "sis_usuarios.idrol")
        ->where("sis_usuarios.idusuario", $_SESSION["app_id"] ?? '0')
        ->first();
}

function getPermisos($controlador)
{
    $model = new TableModel();
    $idrol = $_SESSION['app_r'] ?? '0';
    $sql = "SELECT * FROM sis_permisos a 
        INNER JOIN sis_submenus b ON a.idsubmenu=b.idsubmenu 
        WHERE b.sub_controlador LIKE BINARY '$controlador' AND a.idrol='$idrol'";
    $request = $model->query($sql)->first();
    return [
        'perm_r' => (!empty($request['perm_r']) ? $request['perm_r'] : '0'),
        'perm_w' => (!empty($request['perm_w']) ? $request['perm_w'] : '0'),
        'perm_u' => (!empty($request['perm_u']) ? $request['perm_u'] : '0'),
        'perm_d' => (!empty($request['perm_d']) ? $request['perm_d'] : '0')
    ];
}
