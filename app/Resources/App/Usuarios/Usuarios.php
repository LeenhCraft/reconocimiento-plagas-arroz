<?php header_web('Template.HeaderDashboard', $data); ?>
<div class="card">
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <?php
            if ($data['permisos']['perm_w'] == 1) {
            ?>
                <button id="btnNuevo" type="button" class="btn btn-primary">
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
    <div class="table-responsive text-nowrap mb-4">
        <table id="tb" class="table table-hover" width="100%">
            <thead>
                <tr>
                    <th>N°</th>
                    <th>Usuario</th>
                    <th>Rol</th>
                    <th>estado</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</div>
<?php
if ($data['permisos']['perm_w'] == 1 || $data['permisos']['perm_u'] == 1) {
    getModal('mdlUsuarios', $data);
}
footer_web('Template.FooterDashboard', $data);
?>