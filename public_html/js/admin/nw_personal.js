let tb;
$(document).ready(function () {
  tb = $("#tb").dataTable({
    // sProcessing: true,
    // bServerSide: true,
    language: {
      url: base_url + "js/dataTable.Spanish.json",
    },
    ajax: {
      url: base_url + "admin/personas",
      method: "POST",
      dataSrc: "",
    },
    columns: [
      {
        data: null,
        width: "5%",
        render: function (data, type, row, meta) {
          return meta.row + 1;
        },
      },
      { data: "nombre" },
      { data: "email" },
      {
        render: function (data, type, row) {
          const estado =
            row.estado == 1
              ? `<i class='bx bxs-check-circle text-success me-2'></i>Habilitado`
              : `<i class='bx bxs-x-circle text-danger me-2'></i>Bloqueado`;
          return `${estado}`;
        },
      },
      {
        render: function (data, type, row) {
          return generateDropdownMenu(row);
        },
      },
    ],
    bDestroy: true,
    displayLength: 10,
    lengthMenu: [7, 10, 25, 50, 75, 100],
  });
});

function generateDropdownMenu(row) {
  const editOption = generateDropdownOption(
    "Editar",
    "bx bx-edit-alt",
    `funEditar('${row.id}')`
  );
  const deleteOption = generateDropdownOption(
    "Eliminar",
    "bx bx-trash",
    `funEliminar('${row.id}')`
  );
  const options = [editOption, deleteOption].join("");

  return `
    <div class="d-flex flex-row">
      <div class="ms-3 dropdown">
        <button type="button" class="btn p-0 dropdown-toggle hide-arrow" data-bs-toggle="dropdown">
          <i class="bx bx-dots-vertical-rounded"></i>
        </button>
        <div class="dropdown-menu">
          ${options}
        </div>
      </div>
    </div>
  `;
}

function generateDropdownOption(text, iconClass, onClickFunction) {
  if (onClickFunction) {
    return `
      <a class="dropdown-item" href="#" onclick="${onClickFunction}"><i class="${iconClass} me-2"></i>${text}</a>
    `;
  } else {
    return `
      <a class="dropdown-item disabled" href="#">${text}</a>
    `;
  }
}

$("#btnNuevo").on("click", function () {
  resetForm();
  $("#addModal").modal("show");
});

$("#btnRecargar").on("click", function () {
  tb.api().ajax.reload();
});

$("#limpiar").on("click", function () {
  resetForm();
});

$("#btnEliminarPrevisualizacionImagen").on("click", function () {
  eliminarImg();
});

$(".buscar-reniec").on("click", function () {
  Toast.fire({
    position: "top",
    icon: "warning",
    title: "Para buscar en RENIEC debe contratar el plan premium.",
  });
});

$("#person_form").submit(function (e) {
  e.preventDefault();
  divLoading.css("display", "flex");
  // capturar los datos del formulario pero incluyendo el archivo
  let formData = new FormData(document.getElementById("person_form"));
  $.ajax({
    url: base_url + "admin/personas/save",
    type: "POST",
    data: formData,
    processData: false,
    contentType: false,
  })
    .done(function (response) {
      if (response.status) {
        tb.api().ajax.reload();
        resetForm();
      }
      Swal.fire(
        response.status ? "Éxito" : "Error",
        response.message,
        response.status ? "success" : "error"
      );
    })
    .fail(function (jqXHR, textStatus, errorThrown) {
      Toast.fire({
        icon: "error",
        title: "error: " + errorThrown,
      });
      console.log(jqXHR);
      console.log(textStatus);
      console.log(errorThrown);
    })
    .always(function (response) {
      divLoading.css("display", "none");
    });
});

function funEditar(id) {
  resetForm();
  divLoading.css("display", "flex");
  let ajaxUrl = base_url + "admin/personas/search";
  $.post(ajaxUrl, { id }, function () {})
    .done(function (response) {
      $("#id").val(response.data.id);
      $("#dni").val(response.data.dni);
      $("#name").val(response.data.name);
      $("#email").val(response.data.email);
      $("#phone").val(response.data.phone);
      $("#status").val(response.data.status).trigger("change");
      $("#address").val(response.data.address);
      $(".mostrarimagen").attr("src", response.data.foto);
      $("#addModal").modal("show");
      $(".title-new-modal span").text(
        "Editar Personal : " + response.data.name
      );
    })
    .fail(function (jqXHR, textStatus, errorThrown) {
      Toast.fire({
        icon: "error",
        title: "error: " + errorThrown,
      });
      console.log(jqXHR, textStatus, errorThrown);
    })
    .always(function () {
      divLoading.css("display", "none");
    });
}

function funEliminar(id) {
  Swal.fire({
    title: "¿Está seguro de eliminar el registro?",
    text: "Esta acción no se puede deshacer!",
    icon: "warning",
    showCancelButton: true,
    confirmButtonText: "Sí, eliminar!",
    cancelButtonText: "Cancelar",
  }).then((result) => {
    if (result.isConfirmed) {
      divLoading.css("display", "flex");
      let ajaxUrl = base_url + "admin/personas/delete";
      $.post(ajaxUrl, { id }, function () {})
        .done(function (response) {
          if (response.status) {
            tb.api().ajax.reload();
          }
          Swal.fire(
            response.status ? "Éxito" : "Error",
            response.message,
            response.status ? "success" : "error"
          );
        })
        .fail(function (jqXHR, textStatus, errorThrown) {
          Toast.fire({
            icon: "error",
            title: "error: " + errorThrown,
          });
         console.log(jqXHR, textStatus, errorThrown);         
        })
        .always(function () {
          divLoading.css("display", "none");
        });
    }
  });
}

function resetForm() {
  $("#person_form").trigger("reset");
  eliminarImg();
  $("#btnEliminarPrevisualizacionImagen").val("");
  $(".title-new-modal span").text("Agregar nueva persona");
  $("#id").val("");
  $("#status").select2({
    width: "100%",
    placeholder: "Seleccione una opción",
    dropdownParent: $("#status").parent(),
  });
}

function viewImg(ths, event) {
  let fileSize = $(ths)[0].files[0].size / 1024 / 1024; // Tamaño del archivo en MB
  if (fileSize > 5) {
    Toast.fire({
      icon: "error",
      title: "El tamaño del archivo no debe superar los 5MB",
    });
    $("#photo").val("");
  } else {
    let view = $(".mostrarimagen");
    let file = $(ths)[0].files[0];
    var tmppath = URL.createObjectURL(event.target.files[0]);
    view.attr("src", tmppath);
  }
}

function eliminarImg() {
  $("#photo").val("");
  $(".mostrarimagen").attr("src", base_url + "img/default.png");
}
