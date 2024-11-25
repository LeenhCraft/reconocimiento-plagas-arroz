<?php
header_web('Template.HeaderDashboard', $data);
$yaml = json_decode($data["datatrain"]["yaml"], true);
$yaml["yaml_path"] = str_replace("\\", "/", $yaml["yaml_path"]);
$rutas = json_decode($data["config"]["valor"], true);
$rutas["path_weights"] = str_replace("\\", "/", $rutas["path_weights"]);
?>
<div class="card mb-4">
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <div>
                <h5 class="text-primary fw-bold mb-2">
                    <i class='bx bxl-codepen bx-sm'></i>
                    Modelos Entrenados YOLOv5
                </h5>
                <p>
                    Gestione y seleccione los modelos entrenados para su uso
                </p>
            </div>
            <div>
                <button id="entrenarModelo" type="button" class="btn btn-primary fw-semibold gap-2">
                    <i class='bx bx-play-circle fw-normal bx-sm'></i>
                    Iniciar Entrenamiento
                </button>
            </div>
        </div>
    </div>
    <div class="card-body">
        <div class="px-3">
            <div class="row mb-4 justify-content-between">
                <div class="col-12 col-lg-3 card mb-3">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <p class="mb-0">Total Modelos</p>
                                <p class="mb-0 fs-4 fw-bold text-dark">
                                    <?= $data["cantidad_modelos"] ?>
                                </p>
                            </div>
                            <i class='bx bx-package bx-lg d-flex align-items-center text-secondary'></i>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-lg-4 card mb-3">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <p class="mb-0">Mejor Precision</p>
                                <p class="mb-0 fs-4 fw-bold text-dark"><?= $data["precision"] ?> %</p>
                            </div>
                            <i class='bx bx-stats bx-lg d-flex align-items-center text-info'></i>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-lg-4 card mb-3">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <p class="mb-0">Modelo Activo</p>
                                <p class="mb-0 fs-5 fw-bold text-dark"><?= $data["nombre_modelo"] ?></p>
                            </div>
                            <i class='bx bx-play bx-lg d-flex align-items-center text-success'></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="table-responsive">
            <table id="tb" class="datatables-basic table border-top" width="100%">
                <thead>
                    <tr>
                        <th></th>
                        <th>Nombre</th>
                        <th>Precisión</th>
                        <th>Fecha</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</div>
<form id="config_train" class="card">
    <div class="card-header">
        <h5 class="text-primary fw-bold mb-2">
            <i class='bx bxs-cog bx-sm'></i>
            Configuración de Entrenamiento YOLOv5
        </h5>
        <p>Configure los parámetros para entrenar su modelo de detección de objetos</p>
    </div>
    <div class="card-body">
        <h5 class="text-black fw-bold">Archivos y Rutas</h5>
        <div class="mb-3">
            <label class="form-label text-none fs-7" for="yaml_path">Archivo data.yaml:</label>
            <div class="col-9 col-lg-10">
                <input
                    type="text"
                    class="form-control text-primary fw-semibold"
                    id="yaml_path"
                    name="yaml_path"
                    placeholder="Ruta al archivo data.yaml"
                    readonly
                    value="<?= $yaml["yaml_path"] ?>">
            </div>
        </div>
        <div class="mb-3">
            <label class="form-label text-none fs-7" for="ruta_modelo">Directorio de Salida: <span class="fw-bold text-danger">*</span></label>
            <div class="col-9 col-lg-10">
                <input
                    type="text"
                    class="form-control text-primary"
                    id="ruta_modelo"
                    name="ruta_modelo"
                    placeholder="Ruta donde se guardarán los resultados"
                    value="<?= "/" . $rutas["ruta_modelo"] . "/" ?>">
            </div>
        </div>
        <div class="mb-4">
            <label class="form-label text-none fs-7" for="nombre_modelo">Nombre del Experimento: <span class="fw-bold text-danger">*</span></label>
            <div class="col-12 col-lg-10">
                <input
                    type="text"
                    class="form-control"
                    id="nombre_modelo"
                    name="nombre_modelo"
                    placeholder="Nombre para identificar este entrenamiento"
                    value="<?= $rutas["nombre_modelo"] . "_[marca de tiempo]" ?? "exp" ?>">
            </div>
        </div>
        <br>
        <h5 class="text-black fw-bold">Parámetros de Entrenamiento</h5>
        <div class="row">
            <div class="col-12 col-lg-5">
                <div class="mb-3">
                    <label for="epochs" class="form-label text-none fs-7">Épocas: <span class="fw-bold text-danger">*</span></label>
                    <input
                        type="number"
                        class="form-control"
                        id="epochs"
                        name="epochs"
                        placeholder="Nombre para identificar este entrenamiento"
                        value="<?= $rutas["epochs"] ?? "100" ?>">
                </div>
                <div class="mb-3">
                    <label for="img_size" class="form-label text-none fs-7">Tamaño de Imagen: <span class="fw-bold text-danger">*</span></label>
                    <input
                        type="number"
                        class="form-control"
                        id="img_size"
                        name="img_size"
                        placeholder="Nombre para identificar este entrenamiento"
                        value="<?= $rutas["img_size"] ?? "100" ?>">
                </div>
            </div>
            <div class="col-12 col-lg-5">
                <div class="mb-3">
                    <label for="batch_size" class="form-label text-none fs-7">Tamaño de Batch: <span class="fw-bold text-danger">*</span></label>
                    <input
                        type="number"
                        class="form-control"
                        id="batch_size"
                        name="batch_size"
                        placeholder="Nombre para identificar este entrenamiento"
                        value="<?= $rutas["batch_size"] ?>">
                </div>
                <div class="mb-3">
                    <label for="model_size" class="form-label text-none fs-7">Tamaño del Modelo: <span class="fw-bold text-danger">*</span></label>
                    <select name="model_size" id="model_size" class="form-select">
                        <option value="">Seleccione una opción</option>
                        <option selected value="n">Nano</option>
                        <option value="s">Small</option>
                        <option value="m">Medium</option>
                        <option value="l">Large</option>
                        <option value="x">XLarge</option>
                    </select>
                </div>
            </div>
        </div>
        <br>
        <h5 class="text-black fw-bold">Configuración Avanzada</h5>
        <div class="mb-3">
            <div class="col-12 col-lg-10 d-flex justify-content-between">
                <div>
                    <p class="text-black fw-semibold mb-0">Usar Pesos Pre-entrenados</p>
                    <p>Iniciar el entrenamiento con pesos pre-entrenados</p>
                </div>
                <div class="d-block">
                    <label class="switch switch-lg m-0">
                        <input
                            type="checkbox"
                            class="switch-input"
                            <?php echo $rutas["weights"] ? "checked" : ""; ?>
                            id="weights"
                            name="weights">
                        <span class="switch-toggle-slider">
                            <span class="switch-on">
                                <i class="bx bx-check"></i>
                            </span>
                            <span class="switch-off">
                                <i class="bx bx-x"></i>
                            </span>
                        </span>
                        <span class="switch-label"></span>
                    </label>
                </div>
            </div>
            <div class="mb-4">
                <label class="form-label text-none fs-7" for="path_weights">Ruta a Pesos Pre-entrenados</label>
                <div class="col-9 col-lg-10">
                    <input
                        type="text"
                        class="form-control text-primary fw-semibold"
                        id="path_weights"
                        name="path_weights"
                        placeholder="Ruta al archivo de pesos"
                        readonly
                        value="<?= $rutas["path_weights"] ?? "" ?>">
                </div>
            </div>
            <div class="col-12 col-lg-10 d-flex justify-content-between mb-3">
                <div>
                    <p class="text-black fw-semibold mb-0">Modo Debug</p>
                    <p>Mostrar información detallada durante el entrenamiento</p>
                </div>
                <div class="d-block">
                    <label class="switch switch-lg m-0">
                        <input
                            type="checkbox"
                            class="switch-input"
                            <?php echo $rutas["debug"] ? "checked" : ""; ?>
                            name="debug">
                        <span class="switch-toggle-slider">
                            <span class="switch-on">
                                <i class="bx bx-check"></i>
                            </span>
                            <span class="switch-off">
                                <i class="bx bx-x"></i>
                            </span>
                        </span>
                        <span class="switch-label"></span>
                    </label>
                </div>
            </div>
        </div>
        <hr>
        <p class="text-black fw-semibold mb-1">Token de Seguridad</p>
        <input type="hidden" id="uuid" name="uuid" value="<?php echo $data["uuid"] ?>">
        <p class="fs-6">
            Para fines de seguridad, se requiere un token para generar datos.
        </p>
        <p class="text-primary fw-bold"><?php echo $data["uuid"] ?></p>
    </div>
    <div class="card-footer">
        <div class="col-12 col-lg-10 d-flex justify-content-between">
            <button type="submit" class="btn btn-outline-primary fw-bold gap-2">
                <i class='bx bxs-check-shield me-1 bx-sm'></i>Guardar Configuración
            </button>
        </div>
    </div>
</form>
<?php footer_web('Template.FooterDashboard', $data); ?>