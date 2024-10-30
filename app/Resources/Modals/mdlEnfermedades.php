<div class="modal fade" id="mdlEspecies" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" style="display: none;" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title mb-2">
                    <i class='bx bxs-bug-alt text-danger'></i>
                    <i class='bx bx-bug-alt text-success'></i>
                    <span class="text-dark fw-bold">
                        Registrar Nueva Plaga o Enfermedad
                    </span>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="nav-align-top">
                    <ul class="nav nav-tabs" role="tablist">
                        <li class="nav-item">
                            <button type="button" class="nav-link active" role="tab" data-bs-toggle="tab" data-bs-target="#navs-uno" aria-controls="navs-uno" aria-selected="true">
                                General
                            </button>
                        </li>
                        <li class="nav-item">
                            <button type="button" class="nav-link" role="tab" data-bs-toggle="tab" data-bs-target="#navs-dos" aria-controls="navs-dos" aria-selected="false">
                                Imagen
                            </button>
                        </li>
                        <li class="nav-item">
                            <button type="button" class="nav-link" role="tab" data-bs-toggle="tab" data-bs-target="#navs-tres" aria-controls="navs-tres" aria-selected="false">
                                Información
                            </button>
                        </li>
                    </ul>
                    <form id="form" enctype="multipart/form-data">
                        <div class="tab-content p-0">
                            <div class="tab-pane pt-4 active show" id="navs-uno" role="tabpanel">
                                <input type="hidden" id="id" name="id">
                                <div class="col-12 col-md-6">
                                    <label for="nombre" class="text-dark fw-semibold">Nombre Comun <span class="fw-bold text-danger">*</span></label>
                                    <input type="text" class="form-control" id="nombre" name="nombre">
                                </div>
                            </div>
                            <div class="tab-pane pt-4 fade" id="navs-dos" role="tabpanel">
                                <div class="w-100 container-img">
                                    <input type="file"
                                        name="es_imagen_url"
                                        id="es_imagen_url"
                                        class="file"
                                        accept="image/*">
                                    <div class="dz-message fw-bold needsclick text-center">
                                        Haga click aqui para cargar una imagen
                                        <br>
                                        <span class="note needsclick">(Esta imagen es la <strong>referencia</strong> para la especie.)</span>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="navs-tres" role="tabpanel">
                                <div class="row">
                                    <div class="col-12">
                                        <div id="description">
                                            leenhcraft.com
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="my-4">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa-solid fa-shield-halved me-2" aria-hidden="true"></i>
                                    Guardar
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>