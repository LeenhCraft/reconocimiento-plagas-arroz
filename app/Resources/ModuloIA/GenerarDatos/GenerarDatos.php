<?php header_web('Template.HeaderDashboard', $data); ?>
<style>
    .card-compac {
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .card-compac:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
</style>
<div class="card">
    <div class="card-header bg-label-primary">
        <h4 class="fw-bold text-primary">Información necesaria para generar los datos de entrenamiento</h4>
    </div>
    <div class="card-body">
        <div class="row gap-md-5">
            <div class="col-12 col-lg-5">
                <form id="form" class="pt-4">
                    <div>
                        <h5>Rutas</h5>
                        <hr>
                    </div>

                    <div class="col-12 mb-4">
                        <label for="ruta" class="text-primary fw-semibold fs-6">Datos Generados</label>
                        <div class="input-group input-group-merge">
                            <span class="input-group-text"><?php echo base_url(); ?></span>
                            <input
                                type="text"
                                id="ruta_datos_generados"
                                name="ruta_datos_generados"
                                class="form-control bg-transparent"
                                placeholder="img"
                                value="<?= $data["data"]["ruta_datos_generados"] ?>">
                        </div>
                    </div>
                    <div class="col-12 mb-4">
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
                    <div class="col-12 mb-4">
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
                    <div class="col-12 mb-4">
                        <label for="nombre" class="text-primary fw-semibold fs-6">Nombre para Guardar los Datos de Entrenamiento</label>
                        <input
                            type="text"
                            class="form-control bg-transparent"
                            id="nombre"
                            name="nombre_datos_entrenamiento"
                            placeholder="datos-de-entrenamiento.npy"
                            value="<?= $data["data"]["nombre_datos_entrenamiento"] ?>">
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary">
                            <i class="fa-solid fa-shield-halved me-2"></i>
                            Guardar Datos
                        </button>
                    </div>
                </form>
            </div>
            <div class="col-12 col-lg-6">
                <div class="pt-4">
                    <div class="d-flex gap-3 align-items-center justify-content-between">
                        <h5 class="m-0 p-0">Datos Generados</h5>
                        <button id="generarDatos" type="button" class="btn btn-warning fw-semibold">
                            <i class="fa-solid fa-download me-2"></i>
                            Generar Nuevos Datos
                        </button>
                    </div>
                    <hr>
                </div>
                <div class="token my-4">
                    <input type="hidden" id="uuid" name="uuid" value="<?php echo $data["uuid"] ?>">
                    <label for="" class="text-dark">Token de seguridad para generar datos.</label>
                    <p class="fw-bold fs-6 text-primary"><?php echo $data["uuid"] ?></p>
                </div>
                <div id="compac-container" class="row">
                    <div class="col-12 card card-compac p-3 cursor-pointer">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="text-dark fw-bold fs-7">03/11/2024 15:30</span>
                            <span class="bg-white text-success py-1 px-2 fw-semibold fs-6">
                                <i class="fas fa-check-circle me-1"></i>
                                100%
                            </span>
                        </div>
                        <div class="d-flex gap-4 align-items-center flex-wrap">
                            <div class="d-flex align-items-center gap-2">
                                <i class="fas fa-images me-1" style="color: #3b82f6;"></i>
                                <span class="fs-7 text-black">Total:</span>
                                <span class="fs-7 text-dark fw-bold">407</span>
                            </div>

                            <span class="text-light">|</span>

                            <div class="d-flex align-items-center gap-2">
                                <i class="fas fa-brain me-1" style="color: #8b5cf6;"></i>
                                <span class="fs-7 text-black">Train:</span>
                                <span class="fs-7 text-dark fw-bold">323</span>
                            </div>

                            <span class="text-light">|</span>

                            <div class="d-flex align-items-center gap-2">
                                <i class="fas fa-check-double me-1" style="color: #10b981;"></i>
                                <span class="fs-7 text-black">Val:</span>
                                <span class="fs-7 text-dark fw-bold">84</span>
                            </div>
                        </div>

                        <div class="d-flex gap-3 mt-2">
                            <div class="class-pill">Caracol manzana (93)</div>
                            <div class="class-pill">Falso medidor (84)</div>
                            <div class="class-pill">Gusano cogollero (82)</div>
                            <div class="class-pill">...</div>
                            <i class="fas fa-chevron-right ms-auto text-gray"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="card-footer"></div>
</div>
<?php footer_web('Template.FooterDashboard', $data); ?>