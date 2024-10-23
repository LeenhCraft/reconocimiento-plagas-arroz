let tb;
$(document).ready(function () {
  tb = $("#sis_permisos").dataTable({
    aProcessing: true,
    aServerSide: true,
    language: {
      url: base_url + "js/dataTable.Spanish.json",
    },
    ajax: {
      url: base_url + "admin/permisos",
      method: "POST",
      dataSrc: "",
    },
    columns: [
      { data: "nmr" },
      { data: "rol" },
      { data: "menu" },
      { data: "submenu" },
      { data: "r" },
      { data: "w" },
      { data: "u" },
      { data: "d" },
      { data: "options" },
    ],
    resonsieve: "true",
    bDestroy: true,
    iDisplayLength: 10,
    // order: [[0, "desc"]],
  });

  $("#permisos_form").submit(function (event) {
    event.preventDefault();
    let form = $("#permisos_form").serialize();
    divLoading.css("display", "flex");
    let ajaxUrl = base_url + "admin/permisos/save";
    $.post(ajaxUrl, form, function (data, textStatus, jqXHR) {
      divLoading.css("display", "none");
      if (data.status) {
        // $("#modalpermisos").modal("hide");
        resetForm();
        Swal.fire({
          title: "Exito",
          text: data.message,
          icon: "success",
          confirmButtonColor: "#007065",
          confirmButtonText: "ok",
        }).then((result) => {
          $("#permisos_form").trigger("reset");
          tb.api().ajax.reload();
        });
      } else {
        Swal.fire({
          title: "Advertencia",
          text: data.message,
          icon: "warning",
          confirmButtonColor: "#007065",
          confirmButtonText: "ok",
        });
      }
    });
  });
});

function fntView(id) {
  let ajaxUrl = base_url + "permisos/buscar/" + id;
  $.get(ajaxUrl, function (data) {
    let objData = JSON.parse(data);
    $("#idpermisos").html(objData.data.idpermisos);
    $("#idrol").html(objData.data.idrol);
    $("#idsubmenu").html(objData.data.idsubmenu);
    $("#perm_r").html(objData.data.perm_r);
    $("#perm_w").html(objData.data.perm_w);
    $("#perm_u").html(objData.data.perm_u);
    $("#perm_d").html(objData.data.perm_d);
    $("#mdView").modal("show");
  });
}

function fntEdit(id) {
  let ajaxUrl = base_url + "permisos/buscar/" + id;
  $("#titleModal").html("Actualizar permisos");
  $(".modal-header").removeClass("headerRegister");
  $(".modal-header").addClass("headerUpdate");
  $("#btnActionForm").removeClass("btn-primary");
  $("#btnActionForm").addClass("btn-info");
  $("#btnText").html("Actualizar");
  $("#modalpermisos").modal("show");
  //
  $.get(ajaxUrl, function (data) {
    let objData = JSON.parse(data);
    if (objData.status) {
      $("#txtIdpermisos").val(objData.data.idpermisos);
      $("#txtIdrol").val(objData.data.idrol);
      $("#txtIdsubmenu").val(objData.data.idsubmenu);
      $("#txtPerm_r").val(objData.data.perm_r);
      $("#txtPerm_w").val(objData.data.perm_w);
      $("#txtPerm_u").val(objData.data.perm_u);
      $("#txtPerm_d").val(objData.data.perm_d);
    } else {
      Swal.fire({
        title: objData.title,
        text: objData.text,
        icon: objData.icon,
        confirmButtonText: "ok",
      });
    }
  });
}

function fntDel(idp) {
  Swal.fire({
    title: "Eliminar permisos",
    text: "¿Realmente quiere eliminar permisos?",
    icon: "warning",
    showCancelButton: true,
    confirmButtonColor: "#3085d6",
    cancelButtonColor: "#d33",
    confirmButtonText: "Si, eliminar!",
    cancelButtonText: "No, cancelar!",
  }).then((result) => {
    if (result.isConfirmed) {
      let ajaxUrl = base_url + "admin/permisos/delete";
      $.post(ajaxUrl, { id: idp }, function (data) {
        if (data.status) {
          Swal.fire({
            title: "Exito",
            text: data.message,
            icon: "success",
            confirmButtonText: "ok",
          });
          tb.DataTable().ajax.reload();
        } else {
          Swal.fire({
            title: "Advertencia",
            text: data.message,
            icon: "warning",
            confirmButtonColor: "#007065",
            confirmButtonText: "ok",
          });
        }
      });
    }
  });
}

function openModal() {
  resetForm();
  $(".modal-header").removeClass("headerUpdate");
  $(".modal-header").addClass("headerRegister");
  $("#btnActionForm").removeClass("btn-info");
  $("#btnActionForm").addClass("btn-primary");
  $("#btnText").html("Guardar");
  $("#titleModal").html("Nuevo permiso");
  $("#modalpermisos").modal("show");
}

function resetForm() {
  $("#idpermiso").val("");
  lstRoles();
  lstmenus();
  $("#idsubmenu").empty();
  $("#permisos_form").trigger("reset");
}

function lstRoles() {
  let ajaxUrl = base_url + "admin/permisos/roles";
  $.post(ajaxUrl, function (data) {
    if (data.status) {
      $("#idrol").empty();
      $.each(data.data, function (index, value) {
        $("#idrol").append(
          "<option value=" + value.id + ">" + value.nombre + "</option>"
        );
      });
      $("#idrol").select2({
        width: "100%",
        placeholder: "Seleccione una opción",
        dropdownParent: $("#idrol").parent(),
      });
    }
  });
}

function lstmenus() {
  let ajaxUrl = base_url + "admin/permisos/menus";
  $.post(ajaxUrl, function (data) {
    if (data.status) {
      $("#idmenu").empty();
      $("#idmenu").append(
        '<option value="0"><span><i class="fa-solid fa-circle-notch"></i>Seleccione</span></option>'
      );
      $.each(data.data, function (index, value) {
        $("#idmenu").append(
          "<option value=" +
            value.idmenu +
            ">" +
            '<span><i class="fa-solid fa-circle-notch"></i>' +
            value.men_nombre +
            "</span>" +
            "</option>"
        );
      });
      $("#idmenu").select2({
        width: "100%",
        placeholder: "Seleccione una opción",
        dropdownParent: $("#idmenu").parent(),
      });
    }
  });
}

// function lstsubmenus() {}

function fntActv(elem, id, ac) {
  let ele = $(elem).prop("checked");
  let ajaxUrl = base_url + "admin/permisos/active";
  $.post(
    ajaxUrl,
    { id: id, ac: ac, ab: ele },
    function (data, textStatus, jqXHR) {
      if (data.status) {
        Toast.fire({
          icon: "success",
          title: data.message,
        });
      } else {
        Swal.fire({
          title: "Advertencia",
          text: data.message,
          icon: "warning",
          confirmButtonColor: "#007065",
          confirmButtonText: "ok",
        });
      }
    }
  );
}

$(document).on("change", "#idmenu", function () {
  let id = $(this).val();
  let ajaxUrl = base_url + "admin/permisos/submenus";
  $.post(ajaxUrl, { idmenu: id }, function (data) {
    if (data.status) {
      $("#idsubmenu").empty();
      $("#idsubmenu").append(
        '<option value="0"><span><i class="fa-solid fa-circle-notch"></i>Seleccione</span></option>'
      );
      $.each(data.data, function (index, value) {
        $("#idsubmenu").append(
          "<option value=" +
            value.id +
            ">" +
            '<span><i class="fa-solid fa-circle-notch"></i>' +
            value.nombre +
            "</span>" +
            "</option>"
        );
      });
      $("#idsubmenu").select2({
        width: "100%",
        placeholder: "Seleccione una opción",
        dropdownParent: $("#idsubmenu").parent(),
      });
    }
  });
});
