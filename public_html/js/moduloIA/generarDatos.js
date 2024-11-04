// Manejador simple del formulario
$("#form").submit(function (e) {
  e.preventDefault();

  // Confirmar antes de enviar
  Swal.fire({
    title: "¿Estás seguro?",
    text: "¿Deseas enviar este formulario?",
    icon: "question",
    showCancelButton: true,
    confirmButtonText: "Sí, enviar",
    cancelButtonText: "No, cancelar",
  }).then((result) => {
    if (result.isConfirmed) {
      // Mostrar loading
      divLoading.css("display", "flex");

      // Preparar datos del formulario
      let formData = new FormData(this);

      // Enviar datos mediante Ajax
      $.ajax({
        url: base_url + "admin/datos",
        type: "POST",
        data: formData,
        processData: false,
        contentType: false,
        success: function (response) {
          // Mostrar mensaje de éxito
          Swal.fire({
            icon: "success",
            title: "¡Éxito!",
            text: response.message || "Datos guardados correctamente",
          });

          // Opcional: resetear formulario o redireccionar
          // $("#form")[0].reset();
          // window.location.reload();
        },
        error: function (error) {
          // Mostrar mensaje de error
          Swal.fire({
            icon: "error",
            title: "Error",
            text:
              error.responseJSON?.message ||
              "Ocurrió un error al guardar los datos",
          });
          console.error("Error:", error);
        },
        complete: function () {
          // Ocultar loading
          divLoading.css("display", "none");
        },
      });
    }
  });
});

$("#generarDatos").click(function (e) {
  e.preventDefault();
  let data = new FormData();
  data.append("generarDatos", true);
  data.append("uuid", $("#uuid").val());

  // Confirmar antes de enviar
  Swal.fire({
    title: "¿Estás seguro?",
    text: "¿Deseas generar los datos?",
    icon: "question",
    showCancelButton: true,
    confirmButtonText: "Sí, generar",
    cancelButtonText: "No, cancelar",
  }).then((result) => {
    if (result.isConfirmed) {
      // Mostrar loading
      divLoading.css("display", "flex");

      // Enviar datos mediante Ajax
      $.ajax({
        url: base_url + "admin/datos/generar",
        type: "POST",
        data: data,
        processData: false,
        contentType: false,
        success: function (response) {
          console.log(response);

          // Mostrar mensaje de éxito
          Swal.fire({
            icon: response.success ? "success" : "error",
            title: response.success ? "¡Éxito!" : "Error",
            text: response.message || "Datos generados correctamente",
          });

          loadAndRenderRecords();
        },
        error: function (error) {
          // Mostrar mensaje de error
          Swal.fire({
            icon: "error",
            title: "Error",
            text:
              error.responseJSON?.message ||
              "Ocurrió un error al generar los datos",
          });
          console.error("Error:", error);
        },
        complete: function () {
          // Ocultar loading
          divLoading.css("display", "none");
        },
      });
    }
  });
});

// Función para obtener todos los registros
async function fetchTrainingRecords() {
  try {
    const response = await fetch("/admin/datos/list", {
      method: "GET",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
    });

    // Si la respuesta no es ok, lanzar error
    if (!response.ok) {
      throw new Error(`Error HTTP: ${response.status}`);
    }

    // Parsear la respuesta a JSON
    const data = await response.json();

    return {
      success: true,
      data: data,
      error: null,
    };
  } catch (error) {
    console.error("Error al obtener los registros:", error);

    return {
      success: false,
      data: null,
      error: error.message || "Error al obtener los registros",
    };
  }
}

// Función para formatear la fecha
function formatDate(dateString) {
  const date = new Date(dateString);
  return date.toLocaleDateString("es-ES", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

// Función auxiliar para verificar y obtener datos de manera segura
function safeGetData(record) {
  record.stats = JSON.parse(record.stats);
  record.summary = JSON.parse(record.summary);
  record.yaml = JSON.parse(record.yaml);

  // Verificamos la estructura del objeto y proporcionamos valores por defecto
  return {
    total_images: record?.stats?.total_images || 0,
    train_total: record?.stats?.train?.total || 0,
    val_total: record?.stats?.val?.total || 0,
    success_rate: record?.summary?.processing_success_rate || 0,
    images_by_class: record?.stats?.images_by_class || {},
  };
}

// Función para crear el HTML de un registro individual
function createRecordHTML(record) {
  // Obtenemos los datos de manera segura
  const data = safeGetData(record);

  // Extraer los primeros 3 elementos para preview
  let previewClassesHTML = "";
  try {
    const classEntries = Object.entries(data.images_by_class);
    const previewClasses = classEntries.slice(0, 3);
    const remainingClasses = Math.max(0, classEntries.length - 3);

    previewClassesHTML = `
          ${previewClasses
            .map(
              ([name, count]) => `
              <div class="class-pill">${name} (${count})</div>
          `
            )
            .join("")}
          ${
            remainingClasses > 0
              ? `<div class="class-pill">+${remainingClasses} más</div>`
              : ""
          }
      `;
  } catch (error) {
    console.error("Error al procesar las clases:", error);
    previewClassesHTML = '<div class="class-pill">Error al cargar clases</div>';
  }

  return `
      <div class="col-12 card card-compac p-3 cursor-pointer mb-4">
          <div class="d-flex justify-content-between align-items-center mb-2">
              <span class="text-dark fw-bold fs-7">${formatDate(
                record.fecha_registro
              )}</span>
              <span class="bg-white text-success py-1 px-2 fw-semibold fs-6">
                  <i class="fas fa-check-circle me-1"></i>
                  ${data.success_rate}%
              </span>
          </div>
          <div class="d-flex gap-4 align-items-center flex-wrap">
              <div class="d-flex align-items-center gap-2">
                  <i class="fas fa-images me-1" style="color: #3b82f6;"></i>
                  <span class="fs-7 text-black">Total:</span>
                  <span class="fs-7 text-dark fw-bold">${
                    data.total_images
                  }</span>
              </div>

              <span class="text-light">|</span>

              <div class="d-flex align-items-center gap-2">
                  <i class="fas fa-brain me-1" style="color: #8b5cf6;"></i>
                  <span class="fs-7 text-black">Train:</span>
                  <span class="fs-7 text-dark fw-bold">${
                    data.train_total
                  }</span>
              </div>

              <span class="text-light">|</span>

              <div class="d-flex align-items-center gap-2">
                  <i class="fas fa-check-double me-1" style="color: #10b981;"></i>
                  <span class="fs-7 text-black">Val:</span>
                  <span class="fs-7 text-dark fw-bold">${data.val_total}</span>
              </div>
          </div>

          <div class="d-flex gap-3 mt-2">
              ${previewClassesHTML}
              <i class="fas fa-chevron-right ms-auto text-gray"></i>
          </div>
      </div>
  `;
}

// Función para mostrar el estado de carga
function showLoading() {
  const container = document.getElementById("compac-container");
  container.innerHTML = `
      <div class="col-12 text-center p-4">
          <i class="fas fa-circle-notch fa-spin me-2"></i>
          Cargando registros...
      </div>
  `;
}

// Función para mostrar error
function showError(message) {
  const container = document.getElementById("compac-container");
  container.innerHTML = `
      <div class="col-12">
          <div class="alert alert-danger" role="alert">
              <i class="fas fa-exclamation-triangle me-2"></i>
              ${message}
          </div>
      </div>
  `;
}

// Función para renderizar los registros
function renderRecords(records) {
  const container = document.getElementById("compac-container");

  if (!records || records.length === 0) {
    container.innerHTML = `
          <div class="col-12 text-center p-4 text-muted">
              No hay registros disponibles
          </div>
      `;
    return;
  }

  container.innerHTML = records
    .map((record) => createRecordHTML(record))
    .join("");

  // Agregar eventos click a las cards
  document.querySelectorAll(".card-compac").forEach((card, index) => {
    card.addEventListener("click", () => {
      console.log("Registro seleccionado:", records[index]);
      // Aquí puedes agregar la lógica para mostrar más detalles
      Toast.fire({
        icon: "info",
        title: "Registro seleccionado: " + records[index].code,
      });
    });
  });
}

// Función principal que obtiene y renderiza los datos
async function loadAndRenderRecords() {
  showLoading();

  const result = await fetchTrainingRecords();

  if (result.success) {
    renderRecords(result.data);
  } else {
    showError(result.error || "Error al cargar los registros");
  }
}

// Iniciar la carga de datos
document.addEventListener("DOMContentLoaded", loadAndRenderRecords);

// Opcional: Agregar función de recarga
function addReloadButton() {
  const reloadButton = document.createElement("button");
  reloadButton.type = "button";
  reloadButton.className = "btn btn-outline-info mb-3";
  reloadButton.innerHTML = '<i class="fas fa-sync-alt me-2"></i>Actualizar';
  reloadButton.onclick = loadAndRenderRecords;

  const container = document.getElementById("compac-container");
  container.parentNode.insertBefore(reloadButton, container);
}

// Descomentar si deseas agregar el botón de recarga
document.addEventListener("DOMContentLoaded", addReloadButton);
