$("#entrenarModelo").click(function (e) {
  e.preventDefault();
  let data = new FormData();
  data.append("entrenarModelo", true);
  data.append("uuid", $("#uuid").val());

  // Confirmar antes de enviar
  Swal.fire({
    title: "¿Estás seguro?",
    text: "Entrenar un nuevo modelo puede tardar de 20 minutos a 1 hora.",
    icon: "question",
    showCancelButton: true,
    confirmButtonText: "Sí, entrenar",
    cancelButtonText: "No, cancelar",
  }).then((result) => {
    if (result.isConfirmed) {
      // Mostrar loading
      divLoading.css("display", "flex");

      // Enviar datos mediante Ajax
      $.ajax({
        url: base_url + "admin/entrenar",
        type: "POST",
        data: data,
        processData: false,
        contentType: false,
        success: function (response) {
          // Mostrar mensaje de éxito
          Swal.fire({
            icon: response.status ? "success" : "error",
            title: response.status ? "¡Éxito!" : "Error",
            text: response.message,
          });
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
          new Audio(base_url + "notificacion.mp3").play();
        },
        complete: function () {
          // Ocultar loading
          divLoading.css("display", "none");
          // reproducir sonido de notificación
          new Audio(base_url + "notificacion.mp3").play();
          // actualizamos la tabla
          tb.api().ajax.reload();
        },
      });
    }
  });
});

$("#config_train").submit(function (e) {
  e.preventDefault();
  // enviar formulario mediante ajax al endpoint /admin/entrenameinto/config
  let data = new FormData(this);
  // Mostrar loading
  divLoading.css("display", "flex");
  $.ajax({
    url: base_url + "admin/entrenar/configurar",
    type: "POST",
    data: data,
    processData: false,
    contentType: false,
    success: function (response) {
      // Mostrar mensaje de éxito
      Swal.fire({
        icon: response.status ? "success" : "error",
        title: response.status ? "¡Éxito!" : "Error",
        text: response.message,
      });
    },
    error: function (error) {
      // Mostrar mensaje de error
      Swal.fire({
        icon: "error",
        title: "Error",
        text:
          error.responseJSON?.message ||
          "Ocurrió un error al guardar la configuración",
      });
      console.error("Error:", error);
      new Audio(base_url + "notificacion.mp3").play();
    },
    complete: function () {
      // Ocultar loading
      divLoading.css("display", "none");
    },
  });
});

let tb;
$(document).ready(function () {
  tb = $("#tb").dataTable({
    // sProcessing: true,
    // bServerSide: true,
    language: {
      url: base_url + "js/dataTable.Spanish.json",
    },
    ajax: {
      url: base_url + "admin/entrenar/list",
      method: "get",
      dataSrc: "",
    },
    columns: [
      {
        data: null,
        width: "5%",
        className: "text-center p-0",
        render: function (data, type, row, meta) {
          return row.def == 1
            ? `<i class='bx bxs-check-circle text-success'></i>`
            : ``;
        },
      },
      {
        data: null,
        width: "30%",
        className: "px-0",
        render: function (data, type, row, meta) {
          return `<p class="m-0 p-0 fs-6 text-dark fw-normal">${row.modelo}</p>
              <p class="m-0 p-0 fs-5 text-primary fw-bold">${row.nombre}</p>
              <p class="m-0 p-0 fs-7 text-secondary fw-normal">${row.tiempo}</p>
          `;
        },
      },
      {
        data: null,
        width: "15%",
        className: "text-center",
        render: function (data, type, row, meta) {
          // agregar deci
          return `
          <p class="m-0 p-0 text-center text-black fw-bold">${row.preci} %</p>
          <div class="progress">
            <div class="progress-bar bg-primary" role="progressbar" style="width: ${row.preci}%;" aria-valuenow="${row.preci}" aria-valuemin="0" aria-valuemax="100">
            </div>
          </div>
          `;
        },
      },
      {
        data: null,
        className: "text-center",
        render: function (data, type, row, meta) {
          // Verificar si existe fecha y no es nula
          if (!row.fecha) return "";
          try {
            const date = new Date(row.fecha);
            // Formatear la fecha como YYYY/MM/DD
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, "0");
            const day = String(date.getDate()).padStart(2, "0");

            return `<i class='bx bx-calendar bx-xs text-primary'></i> ${day}/${month}/${year}`;
          } catch (e) {
            return `<i class='bx bx-calendar bx-xs text-primary'></i>`;
          }
        },
      },
      {
        data: null,
        className: "px-2",
        render: function (data, type, row, meta) {
          let classBtn = "btn-secondary";
          const btnDel = `<button type="button" class="btn btn-sm btn-outline-danger rounded-3 py-0 px-2" onclick="eliminarModelo('${row.id}')">
                <i class='bx bx-trash-alt bx-xs'></i>
            </button>`;
          if (row.def == 1) {
            classBtn = "btn-primary";
          } else {
            classBtn = "btn-outline-primary";
          }

          let btn = `<button 
            type="button" 
            class="btn btn-sm ${classBtn} rounded-3 py-0 px-1"
            onclick="activarModelo(${row.id})">
              <i class='bx bx-play bx-sm'></i>
          </button>`;

          return `
          <div class="d-flex gap-2">
            ${btn}
            ${btnDel}            
          </div>
          `;
        },
      },
    ],
    bDestroy: true,
    info: false,
    displayLength: 10,
    lengthChange: false,
    searching: false,
    lengthMenu: [7, 10, 25, 50, 75, 100],
    scrollX: true,
    order: [],
  });
});

function activarModelo(id) {
  // Mostrar loading
  divLoading.css("display", "flex");

  $.ajax({
    url: base_url + "admin/entrenar/activar",
    type: "POST",
    data: { id },
    success: function (response) {
      // Mostrar mensaje de éxito
      Swal.fire({
        icon: response.status ? "success" : "error",
        title: response.status ? "¡Éxito!" : "Error",
        text: response.message,
      });
    },
    error: function (error) {
      // Mostrar mensaje de error
      Swal.fire({
        icon: "error",
        title: "Error",
        text:
          error.responseJSON?.message ||
          "Ocurrió un error al activar el modelo",
      });
      console.error("Error:", error);
    },
    complete: function () {
      // Ocultar loading
      divLoading.css("display", "none");
      // reproducir sonido de notificación
      new Audio(base_url + "notificacion.mp3").play();
      // actualizamos la tabla
      tb.api().ajax.reload();
    },
  });
}
