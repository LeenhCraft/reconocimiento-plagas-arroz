<?php header_web('Template.HeaderDashboard', $data); ?>
<div class="card">
    <div class="card-header">
        <h5 class="fw-bold text-dark m-0 p-0">
            <i class="fa-solid fa-bug text-primary"></i>
            <i class="fa-solid fa-leaf text-success me-2"></i>
            <span>
                Plagas y enfermedades
            </span>
        </h5>
    </div>
    <div class="card-body">
        <div class="mt-4 row">
            <div class="col-12 col-lg-8">
                <div class="input-group input-group-merge rounded-pill">
                    <span class="input-group-text"><i class="bx bx-search"></i></span>
                    <input id="search-input" type="text" class="form-control" placeholder="Buscar por nombre comun o cientifico de la plaga o enfermedad">
                </div>
            </div>
        </div>
        <div class="col-12 d-flex my-4 filters">
            <div class="form-check m-0 p-0">
                <label class="form-check-label fw-bold me-3">
                    Ordenar por:
                </label>
            </div>
            <div class="form-check m-0 my-auto me-3">
                <input name="sort" class="form-check-input" type="radio" value="idespecie" id="order" checked="">
                <label class="form-check-label" for="order">
                    ID
                </label>
            </div>
            <div class="form-check m-0 my-auto me-3">
                <input name="sort" class="form-check-input" type="radio" value="es_nombre_cientifico" id="nombre_cientifico">
                <label class="form-check-label" for="nombre_cientifico">
                    Nombre Cientifico
                </label>
            </div>
            <!--  -->
            <div class="form-check m-0 p-0 my-auto">
                <label class="form-check-label fw-bold mx-4">
                    De forma:
                </label>
            </div>
            <div class="form-check m-0 my-auto me-3">
                <input name="order" class="form-check-input" type="radio" value="asc" id="asc">
                <label class="form-check-label" for="asc">
                    Asc
                </label>
            </div>
            <div class="form-check m-0 my-auto me-3">
                <input name="order" class="form-check-input" type="radio" value="desc" id="desc" checked="">
                <label class="form-check-label" for="desc">
                    Desc
                </label>
            </div>
            <!--  -->
            <div class="form-check m-0 p-0 my-auto">
                <label class="form-check-label fw-bold mx-4">
                    Ver por pagina:
                </label>
            </div>
            <div class="form-check m-0 p-0 my-auto">
                <div class="dropdown">
                    <button class="btn btn-sm btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-bs-expanded="false" aria-expanded="false">
                        Seleccione
                    </button>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="?perpage=5">5</a>
                        <a class="dropdown-item" href="?perpage=10">10</a>
                        <a class="dropdown-item" href="?perpage=15">15</a>
                        <a class="dropdown-item" href="?perpage=20">20</a>
                        <a class="dropdown-item" href="?perpage=all">Ver todas</a>
                    </div>
                </div>
            </div>
        </div>
        <hr>
        <div class="row">
            <div class="col-10">
                <h6 class="m-0 p-0 mb-3">Paginación</h6>
                <nav aria-label="Page navigation example">
                    <ul class="pagination">
                        <li class="page-item"><a class="page-link disabled" href="#">Anterior</a></li>
                        <li class="page-item"><a class="page-link disabled" href="#">Siguiente</a></li>
                    </ul>
                </nav>
            </div>
            <div class="col-2 total-especies">
                <h6 class="text-center m-0 p-0 mb-2 text-black">Total de Especies</h6>
                <div class="text-center val">
                    <h2 class="m-0 p-0 text-dark fw-bold">21</h2>
                </div>
            </div>
        </div>
    </div>
</div>
<!--  -->
<div class="row mt-4 content-card-butter">
    <div class="col-6 col-md-2 mb-3">
        <div class="card h-100" style="min-height:239px;">
            <a href="#" class="h-100" onclick="openModal()">
                <div class="card-body h-100">
                    <div class="d-flex h-100 justity-content-center align-items-center text-center">
                        <div class="w-100">
                            <i class="bx bxs-plus-circle bx-lg mb-4"></i>
                            <h5>Agregar Nueva Especie</h5>
                        </div>
                    </div>
                </div>
            </a>
        </div>
    </div>
</div>
<script>
    var arrEspecies = <?= json_encode($data["list"]) ?>;
</script>
<?php
if ($data['permisos']['perm_w'] == 1 || $data['permisos']['perm_u'] == 1)
    getModal('mdlEnfermedades', $data);
footer_web('Template.FooterDashboard', $data);
?>