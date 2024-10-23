<div class="modal fade" id="addModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" style="display: none;" aria-hidden="true">
    <div class="modal-dialog modal-md">
        <form id="person_form" name="form" class="form-horizontal">
            <input type="hidden" id="id" name="id" value="">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title title-new-modal text-primary fw-semibold">
                        <i class="fa-solid fa-check-double me-fa-2x me-1"></i>
                        <span>Nuevo Rol</span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row mb-3">
                        <div class="form-group col-12 col-md-4 mt-3 mt-md-0">
                            <label for="code">Code:</label>
                            <input id="code" name="code" type="code" class="form-control" placeholder="/">
                        </div>
                        <div class="form-group col-12 col-md-8">
                            <label for="name">Nombre:</label>
                            <input id="name" name="name" type="text" class="form-control">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="form-group col-12 col-md-4">
                            <label for="status" class="text-capitalize">Estado:</label>
                            <select name="status" id="status" class="form-control">
                                <option value="1">Activo</option>
                                <option value="0">Inactivo</option>
                            </select>
                        </div>
                        <div class="form-group col-12 col-md-8">
                            <label for="description" class="text-capitalize">Descripcion:</label>
                            <input id="description" name="description" type="text" class="form-control">
                        </div>
                    </div>
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