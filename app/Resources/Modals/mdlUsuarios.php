<!-- Modal -->
<div class="modal fade" id="modalFormUsuario" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" style="display: none;" aria-hidden="true">
    <div class="modal-dialog modal-sm">
        <form id="user_form" name="user_form" class="form-horizontal">
            <div class="modal-content">
                <div class="modal-header headerRegister">
                    <h5 class="modal-title title-new-modal text-primary">
                        <i class="fa-solid fa-user-plus me-1"></i>
                        <span>
                            Nuevo Usuario
                        </span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="id" id="id">
                    <div class="row mb-2">
                        <div class="form-group col-md-12">
                            <label for="idpersona">Personal</label>
                            <select class="form-select" name="idpersona" id="idpersona"></select>
                        </div>
                    </div>
                    <div class="row mb-2">
                        <div class="form-group col-md-12">
                            <label for="user">Usuario</label>
                            <input type="text" class="form-control" id="user" name="user">
                        </div>
                    </div>
                    <div class="row mb-2">
                        <div class="form-group col-md-12">
                            <label for="password">Contraseña</label>
                            <input type="password" class="form-control" id="password" name="password">
                        </div>
                    </div>
                    <div class="row mb-2">
                        <div class="form-group col-md-6">
                            <label for="status">Status</label>
                            <select class="form-select text-capitalizem" id="status" name="status">
                                <option value="1">Activo</option>
                                <option value="0">Inactivo</option>
                            </select>
                        </div>
                        <div class="form-group col-md-6">
                            <label for="idrol">Rol</label>
                            <select class="form-select text-capitalize" data-live-search="true" id="idrol" name="idrol">
                            </select>
                        </div>
                    </div>
                    <div class="dropdown-divider mt-4"></div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-outline-secondary fw-bold text-capitalize" type="button" data-bs-dismiss="modal">
                        <span class="text-capitalize">cerrar</span>
                    </button>
                    <button class="btn btn-primary fw-bold" id="btnActionForm" type="submit">
                        <span id="btnText">
                            <i class='bx bxs-check-shield me-1'></i>
                            <span>
                                Guardar
                            </span>
                        </span>
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="modalViewUser" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header header-primary">
                <h5 class="modal-title" id="titleModal">Datos del Usuario</h5>

            </div>
            <div class="modal-body">

                <table class="table table-bordered">
                    <tbody>
                        <tr>
                            <td>Dni: </td>
                            <td id="celIdentificacion"></td>
                        </tr>
                        <tr>
                            <td>Nombre:</td>
                            <td id="celNombre"></td>
                        </tr>
                        <tr>
                            <td>Celular:</td>
                            <td id="celTelefono"></td>
                        </tr>
                        <tr>
                            <td>Usuario:</td>
                            <td id="celUsu"></td>
                        </tr>
                        <tr>
                            <td>Estado:</td>
                            <td id="celEstado"></td>
                        </tr>
                        <tr>
                            <td>Token:</td>
                            <td id="celToken"></td>
                        </tr>
                        <tr>
                            <td>Fecha registro:</td>
                            <td id="celFecha"></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" type="button" data-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>