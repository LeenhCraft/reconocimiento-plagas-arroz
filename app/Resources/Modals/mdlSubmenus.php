<div class="modal fade" id="modalsubmenus" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" style="display: none;" aria-hidden="true">
    <div class="modal-dialog modal-sm">
        <form id="submenus_form" class="modal-content" onsubmit="return save(this,event)">
            <div class="modal-header">
                <h5 class="modal-title">
                    <span class="title-icon">
                        <i class='bx bx-menu bx-sm text-info fw-bold'></i>
                    </span>
                    <span class="modal-form">Sub Menus</span>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="id" name="id">
                <div class="row">
                    <div class="form-group mb-2 col-12 div_id d-none">
                        <label for="idv">Id</label>
                        <input type="text" class="form-control" id="idv" name="idv" disabled>
                    </div>
                    <div class="form-group mb-2 col-12">
                        <label for="idmenu">Menu</label>
                        <select class="form-select text-capitalize" id="idmenu" name="idmenu">
                            <option value="0">Seleccione</option>
                        </select>
                    </div>
                    <div class="form-group col-12 mb-2">
                        <label for="name">Sub Menu</label>
                        <input type="text" class="form-control" id="name" name="name">
                    </div>
                </div>
                <div class="row">
                    <div class="form-group col-12 col-lg-6 mb-2">
                        <label for="icon">Icono</label>
                        <input type="text" class="form-control" id="icon" name="icon">
                    </div>
                    <div class="form-group col-12 col-lg-6 mb-2">
                        <label for="url">Url</label>
                        <input type="text" class="form-control" id="url" name="url">
                    </div>
                    <div class="col-12 mb-2 col-lg-6">
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" id="sub_externo" name="sub_externo">
                            <label class="form-check-label" for="sub_externo">
                                Enlace externo
                            </label>
                        </div>
                    </div>
                </div>
                <div class="row mb-2">
                    <div class="form-group col-12">
                        <label for="controller">Controlador</label>
                        <input type="text" class="form-control" id="controller" name="controller">
                    </div>
                </div>
                <div class="row">
                    <div class="form-group col-md-6 col-12 mb-2">
                        <label for="order">Orden</label>
                        <input type="number" class="form-control" id="order" name="order">
                    </div>
                    <div class="form-group col-md-6 col-12 mb-2">
                        <label for="visible">Visible</label>
                        <select class="form-select" id="visible" name="visible">
                            <option value="1">Si</option>
                            <option value="0">No</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="form-group col-12 div_id mb-2">
                        <label for="fecha">F. Creación</label>
                        <input type="text" class="form-control" id="fecha" disabled>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" id="btnText" class="btn btn-primary py-0 px-3">
                    <label class="btn-icon cursor-pointer">
                        <i class='bx bx-check-double'></i>
                    </label>
                    <label class="btn-text cursor-pointer">
                        Guardar
                    </label>
                </button>
            </div>
        </form>
    </div>
</div>
<!-- Modal Views -->
<div class="modal fade" id="mdView" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header header-primary">
                <h5 class="modal-title" id="titleModal">Datos del Submenus</h5>
            </div>
            <div class="modal-body">

                <table class="table table-bordered">
                    <tbody>

                        <tr>
                            <td>Idsubmenu: </td>
                            <td id="idsubmenu"></td>
                        </tr>
                        <tr>
                            <td>Idmenu: </td>
                            <td id="idmenuu"></td>
                        </tr>
                        <tr>
                            <td>Sub_nombre: </td>
                            <td id="sub_nombre"></td>
                        </tr>
                        <tr>
                            <td>Sub_url: </td>
                            <td id="sub_url"></td>
                        </tr>
                        <tr>
                            <td>Sub_controlador: </td>
                            <td id="sub_controlador"></td>
                        </tr>
                        <tr>
                            <td>Sub_icono: </td>
                            <td id="sub_icono"></td>
                        </tr>
                        <tr>
                            <td>Sub_orden: </td>
                            <td id="sub_orden"></td>
                        </tr>
                        <tr>
                            <td>Sub_visible: </td>
                            <td id="sub_visible"></td>
                        </tr>
                        <tr>
                            <td>Sub_fecha: </td>
                            <td id="sub_fecha"></td>
                        </tr>
                    </tbody>
                </table>

            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>

<!-- Model Edit -->