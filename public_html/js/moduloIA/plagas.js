var view = $(".dz-message");
var html = view.html();
var dataEspecies = "";
$(document).ready(function () {
  loadCards();
  // evento clik del boton con clase recargar-esepcies
  $(".recargar-esepcies").click(function () {
    loadCards(true);
  });
});

function loadCards(
  pedirDatos = false,
  params = { sort: "es_nombre_cientifico", order: "asc" }
) {
  // capturar el parametro page de la url y loa agrego a params
  let url = new URL(window.location.href);
  let page = url.searchParams.get("page");
  let limit = url.searchParams.get("limit");
  params.page = page != null ? page : 1;
  params.limit = limit != null ? limit : 10;
  $(".total-especies .val").html(
    `<div class="spinner-border text-primary m-0" role="status"><span class="visually-hidden">Loading...</span></div>`
  );

  $(".content-card-butter").html(`
      <div class="col-6 col-md-2 mb-3 spinkit-content">
          <div class="card h-100" style="min-height:239px;">
              <div class="card-body h-100 d-flex flex-column justify-content-center align-items-center">
                  <div class="spinkit-ln mb-3">
                      <div class="sk-chase sk-primary">
                          <div class="sk-chase-dot"></div>
                          <div class="sk-chase-dot"></div>
                          <div class="sk-chase-dot"></div>
                          <div class="sk-chase-dot"></div>
                          <div class="sk-chase-dot"></div>
                          <div class="sk-chase-dot"></div>
                      </div>
                  </div>
                  <h5>Cargando</h5>
              </div>
          </div>
      </div>
      `);
  let cards = ``;
  if (typeof modal !== "undefined") {
    cards = `<div class="col-6 col-md-2 mb-3">
          <div class="card h-100" style="min-height:239px;">
              <a href="#" class="h-100" onclick="openModal()">
                  <div class="card-body h-100">
                      <div class="d-flex h-100 justity-content-center align-items-center text-center">
                          <div class="w-100">
                              <i class='bx bxs-plus-circle bx-lg mb-4'></i>
                              <h5>Agregar Nueva Especie</h5>
                          </div>
                      </div>
                  </div>
              </a>
          </div>
      </div>`;
  }
  if (pedirDatos == true) {
    $.ajax({
      type: "POST",
      url: base_url + "admin/especies",
      data: params,
      dataType: "json",
      success: function (data) {
        arrEspecies = data;
        loadCards(false);
      },
    });
  }
  if (arrEspecies.data.length > 0) {
    // dataEspecies = data.data;
    $.each(arrEspecies.data, function (index, value) {
      // paginacion
      let pagination = $(".pagination");
      pagination.empty();
      let prevLink = arrEspecies.prev_page_url
        ? `<a class="page-link" href="${arrEspecies.prev_page_url}">Anterior</a>`
        : `<a class="page-link disabled" href="#">Anterior</a>`;
      let nextLink = arrEspecies.next_page_url
        ? `<a class="page-link" href="${arrEspecies.next_page_url}">Siguiente</a>`
        : `<a class="page-link disabled" href="#">Siguiente</a>`;
      let pageLinks = "";
      for (let i = 1; i <= arrEspecies.last_page; i++) {
        let pageLink = `<a class="page-link" href="/admin/plagas?page=${i}&perpage=${arrEspecies.per_page}">${i}</a>`;
        let listItem = `<li class="page-item">${pageLink}</li>`;

        // Marcar la página actual como activa
        if (i === Number(arrEspecies.current_page)) {
          listItem = `<li class="page-item active">${pageLink}</li>`;
        }

        pageLinks += listItem;
      }
      let html = [
        `<li class="page-item">${prevLink}</li>`,
        pageLinks,
        `<li class="page-item">${nextLink}</li>`,
      ];

      // agregar el active a la pagina actual
      $(
        '.dropdown-menu a[href="?perpage=' + arrEspecies.per_page + '"]'
      ).addClass("active");

      pagination.html(html.reduce((acc, curr) => acc + curr, ""));

      url = base_url + "img/default.png";
      if (value.imagen_url != "" && value.imagen_url != null) {
        url = base_url + value.imagen_url;
      }
      cards += `<div class="col-6 col-md-2 mb-3">
        <div class="card h-100 overflow-hidden" style="max-height:239px;">
        <a class="text-center" href="${base_url}admin/plagas/${value.slug}">
            <div class="text-center">
            <img 
                class="w-100 butter-card-img" 
                src="${url}" 
                alt="${value.nombre}"
            >
            </div>
            <div class="card-body">
            <h5 
                class="card-title text-truncate" 
                title="${value.nombre}"
            >
                ${value.nombre}
            </h5>
            </div>
        </a>
        </div>
    </div>`;
    });
    cards += `<hr>`;
    // divLoading.css("display", "none");
  }
  $(".total-especies .val")
    .html(`<h2 class="m-0 p-0 text-dark fw-bold">${arrEspecies.total}</h2>`)
    .fadeIn("slow");
  $(".content-card-butter").html(cards);
}
