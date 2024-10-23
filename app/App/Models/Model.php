<?php

namespace App\Models;

use mysqli;
use Nette\Utils\Callback;

class Model
{
    protected $db_host;
    protected $db_user;
    protected $db_pass;
    protected $db_name;
    protected $db_charset = "utf8mb4";
    protected $connection;
    protected $query;
    protected $table;
    protected $id = "id";

    protected $sql, $data = [], $params = null;
    protected $unionAll = "";
    protected $select = "*";
    protected $where, $values = [];

    protected $join = "", $orderBy = "", $limit = "";

    public function __construct()
    {
        $this->db_host = $_ENV['DB_HOST'];
        $this->db_user = $_ENV['DB_USERNAME'];
        $this->db_pass = $_ENV['DB_PASSWORD'];
        $this->db_name = $_ENV['DB_DATABASE'];
        $this->db_charset = $_ENV['DB_CHARSET'];
        $this->connection();
    }

    public function connection()
    {
        $this->connection = new mysqli($this->db_host, $this->db_user, $this->db_pass, $this->db_name);
        if ($this->connection->connect_error) {
            die("Connection failed: " . $this->connection->connect_error);
        }
        $this->connection->set_charset($this->db_charset);
    }

    public function query($sql, $data = [], $params = null)
    {
        $this->sql = $sql;
        if ($data) { //si data es diferente de null
            if ($params == null) {
                $params = str_repeat("s", count($data));
            }
            $stmt = $this->connection->prepare($sql);
            $stmt->bind_param($params, ...$data);
            $stmt->execute();
            $this->query = $stmt->get_result();
        } else {
            $this->query = $this->connection->query($sql);
        }
        return $this;
    }

    public function select(...$columns)
    {
        if ($this->select != "*") {
            $this->select .= ", " . implode(', ', $columns);
        } else {
            $this->select = implode(', ', $columns);
        }
        return $this;
    }

    public function join($table, $first, $operator = "=", $second = null)
    {
        if ($second === null) {
            $second = $operator;
            $operator = "=";
        }

        if ($this->join) {
            $this->join .= " INNER JOIN {$table} ON {$first} {$operator} {$second}";
        } else {
            $this->join = " INNER JOIN {$table} ON {$first} {$operator} {$second}";
        }

        return $this;
    }

    public function leftJoin($table, $first, $operator = "=", $second = null)
    {
        if ($second === null) {
            $second = $operator;
            $operator = "=";
        }

        if ($this->join) {
            $this->join .= " LEFT JOIN {$table} ON {$first} {$operator} {$second}";
        } else {
            $this->join = " LEFT JOIN {$table} ON {$first} {$operator} {$second}";
        }

        return $this;
    }

    public function rightJoin($table, $first, $operator = "=", $second = null)
    {
        if ($second === null) {
            $second = $operator;
            $operator = "=";
        }

        if ($this->join) {
            $this->join .= " RIGHT JOIN {$table} ON {$first} {$operator} {$second}";
        } else {
            $this->join = " RIGHT JOIN {$table} ON {$first} {$operator} {$second}";
        }

        return $this;
    }

    public function where($column, $operator = "=", $value = null)
    {
        if (is_callable($column)) {
            if ($this->where) {
                $tempWhere = $this->where . " AND ("; //guardamos el where actual
            } else {
                $tempWhere = " (";
            }
            $this->where = "";
            $column($this);
            $temp2Where = $this->where;

            $tempWhere .= $temp2Where . ")";

            $this->where = $tempWhere;
            return $this;
        }

        if ($value == null) {
            $value = $operator;
            $operator = "=";
        }

        if ($this->where) {
            $this->where .= " AND {$column} {$operator} ?";
        } else {
            $this->where = "{$column} {$operator} ?";
        }

        $this->values[] = $value;

        return $this;
    }

    public function orWhere($column, $operator = "=", $value = null)
    {
        if (is_callable($column)) {
            $tempWhere = $this->where; //guardamos el where actual
            if ($tempWhere == "") {
                $tempWhere = " (" . $tempWhere;
            } else {
                $tempWhere .= " OR (";
            }
            $this->where = "";
            $column($this);
            $temp2Where = $this->where;

            $tempWhere .= $temp2Where . ")";

            $this->where = $tempWhere;
            return $this;

            $currentWhere = $this->where;
            $this->where .= ($currentWhere ? " OR (" : "(");
            $column($this);
            $this->where .= ")";
            return $this;
        }

        if ($value == null) {
            $value = $operator;
            $operator = "=";
        }

        if ($this->where) {
            $this->where .= " OR {$column} {$operator} ?";
        } else {
            $this->where = "{$column} {$operator} ?";
        }

        $this->values[] = $value;
        return $this;
    }

    public function orderBy($column, $order = "ASC")
    {
        if ($this->orderBy) {
            $this->orderBy .= ", {$column} {$order}";
        } else {
            $this->orderBy = "{$column} {$order}";
        }

        return $this;
    }

    // funcion para vaciar querys
    public function emptyQuery()
    {
        $this->query = null;
        $this->sql = "";
        $this->data = [];
        $this->params = null;
        $this->unionAll = "";
        $this->select = "*";
        $this->where = "";
        $this->values = [];
        $this->join = "";
        $this->orderBy = "";
        $this->limit = "";
        return $this;
    }

    public function limit($limit)
    {
        $this->limit = " LIMIT {$limit}";
        return $this;
    }

    public function first()
    {
        if (empty($this->query)) {

            // if (empty($this->sql)) {
            //     $this->sql = "SELECT * FROM {$this->table}";
            // }

            // $this->sql .= $this->orderBy;

            // $this->query($this->sql, $this->data, $this->params);

            $sql = "SELECT {$this->select} FROM {$this->table}";

            if ($this->join) {
                $sql .= $this->join;
            }

            if ($this->where) {
                $sql .= " WHERE {$this->where}";
            }

            if ($this->orderBy) {
                $sql .= " ORDER BY {$this->orderBy}";
            }

            if ($this->limit) {
                $sql .= $this->limit;
            }

            $this->query($sql, $this->values, $this->params);
        }
        return $this->query->fetch_assoc();
    }

    public function get()
    {
        if (!empty($this->unionAll)) {
            $sql = $this->unionAll;

            $this->query($sql, $this->values, $this->params);

            return $this->query->fetch_all(MYSQLI_ASSOC);
        }
        if (empty($this->query)) {

            /* if (empty($this->sql)) {
                $this->sql = "SELECT * FROM {$this->table}";
            }

            $this->sql .= $this->join;

            $this->sql .= $this->orderBy;

            $this->sql .= $this->limit;

            $this->query($this->sql, $this->data, $this->params); */

            $sql = "SELECT {$this->select} FROM {$this->table}";

            if ($this->join) {
                $sql .= $this->join;
            }

            if ($this->where) {
                $sql .= " WHERE {$this->where}";
            }

            if ($this->orderBy) {
                $sql .= " ORDER BY {$this->orderBy}";
            }

            if ($this->limit) {
                $sql .= $this->limit;
            }

            $this->query($sql, $this->values, $this->params);
        }
        return $this->query->fetch_all(MYSQLI_ASSOC);
    }

    public function paginate($cant = 15)
    {
        $uri = $_SERVER['REQUEST_URI'];
        $uri = trim($uri, '/');
        if (strpos($uri, '?')) {
            $uri = substr($uri, 0, strpos($uri, '?'));
        }
        $page = isset($_GET['page']) ? $_GET['page'] : 1;
        $start = ($page - 1) * $cant;

        /* if ($this->sql) {
            $sql = $this->sql . ($this->orderBy ?? '') . " LIMIT {$start}, {$cant}";
            $data = $this->query($sql, $this->data, $this->params)->get();
        } else {
            $sql = "SELECT SQL_CALC_FOUND_ROWS * FROM {$this->table} " . ($this->orderBy ?? '') . " LIMIT {$start}, {$cant}";
            $data = $this->query($sql)->get();
        } */

        if (empty($this->query)) {

            $sql = "SELECT SQL_CALC_FOUND_ROWS {$this->select} FROM {$this->table}";

            if ($this->join) {
                $sql .= $this->join;
            }

            if ($this->where) {
                $sql .= " WHERE {$this->where}";
            }

            if ($this->orderBy) {
                $sql .= " ORDER BY {$this->orderBy}";
            }

            if ($this->limit) {
                $sql .= $this->limit;
            }

            $data = $this->query($sql, $this->values, $this->params)->get();
        }

        $total = $this->query("SELECT FOUND_ROWS() as total")->first()['total'];
        $last_page = ceil($total / $cant);
        return [
            'total' => $total,
            'from' => $start + 1, //desde que registro se muestra
            'to' => $start + count($data), // hasta que registro se muestra
            'current_page' => $page, //pagina actual
            'per_page' => $cant, //cantidad de registros por pagina
            'next_page_url' => $page < $last_page ?  "/{$uri}?page=" . ($page + 1) : null, //pagina siguiente
            'prev_page_url' => $page > 1 ? "/{$uri}?page=" . ($page - 1) : null, //pagina anterior
            'last_page' => $last_page, //ultimo numero de pagina
            'data' => $data,
        ];
    }

    public function paginate_int($cant = 15, $pg = 1, $srt = "", $ordr = "")
    {
        $uri = $_SERVER['REQUEST_URI'];
        $uri = trim($uri, '/');
        if (strpos($uri, '?')) {
            $uri = substr($uri, 0, strpos($uri, '?'));
        }
        // $cant = isset($_GET['limit']) && is_numeric($_GET['limit']) ? $_GET['limit'] : $cant;
        $page = $pg != 1 && is_numeric($pg) ? $pg : 1;
        $sort = $srt != "" ? "ORDER BY " . strClean($srt) : $this->orderBy;
        $order = $ordr != "" ? strClean($ordr) : "";
        $start = ($page - 1) * $cant;

        if ($this->sql) {
            $sql = $this->sql . ' ' . $sort . ' ' . $order . " LIMIT {$start}, {$cant}";
            $data = $this->query($sql, $this->data, $this->params)->get();
        } else {
            $sql = "SELECT SQL_CALC_FOUND_ROWS * FROM {$this->table} " . $sort . ' ' . $order . " LIMIT {$start}, {$cant}";
            $data = $this->query($sql)->get();
        }

        $total = $this->query("SELECT FOUND_ROWS() as total")->first()['total'];
        $last_page = ceil($total / $cant);
        $next_page_url = $page < $last_page ?  "/{$uri}?page=" . ($page + 1) . "&limit=" . $cant : null;
        $prev_page_url = $page > 1 ? "/{$uri}?page=" . ($page - 1) . "&limit=" . $cant  : null;
        return [
            'total' => $total,
            'from' => $start + 1, //desde que registro se muestra
            'to' => $start + count($data), // hasta que registro se muestra
            'current_page' => $page, //pagina actual
            'per_page' => $cant, //cantidad de registros por pagina
            'next_page_url' => $next_page_url, //pagina siguiente
            'prev_page_url' => $prev_page_url, //pagina anterior
            'last_page' => $last_page, //ultimo numero de pagina
            'data' => $data,
        ];
    }

    // funcion union all
    public function unionAll(array $data = [])
    {
        if ($this->unionAll) {
            $this->unionAll .= " UNION ALL " . $data["sql"];
        } else {
            $this->unionAll = $data["sql"];
        }
        if (!empty($this->values)) {
            $this->values = array_merge($this->values, $data["values"]);
        } else {
            $this->values = $data["values"];
        }

        return $this;
    }

    //consulttas preparadas
    public function all()
    {
        $sql = "SELECT * FROM {$this->table}";
        return $this->query($sql)->get();
    }

    public function find($id, $isUuid = false)
    {
        // $sql = "SELECT {$this->select} FROM {$this->table} WHERE {$this->id} = ?";
        // return $this->query($sql, [$id], "i")->first();
        $paramType = $isUuid ? 's' : 'i';
        $sql = "SELECT {$this->select} FROM {$this->table} WHERE {$this->id} = ?";
        return $this->query($sql, [$id], $paramType)->first();
    }

    public function create($data)
    {
        // $columns = implode(", ", array_keys($data));
        // // $values = "'" . implode("', '", array_values($data)) . "'";
        // $values = array_values($data);

        // // $sql = "INSERT INTO {$this->table} ({$columns}) VALUES ({$values})";
        // $sql = "INSERT INTO {$this->table} ({$columns}) VALUES (" . str_repeat("?,", count($values) - 1) . "?)";
        // $this->query($sql, $values);
        // $insert_id = $this->connection->insert_id;

        // return $this->find($insert_id);

        $columns = implode(", ", array_keys($data));
        $values = array_values($data);
        $sql = "INSERT INTO {$this->table} ({$columns}) VALUES (" . str_repeat("?,", count($values) - 1) . "?)";
        $this->query($sql, $values);
        $insert_id = $this->connection->insert_id;

        // Determinar el tipo de ID (int o string)
        $isuuid = is_int($insert_id) ? false : true;

        return $this->find($insert_id, $isuuid);
    }

    public function update($id, $data, $isUuid = false)
    {
        // $fields = [];
        // foreach ($data as $key => $value) {
        //     $fields[] = "{$key} = ?";
        // }
        // $fields = implode(", ", $fields);
        // $sql = "UPDATE {$this->table} SET {$fields} WHERE {$this->id} = ?";
        // $values = array_values($data);
        // $values[] = $id;
        // $this->query($sql, $values);
        // return $this->find($id);

        $fields = [];
        foreach ($data as $key => $value) {
            $fields[] = "{$key} = ?";
        }
        $fields = implode(", ", $fields);
        $sql = "UPDATE {$this->table} SET {$fields} WHERE {$this->id} = ?";
        $values = array_values($data);
        $values[] = $id;
        $isUuid = is_int($id) ? false : true;
        $paramType = $isUuid ? 's' : 'i';
        $this->query($sql, $values, str_repeat("s", count($data)) . $paramType);
        return $this->find($id, $isUuid);
    }

    public function delete($id, $isUuid = false)
    {
        $paramType = $isUuid ? 's' : 'i';
        $sql = "DELETE FROM {$this->table} WHERE {$this->id} = ?";
        $this->query($sql, [$id], $paramType);
        return $this->connection->affected_rows;
    }

    // funcion para ejecutar multiples consultas en una sola linea con mysqli_multi_query
    public function multiQuery($sql)
    {
        return $this->connection->multi_query($sql);
    }

    public function previewSql(): array
    {
        // dep("aca");
        // dep($this->unionAll);
        if (!empty($this->unionAll)) {

            dep("union all");
            $sql = $this->unionAll;

            $params = $this->values;

            return ['sql' => $sql, 'values' => $params];
        }

        // dep("paso",1);
        $sql = "SELECT {$this->select} FROM {$this->table}";

        if ($this->join) {
            $sql .= $this->join;
        }

        $params = [];

        if ($this->where) {
            $sql .= " WHERE {$this->where}";
            // Supongamos que $this->whereParams es un arreglo asociativo de parámetros
            $params = $this->values;
        }

        if ($this->orderBy) {
            $sql .= " ORDER BY {$this->orderBy}";
        }

        if ($this->limit) {
            $sql .= $this->limit;
        }

        // Devuelve un arreglo con la consulta SQL y los parámetros
        return ['sql' => $sql, 'values' => $params];
    }
}
