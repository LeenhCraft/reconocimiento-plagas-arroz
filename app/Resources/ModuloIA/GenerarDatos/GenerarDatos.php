<?php header_web('Template.HeaderDashboard', $data); ?>
<div class="card">
    <div class="card-header bg-label-primary">
        <h4 class="fw-bold text-primary">Información necesaria para generar los datos de entrenamiento</h4>
    </div>
    <div class="card-body">
        <form id="form" class="pt-4">
            <div>
                <h5>Rutas</h5>
                <hr>
            </div>
            <div class="col-12 col-md-6 col-lg-6 col-xl-4 mb-4">
                <label for="ruta" class="text-primary fw-semibold fs-6">Imagenes para entrenar</label>
                <div class="input-group input-group-merge">
                    <span class="input-group-text"><?php echo base_url(); ?></span>
                    <input
                        type="text"
                        id="carpeta_img_entrenamiento"
                        name="carpeta_img_entrenamiento"
                        class="form-control bg-transparent"
                        placeholder="img"
                        value="<?= $data["data"]["carpeta_img_entrenamiento"] ?>">
                </div>
            </div>
            <div class="col-12 col-md-6 col-lg-6 col-xl-4 mb-4">
                <label for="ruta" class="text-primary fw-semibold fs-6">
                    Datos de entrenamiento
                </label>
                <div class="input-group input-group-merge">
                    <span class="input-group-text"><?php echo base_url(); ?></span>
                    <input
                        type="text"
                        class="form-control bg-transparent"
                        placeholder="train"
                        id="ruta"
                        name="ruta_datos_entrenamiento"
                        value="<?= $data["data"]["ruta_datos_entrenamiento"] ?>">
                </div>
            </div>
            <div class="col-12 col-md-6 col-lg-6 col-xl-4 mb-4">
                <label for="nombre" class="text-primary fw-semibold fs-6">Nombre para Guardar los Datos de Entrenamiento</label>
                <input
                    type="text"
                    class="form-control bg-transparent"
                    id="nombre"
                    name="nombre_datos_entrenamiento"
                    placeholder="datos-de-entrenamiento.npy"
                    value="<?= $data["data"]["nombre_datos_entrenamiento"] ?>">
            </div>
            <div class="col-12 col-md-6 col-lg-6 col-xl-4">
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-shield-halved me-2"></i>
                    Guardar
                </button>
            </div>
        </form>
    </div>
    <div class="card-footer"></div>
</div>
<?php footer_web('Template.FooterDashboard', $data); ?>