<div class="modal fade" id="modalmenus" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" style="display: none;" aria-hidden="true">
    <div class="modal-dialog modal-sm">
        <form id="menus_form" class="modal-content" onsubmit="return save(this,event)">
            <div class="modal-header">
                <h5 class="modal-title" id="modalmenusTitle">Menu</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="id" name="id" value="">
                <div class="row mb-2">
                    <div class="col-12">
                        <label class="form-label" for="name">Nombre</label>
                        <input type="text" class="form-control" id="name" name="name">
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-12">
                        <label class="form-label" for="icon">Icono</label>
                        <input type="text" class="form-control" id="icon" name="icon">
                    </div>
                </div>
                <div class="row mb-2">
                    <div class="col-md-4">
                        <div class="input-group border-0 d-flex align-items-center">
                            <div class="input-group-text border-0 ps-0">
                                <input class="form-check-input mt-0" id="url_si" name="url_si" type="checkbox">
                            </div>
                            <label class="p-0 m-0 form-label" for="url_si">Nivel 1</label>
                        </div>
                    </div>
                </div>
                <div class="row mb-2">
                    <div class="col-12 col-md-6 mb-2 mb-lg-0 in_hidde" style="display: none;">
                        <input type="text" class="form-control" id="url" name="url" placeholder="url del menu" disabled>
                    </div>
                    <div class="col-12 col-md-6 mb-2 mb-lg-0 in_hidde" style="display: none;">
                        <input type="text" class="form-control" id="controller" name="controller" placeholder="Controlador" disabled>
                    </div>
                </div>
                <div class="row mb-2">
                    <div class="col-12 col-lg-6">
                        <label for="order">Orden</label>
                        <input type="number" class="form-control" id="order" name="order">
                    </div>
                    <div class="col-12 col-lg-6">
                        <label for="visible">Visible</label>
                        <select class="form-control" id="visible" name="visible">
                            <option value="1">Si</option>
                            <option value="0">No</option>
                        </select>
                    </div>
                </div>
                <div class="row div_fecha">
                    <div class="col-12">
                        <label for="fecha">F. Creación</label>
                        <input type="text" class="form-control" id="fecha" name="fecha" disabled>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="btn btn-primary px-2 py-0">
                    <span class="btn-icon">
                        <i class='bx bx-check-double'></i>
                    </span>
                    <span class="btn-text">
                        Guardar
                    </span>
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
                <h5 class="modal-title" id="titleModal">Datos del Menus</h5>
            </div>
            <div class="modal-body">

                <table class="table table-bordered">
                    <tbody>

                        <tr>
                            <td>Idmenu: </td>
                            <td id="idmenu"></td>
                        </tr>
                        <tr>
                            <td>Men_nombre: </td>
                            <td id="men_nombre"></td>
                        </tr>
                        <tr>
                            <td>Men_icono: </td>
                            <td id="men_icono"></td>
                        </tr>
                        <tr>
                            <td>Men_url_si: </td>
                            <td id="men_url_si"></td>
                        </tr>
                        <tr>
                            <td>Men_url: </td>
                            <td id="men_url"></td>
                        </tr>
                        <tr>
                            <td>Men_controlador: </td>
                            <td id="men_controlador"></td>
                        </tr>
                        <tr>
                            <td>Men_orden: </td>
                            <td id="men_orden"></td>
                        </tr>
                        <tr>
                            <td>Men_visible: </td>
                            <td id="men_visible"></td>
                        </tr>
                        <tr>
                            <td>Men_fecha: </td>
                            <td id="men_fecha"></td>
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