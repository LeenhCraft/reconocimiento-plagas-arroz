<?php header_web('Template.HeaderDashboard', $data); ?>
<main class="app-content">
    <div class="card">
        <div class="card-header">
        <div class="d-flex justify-content-between">
                <?php
                if ($data['permisos']['perm_w'] == 1) {
                ?>
                    <button id="btnNuevo" class="btn btn-primary" type="button">
                        <i class='bx bx-plus-medical me-1'></i>
                        Agregar
                    </button>
                <?php
                }
                ?>
                <button id="btnRecargar" class="btn btn-warning" type="button">
                    <i class="fa-solid fa-arrow-rotate-right me-1"></i>
                    Recargar
                </button>
            </div>
        </div>
        <div class="car-body">
            <div class="table-responsive text-nowrap mb-4">
                <table id="tb" class="table table-hover" width="100%">
                    <thead>
                        <tr>
                            <th>N°</th>
                            <th>Nombre</th>
                            <th>Email</th>
                            <th>Estado</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th colspan="5" class="text-center">Sin registros</th>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<?php
if ($data['permisos']['perm_w'] == 1 || $data['permisos']['perm_u'] == 1) {
    getModal('mdlPersonal', $data);
}
footer_web('Template.FooterDashboard', $data);
?>