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
  params = { sort: "nombre", order: "asc" }
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
      url: base_url + "admin/plagas",
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

const searchInput = document.getElementById("search-input");
let timeoutId;

function handleSearch(event) {
  const searchTerm = event.target.value.toLowerCase().trim();

  // Mostrar loading
  showLoading();

  // Debounce la búsqueda
  clearTimeout(timeoutId);
  timeoutId = setTimeout(() => {
    const filteredResults = !searchTerm
      ? arrEspecies.data
      : searchItems(arrEspecies.data, searchTerm);

    renderResults(filteredResults);
  }, 300);
}

function searchItems(items, searchTerm) {
  // Dividir términos de búsqueda y normalizar
  const searchTerms = normalizeText(searchTerm)
    .split(" ")
    .filter((term) => term.length > 0);

  return items
    .filter((item) => {
      const normalizedNombre = normalizeText(item.nombre || "");
      const normalizedCientifico = normalizeText(item.nombre_cientifico || "");

      // Si hay múltiples términos, todos deben coincidir
      return searchTerms.every((term) => {
        // Búsqueda exacta
        if (
          normalizedNombre.includes(term) ||
          normalizedCientifico.includes(term)
        ) {
          return true;
        }

        // Búsqueda con tolerancia a errores
        if (
          findSimilarText(normalizedNombre, term) ||
          findSimilarText(normalizedCientifico, term)
        ) {
          return true;
        }

        return false;
      });
    })
    .sort((a, b) => {
      // Ordenar por relevancia
      const scoreA = getSearchScore(a, searchTerm);
      const scoreB = getSearchScore(b, searchTerm);
      return scoreB - scoreA;
    });
}

function normalizeText(text) {
  return text
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "") // Eliminar acentos
    .replace(/[^\w\s]/g, ""); // Eliminar caracteres especiales
}

function findSimilarText(text, term) {
  // Si el término es muy corto, buscar coincidencia exacta
  if (term.length < 3) return text.includes(term);

  const words = text.split(" ");
  return words.some((word) => {
    // Para palabras cortas, coincidencia exacta
    if (word.length < 3) return word === term;

    // Calcular distancia de Levenshtein
    const distance = levenshteinDistance(word, term);
    // Permitir más diferencias para palabras más largas
    const maxDistance = Math.floor(term.length / 3);
    return distance <= maxDistance;
  });
}

function getSearchScore(item, searchTerm) {
  const normalizedTerm = normalizeText(searchTerm);
  const normalizedNombre = normalizeText(item.nombre || "");
  const normalizedCientifico = normalizeText(item.nombre_cientifico || "");

  let score = 0;

  // Coincidencia exacta
  if (normalizedNombre === normalizedTerm) score += 100;
  if (normalizedCientifico === normalizedTerm) score += 100;

  // Coincidencia al inicio
  if (normalizedNombre.startsWith(normalizedTerm)) score += 50;
  if (normalizedCientifico.startsWith(normalizedTerm)) score += 50;

  // Coincidencia parcial
  if (normalizedNombre.includes(normalizedTerm)) score += 25;
  if (normalizedCientifico.includes(normalizedTerm)) score += 25;

  return score;
}

function levenshteinDistance(a, b) {
  const matrix = [];
  for (let i = 0; i <= b.length; i++) {
    matrix[i] = [i];
  }
  for (let j = 0; j <= a.length; j++) {
    matrix[0][j] = j;
  }

  for (let i = 1; i <= b.length; i++) {
    for (let j = 1; j <= a.length; j++) {
      if (b.charAt(i - 1) === a.charAt(j - 1)) {
        matrix[i][j] = matrix[i - 1][j - 1];
      } else {
        matrix[i][j] = Math.min(
          matrix[i - 1][j - 1] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j] + 1
        );
      }
    }
  }
  return matrix[b.length][a.length];
}

function showLoading() {
  $(".total-especies .val").html(
    `<div class="spinner-border text-primary m-0" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>`
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
}

function renderResults(results) {
  // Actualizar contador total
  $(".total-especies .val")
    .html(`<h2 class="m-0 p-0 text-dark fw-bold">${results.length}</h2>`)
    .fadeIn("slow");

  // Generar las cards
  let cards =
    typeof modal !== "undefined"
      ? `<div class="col-6 col-md-2 mb-3">
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
        </div>`
      : "";

  if (!results.length) {
    cards += `
            <div class="col-6 col-md-2 mb-3">
                <div class="card">
                    <div class="card-body text-center">
                        <h5 class="text-muted">No se encontraron resultados</h5>
                    </div>
                </div>
            </div>
        `;
  } else {
    results.forEach((value) => {
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
  }

  $(".content-card-butter").html(cards);
}

// Event listeners
searchInput.addEventListener("input", handleSearch);
