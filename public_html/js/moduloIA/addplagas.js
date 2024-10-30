var modal = true;
$(document).ready(function () {
  const style = document.createElement("style");
  style.textContent = ".card-img-top.preview { max-width: 200px; }";
  document.head.appendChild(style);
  initSample();
  loadCards();
  $("#es_imagen_url").change(function () {
    var inputFile = this.files[0];

    var reader = new FileReader();

    reader.onload = function (e) {
      var imageSrc = e.target.result;
      view
        .html(
          `<img class="card-img-top preview" src="` +
            imageSrc +
            `" alt="Card image cap">`
        )
        .addClass("m-0");
      // comprobar si existe el boton btn-butter
      if (!$("#btn-butter").length) {
        $("#navs-dos").append(
          `<button id="btn-butter" class="btn btn-sm btn-danger mt-3" type="button" onclick="btn_butter()">Eliminar</button>`
        );
      }
    };
    reader.readAsDataURL(inputFile);
  });
});

function openModal() {
  resetForm();
  $(".modal-title span").text("Agregar Nueva Especie");
  $("#mdlEspecies").modal("show");
}

function resetForm() {
  $("#form").trigger("reset");
  CKEDITOR.instances.description.setData("");
  btn_butter();
}

function btn_butter() {
  view.html(html).removeClass("m-0");
  $("#btn-butter").remove();
  $("#es_imagen_url").val("");
}

$("#form").submit(function (e) {
  e.preventDefault();

  let dat = new FormData(this);
  let editor = CKEDITOR.instances.description.getData();
  dat.append("description", editor);

  // Verificar si hay archivo
  let fileInput = document.getElementById("es_imagen_url");
  if (fileInput.files.length > 0) {
    console.log("Archivo seleccionado:", fileInput.files[0]);
  }

  divLoading.css("display", "flex");
  let ajaxUrl = base_url + "admin/plagas/save";

  $.ajax({
    type: "POST",
    url: ajaxUrl,
    data: dat,
    processData: false,
    contentType: false,
    success: function (data) {
      if (data.status) {
        loadCards(true);
        resetForm();
        Toast.fire({
          icon: "success",
          title: data.message,
        });
      } else {
        Swal.fire("Error", data.message, "warning");
      }
    },
    error: function (error) {
      console.log(error);
    },
    complete: function () {
      divLoading.css("display", "none");
    },
  });
});
