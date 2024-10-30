<?php header_web('Template.HeaderDashboard', $data); ?>
<div class="card mb-4">
    <div class="card-header bg-label-primary">
        <h4 class="text-primary fw-bold mb-2">Panel de Control</h4>
    </div>
    <div class="card-body">
        <p class="text-black pt-4">Gestiona el proceso de entrenamiento del modelo</p>
        <div class="row mb-5 gap-2 gap-md-0">
            <div class="col-12 col-lg-auto me-lg-2">
                <button type="button" class="btn btn-primary fw-semibold gap-2 w-100">
                    <i class='bx bx-play-circle fw-normal'></i>
                    Iniciar Entrenamiento
                </button>
            </div>
            <div class="col-12 col-lg-auto p-lg-0 me-lg-2">
                <button type="button" class="btn btn-outline-secondary fw-semibold gap-2 w-100">
                    <i class="fa-solid fa-rotate-right fw-semibold"></i>
                    Reiniciar
                </button>
            </div>
            <div class="col-12 col-lg-auto p-lg-0 mt-4 mt-md-0">
                <select name="" id="" class="form-select">
                    <option value="0">Seleccione los datos de entrenamiento</option>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="col-12 text-dark fw-semibold mb-3">
                Últimos Eventos
            </div>
            <div class="col-auto pe-0 mb-1">
                <i class='bx bx-time-five mb-1'></i>
            </div>
            <div class="col-10 col-lg-3 ps-2 text-dark mb-1">
                Última actualización: <span class="text-time fw-bold">Hace 5 minutos</span>
            </div>
            <div></div>
            <div class="col-auto pe-0">
                <i class='bx bx-info-circle text-warning'></i>
            </div>
            <div class="col-10 col-lg-3 ps-2 text-dark">
                Precisión: <span class="text-precision fw-bold">89.0%</span>
            </div>
        </div>
    </div>
</div>
<div class="card mb-4">
    <div class="card-header bg-label-primary">
        <h4 class="text-primary fw-bold mb-2">Modelo de IA</h4>
    </div>
    <div class="card-body">
        <p class="text-black pt-4">
            Elige el modelo que deseas utilizar para realizar predicciones
        </p>
        <div class="row mb-5">
            <div class="col-12 col-lg-auto pe-lg-0 mb-3">
                <select name="" id="" class="form-select">
                    <option value="0">Seleccione un modelo entrenado</option>
                </select>
            </div>
            <div class="col-12 col-lg-auto">
                <button type="button" class="btn btn-primary fw-semibold gap-2 w-100">
                    <i class='bx bx-play-circle fw-normal'></i>
                    Seleccionar Modelo
                </button>
            </div>
        </div>
    </div>
</div>
<?php footer_web('Template.FooterDashboard', $data); ?>