<?php header_web('Template.HeaderDashboard', $data); ?>
<div class="card">
    <div class="card-header">
        <div class="d-flex justify-content-between">

            <?php
            if ($data['permisos']['perm_w'] == 1) {
            ?>
                <button class="btn btn-primary ft-b" type="button" onclick="openModal();">
                    <i class='bx bx-plus-circle'></i> Nuevo
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
        <table id="sis_submenus" class="table table-hover" width="100%">
            <thead>
                <tr>
                    <th width="5%">N°</th>
                    <th width="20%">Sub menu</th>
                    <th width="20%">Menu</th>
                    <th>Url</th>
                    <th>Orden</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</div>
<?php
if ($data['permisos']['perm_w'] == 1 || $data['permisos']['perm_u'] == 1)
    getModal('mdlSubmenus', $data);
footer_web('Template.FooterDashboard', $data);
?>