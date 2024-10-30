let tb;
$(document).ready(function () {
  tb = $("#tb").dataTable({
    // sProcessing: true,
    // bServerSide: true,
    language: {
      url: base_url + "js/dataTable.Spanish.json",
    },
    ajax: {
      url: base_url + "admin/usuarios",
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
      { data: "user" },
      { data: "rol" },
      {
        data: null,
        width: "10%",
        render: function (data, type, row) {
          const activo = data.activo
            ? `<i class='bx bxs-check-circle text-success me-2'></i>Activo`
            : `<i class='bx bxs-x-circle text-danger me-2'></i>Inactivo`;

          const estado = data.estado
            ? `<i class='bx bxs-check-circle text-success me-2'></i>Habilitado`
            : `<i class='bx bxs-x-circle text-danger me-2'></i>Bloqueado`;
          return `${activo} <br> ${estado}`;
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

function listRoles() {
  let ajaxUrl = base_url + "admin/usuarios/roles";
  $.post(ajaxUrl, function () {})
    .done(function (data) {
      if (data.status) {
        $("#idrol").empty();
        $("#idrol").append(
          "<option value='' checked>Seleccione una opción</option>"
        );
        $.each(data.data, function (index, value) {
          $("#idrol").append(
            "<option value=" + value.id + ">" + value.nombre + "</option>"
          );
        });
      }
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
  $("#idrol").select2({
    width: "100%",
    placeholder: "Seleccione una opción",
    dropdownParent: $("#idrol").parent(),
  });
}

function listPersonas() {
  let ajaxUrl = base_url + "admin/usuarios/person";
  $.post(ajaxUrl, function () {})
    .done(function (data) {
      if (data.status) {
        $("#idpersona").empty();
        $.each(data.data, function (index, value) {
          $("#idpersona").append(
            "<option value=" + value.id + ">" + value.nombre + "</option>"
          );
        });
      }
    })
    .fail(function () {
      Toast.fire({
        icon: "error",
        title: "error: " + errorThrown,
      });
      console.log(jqXHR, textStatus, errorThrown);
    })
    .always(function () {
      divLoading.css("display", "none");
    });
  $("#idpersona").select2({
    width: "100%",
    placeholder: "Seleccione una opción",
    dropdownParent: $("#idpersona").parent(),
  });
}

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
//
$("#btnNuevo").on("click", function () {
  resetForm();
  $("#modalFormUsuario").modal("show");
});

$("#btnRecargar").on("click", function () {
  tb.api().ajax.reload();
});

$("#user_form").submit(function (e) {
  e.preventDefault();
  divLoading.css("display", "flex");
  let formData = $("#user_form").serialize();
  $.post(base_url + "admin/usuarios/save", formData, function () {})
    .done(function (response) {
      if (response.status) {
        tb.api().ajax.reload();
        // resetForm();
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

function resetForm() {
  $("#user_form").trigger("reset");
  $(".title-new-modal span").text("Nuevo Usuario");
  $("#id").val("");
  listRoles();
  listPersonas();
}

function funEditar(id) {
  resetForm();
  divLoading.css("display", "flex");
  let ajaxUrl = base_url + "admin/usuarios/search";
  $.post(ajaxUrl, { id }, function () {})
    .done(function (response) {
      $("#id").val(response.data.idusuario);
      $(".title-new-modal span").text(
        "Editar Usuario : " + response.data.usu_usuario
      );
      $("#user").val(response.data.usu_usuario);
      $("#status").val(response.data.usu_estado);
      $("#idrol").val(response.data.idrol).trigger("change");
      $("#idpersona").val(response.data.idpersona).trigger("change");
      $("#modalFormUsuario").modal("show");
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
      let ajaxUrl = base_url + "admin/usuarios/delete";
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
          console.log(jqXHR);
          console.log(textStatus);
          console.log(errorThrown);
        })
        .always(function () {
          divLoading.css("display", "none");
        });
    }
  });
}
