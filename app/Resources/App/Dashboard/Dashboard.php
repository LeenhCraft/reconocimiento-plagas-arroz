<?php header_web('Template.HeaderDashboard', $data); ?>
<div class="row">
    <div class="col-2">
        <a href="/admin/plagas">
            <div class="card h-100">
                <div class="card-body">
                    <h5 class="card-title text-center fw-bold text-info">Plagas de Arroz</h5>
                    <div class="my-4 text-center text-info">
                        <i class="fa-solid fa-bug fa-4x"></i>
                    </div>
                    <p class="card-text text-decoration-none text-black">Gestión de las plagas y enfermedades del arroz.</p>
                </div>
            </div>
        </a>
    </div>
    <div class="col-2">
        <a href="/admin/prediccion">
            <div class="card h-100">
                <div class="card-body">
                    <h5 class="card-title text-center fw-bold text-success">Detectar</h5>
                    <div class="my-4 text-center text-success">
                        <i class="fa-solid fa-brain fa-4x"></i>
                    </div>
                    <p class="card-text text-decoration-none text-black">
                        Detectar enfermedades en las plantas de arroz.
                    </p>
                </div>
            </div>
        </a>
    </div>
    <!-- entrenar un nuevo modelo -->
    <div class="col-2">
        <a href="/admin/entrenar">
            <div class="card h-100">
                <div class="card-body">
                    <h5 class="card-title text-center fw-bold text-warning">
                        Entrenar Modelo
                    </h5>
                    <div class="my-4 text-center text-warning">
                        <i class="fa-solid fa-diagram-project fa-4x"></i>
                    </div>
                    <p class="card-text text-decoration-none text-black">
                        Entrenar un nuevo modelo de IA.
                    </p>
                </div>
            </div>
        </a>
    </div>
    <div class="col-2">
        <a href="/admin/datos">
            <div class="card h-100">
                <div class="card-body">
                    <h5 class="card-title text-center fw-bold text-dark">
                        Generar Datos
                    </h5>
                    <div class="my-4 text-center text-dark">
                        <i class="fa-solid fa-database fa-4x"></i>
                    </div>
                    <p class="card-text text-decoration-none text-black">
                        Se utiliza para generar datos de entrenamiento.
                    </p>
                </div>
            </div>
        </a>
    </div>
</div>
<?php footer_web('Template.FooterDashboard', $data); ?>