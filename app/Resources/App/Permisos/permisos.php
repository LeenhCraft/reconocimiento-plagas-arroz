<?php header_web('Template.HeaderDashboard', $data); ?>
<div class="card">
    <div class="card-header">
        <?php
        if ($data['permisos']['perm_w'] == 1) {
        ?>
            <button class="btn btn-primary ft-b mb-2 text-nowrap" type="button" onclick="openModal();">
                <i class='bx bx-plus-circle'></i> Nuevo Permisos
            </button>
            <p class="mb-0">Agregar un permiso si no existe</p>
        <?php
        }
        ?>
    </div>
    <div class="car-body">
        <div class="table-responsive text-nowrap mb-4">
            <table id="sis_permisos" class="table table-hover" width="100%">
                <thead>
                    <tr>
                        <th>N°</th>
                        <th>Rol</th>
                        <th>Menu</th>
                        <th>Sub Menu</th>
                        <th>Leer</th>
                        <th>Escribir</th>
                        <th>Actualizar</th>
                        <th>Eliminar</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
</div>
<?php
if ($data['permisos']['perm_w'] == 1 || $data['permisos']['perm_u'] == 1)
    getModal('mdlPermisos', $data);
footer_web('Template.FooterDashboard', $data);
?>