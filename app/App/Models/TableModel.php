<?php

namespace App\Models;

use App\Models\Model;

class TableModel extends Model
{
    protected $table;

    protected $id;

    protected $query;
    
    protected $sql;

    public function getTable()
    {
        return $this->table;
    }

    public function setTable($table)
    {
        $this->table = $table;
    }

    public function getId()
    {
        return $this->id;
    }

    public function setId($id)
    {
        $this->id = $id;
    }

    public function getQuery()
    {
        return $this->query;
    }

    public function getSql()
    {
        return $this->sql;
    }

    public function cantidadCarrito($idvisita = 0)
    {
        $sql = "SELECT SUM(car_cantidad) as car_cantidad FROM web_carritos WHERE vis_cod = '$idvisita' AND car_anulado = 0 AND codPedido = 0";
        $request = $this->query($sql)->first();
        return $request['car_cantidad'];
    }
}
