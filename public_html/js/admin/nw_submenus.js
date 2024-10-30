let tb;
$(document).ready(function () {
  tb = $("#sis_submenus").dataTable({
    // sProcessing: true,
    // bServerSide: true,
    language: {
      url: base_url + "js/dataTable.Spanish.json",
    },
    ajax: {
      url: base_url + "admin/submenus",
      method: "POST",
      dataSrc: "",
    },
    columns: [
      {
        data: null,
        render: function (data, type, row, meta) {
          return meta.row + 1;
        },
      },
      { data: "submenu", class: "font-weight-bold" },
      { data: "menu" },
      { data: "url", class: "text-left" },
      { data: "orden", class: "text-center" },
      {
        data: null,
        className: "px-2",
        render: function (data, type, row, meta) {
          return generateDropdownMenu(data);
        },
      },
    ],
    bDestroy: true,
    displayLength: 10,
    lengthMenu: [7, 10, 25, 50, 75, 100],
  });
});

function fntView(id) {
  let ajaxUrl = base_url + "admin/submenus/search";
  $.post(ajaxUrl, { id: id }, function (data) {
    $("#idsubmenu").html(data.data.idsubmenu);
    $("#idmenuu").html(data.data.idmenu);
    $("#sub_nombre").html(data.data.sub_nombre);
    $("#sub_url").html(data.data.sub_url);
    $("#sub_controlador").html(data.data.sub_controlador);
    $("#sub_icono").html(data.data.sub_icono);
    $("#sub_orden").html(data.data.sub_orden);
    $("#sub_visible").html(data.data.sub_visible);
    $("#sub_fecha").html(data.data.sub_fecha);
    $("#mdView").modal("show");
  });
}

function fntEdit(id) {
  divLoading.css("display", "flex");
  lstMenus();
  resetForm();
  let ajaxUrl = base_url + "admin/submenus/search";
  $(".modal-form").text("Actualizar Sub Menu");
  $(".modal-header").removeClass("headerRegister");
  $(".modal-header").addClass("headerUpdate");
  $("#btnActionForm").removeClass("btn-primary");
  $("#btnActionForm").addClass("btn-info");
  $(".div_id").removeClass("d-none");
  $(".btnText").text("Actualizar");
  $("#submenus_form").attr("onsubmit", "return update(this,event)");
  // $("#submenus_form").attr("id", "update_form");
  $("#modalsubmenus").modal("show");
  //
  $.post(ajaxUrl, { id: id }, function () {})
    .done(function (data) {
      // console.log(data);
      if (data.status) {
        $("#id, #idv").val(data.data.idsubmenu);
        $("#idmenu").val(data.data.idmenu);
        $("#idsubmenu").val(data.data.idsubmenu);
        $("#name").val(data.data.sub_nombre);
        $("#url").val(data.data.sub_url);
        // maracar el checkbox
        if (data.data.sub_externo == 1) {
          $("#sub_externo").prop("checked", true);
        }
        $("#controller").val(data.data.sub_controlador);
        $("#icon").val(data.data.sub_icono);
        $("#order").val(data.data.sub_orden);
        $("#visible").val(data.data.sub_visible);
        $("#fecha").val(data.data.sub_fecha);
      }
      Toast.fire({
        title: data.status ? "Exito" : "Error",
        icon: data.status ? "success" : "error",
        text: data.message,
      });
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

function fntDel(idp) {
  Swal.fire({
    title: "Eliminar submenus",
    text: "¿Realmente quiere eliminar submenus?",
    icon: "warning",
    showCancelButton: true,
    confirmButtonColor: "#3085d6",
    cancelButtonColor: "#d33",
    confirmButtonText: "Si, eliminar!",
    cancelButtonText: "No, cancelar!",
  }).then((result) => {
    if (result.isConfirmed) {
      let ajaxUrl = base_url + "admin/submenus/delete";
      $.post(ajaxUrl, { id: idp }, function (data) {
        if (data.status) {
          Swal.fire({
            title: "Eliminado!",
            text: data.message,
            icon: "success",
            confirmButtonText: "ok",
          });
          tb.DataTable().ajax.reload();
        } else {
          Swal.fire({
            title: "Error",
            text: data.message,
            icon: "error",
            confirmButtonColor: "#007065",
            confirmButtonText: "ok",
          });
        }
      });
    }
  });
}

function openModal() {
  lstMenus();
  resetForm();
  $("#modalsubmenus").modal("show");
}

function lstMenus() {
  let ajaxUrl = base_url + "admin/submenus/menus";
  $.post(ajaxUrl, function () {})
    .done(function (data) {
      if (data.status) {
        $("#idmenu").empty();
        $.each(data.data, function (index, value) {
          $("#idmenu").append(
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
    .always(function (data) {});
}

function update(ths, e) {
  let sub_nombre = $("#name").val();
  let sub_url = $("#url").val();
  let sub_controlador = $("#controller").val();
  let form = $(ths).serialize();
  // console.log(form);
  if (sub_nombre == "") {
    Swal.fire("Atención", "Es necesario un nombre para el submenu.", "warning");
    return false;
  }
  if (sub_url == "") {
    Swal.fire("Atención", "Es necesario una url para el submenu.", "warning");
    return false;
  }
  if (sub_controlador == "") {
    Swal.fire(
      "Atención",
      "Es necesario el controlador para el submenu.",
      "warning"
    );
    return false;
  }
  divLoading.css("display", "flex");
  let ajaxUrl = base_url + "admin/submenus/update";
  $.post(ajaxUrl, form, function (data) {
    if (data.status) {
      $("#modalsubmenus").modal("hide");
      Swal.fire("submenus", data.message, "success");
      tb.api().ajax.reload();
    } else {
      Swal.fire("Error", data.message, "warning");
    }
    divLoading.css("display", "none");
  });
  return false;
}

function save(ths, e) {
  let sub_nombre = $("#name").val();
  let sub_url = $("#url").val();
  let sub_controlador = $("#controller").val();
  let form = $(ths).serialize();
  // console.log(form);
  if (sub_nombre == "") {
    Swal.fire("Atención", "Es necesario un nombre para el submenu.", "warning");
    return false;
  }
  if (sub_url == "") {
    Swal.fire("Atención", "Es necesario una url para el submenu.", "warning");
    return false;
  }
  if (sub_controlador == "") {
    Swal.fire(
      "Atención",
      "Es necesario el controlador para el submenu.",
      "warning"
    );
    return false;
  }
  divLoading.css("display", "flex");
  let ajaxUrl = base_url + "admin/submenus/save";
  $.post(ajaxUrl, form, function (data) {
    if (data.status) {
      $("#modalsubmenus").modal("hide");
      Swal.fire("submenus", data.message, "success");
      tb.api().ajax.reload();
    } else {
      Swal.fire("Error", data.message, "warning");
    }
    divLoading.css("display", "none");
  });
  return false;
}

function resetForm() {
  $(".modal-header").removeClass("headerUpdate");
  $(".modal-header").addClass("headerRegister");
  $("#btnActionForm").removeClass("btn-info");
  $("#btnActionForm").addClass("btn-primary");
  $(".btn-text").text("Guardar");
  $(".modal-form").text("Nuevo Sub Menu");
  $(".div_id").addClass("d-none");
  $("#id").val("");
  // $("#update_from").attr("id", "submenus_form");
  $("#submenus_form").attr("onsubmit", "return save(this,event)");
  $("#submenus_form").trigger("reset");
}

function generateDropdownMenu(row) {
  let options = [];
  if (row.edit) {
    options.push(
      generateDropdownOption(
        "Editar",
        "bx bx-edit-alt",
        `fntEdit(${row.idsubmenu})`
      )
    );
  }
  if (row.delete) {
    options.push(
      generateDropdownOption(
        "Eliminar",
        "bx bx-trash",
        `fntDel(${row.idsubmenu})`
      )
    );
  }
  if (!row.edit && !row.delete) {
    options.push(
      generateDropdownOption("Sin acciones", "bx bxs-info-circle", ``)
    );
  }
  let optionsString = options.join("");
  return `
        <div class="d-flex flex-row">
        <div class="dropdown">
            <button type="button" class="btn p-0 dropdown-toggle hide-arrow" data-bs-toggle="dropdown">
            <i class="bx bx-dots-vertical-rounded"></i>
            </button>
            <div class="dropdown-menu">${optionsString}</div>
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
        <a class="dropdown-item disabled" href="#"><i class="${iconClass} me-2"></i>${text}</a>
      `;
  }
}

$("#btnRecargar").on("click", function () {
  tb.api().ajax.reload();
});
