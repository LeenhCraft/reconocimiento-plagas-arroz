var view = $(".dz-message.img-edit");
var html = `Haga click aqui para cargar una imagen<br><span class="note needsclick">(Esta imagen es la <strong>referencia</strong> para la plaga o enfermedad.)</span>`;
$(document).ready(function () {
  $(".especie-edit").hide("fast");

  $.fn.modal.Constructor.prototype._initializeFocusTrap = function () {
    return {
      activate: function () {},
      deactivate: function () {},
    };
  };
  initSample();
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
  // loadCards();
  $(".btn-especie-edit").click(function () {
    divLoading.css("display", "flex");
    let ajaxUrl = base_url + "admin/plagas/search";
    let id = $("#idenfermedad").val();
    let data = new FormData();
    data.append("idenfermedad", id);
    $.ajax({
      type: "POST",
      url: ajaxUrl,
      data: data,
      processData: false,
      contentType: false,
      success: function (data) {
        console.log(data);

        if (data.status) {
          // data.data.es_imagen_url no este vacio
          if (data.data.imagen_url != "") {
            view.html(
              `<img class="card-img-top preview" src="` +
                base_url +
                data.data.imagen_url +
                `" alt="Card image cap">`
            );
          }
          $("#es_nombre_comun").val(data.data.nombre);
          CKEDITOR.instances.description.setData(data.data.descripcion);
        }
        divLoading.css("display", "none");
      },
      error: function (error) {
        divLoading.css("display", "none");
        console.log(error);
      },
      complete: function () {
        divLoading.css("display", "none");
      },
    });
    $(".especie-edit").show("slow");
    $(".especie-view").hide("fast");
  });
  $(".btn-especie-entre").click(function () {
    $(".especie-view").hide("fast");
    $(".especie-edit").hide("fast");
    $(".especie-entre").show("slow");
    // peticion ajax a /admin/especies/view enviando el valor idespcie y la prespuesta mostrando en consola
    let ajaxUrl = base_url + "admin/plagas/view";
    let id = $("#idenfermedad").val();
    let data = new FormData();
    data.append("idenfermedad", id);
    $.ajax({
      type: "POST",
      url: ajaxUrl,
      data: data,
      processData: false,
      contentType: false,
      success: function (response) {
        // Limpiar el contenedor de imágenes
        $(".viewimgentre").empty();

        switch (response.status) {
          case "success":
            // Actualizar contador de imágenes
            let count = response.data.length;
            $(".numimgentre").html(count);

            // Mostrar imágenes
            response.data.forEach((value) => {
              $(".viewimgentre").append(`
                        <div class="col-6 col-md-2 mb-3">
                            <div class="card h-100 overflow-hidden" style="max-height:239px;">
                                <div class="text-center">
                                    <img class="w-100 butter-card-img" src="${base_url}${value}" alt="Imagen de entrenamiento">
                                </div>
                                <div class="card-body text-center">
                                    <button class="btn btn-sm btn-outline-danger" onclick="return delete_img(this,'${value}')">
                                        <i class='bx bxs-trash-alt'></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    `);
            });
            break;

          case "warning":
            // Mostrar mensaje de advertencia
            $(".numimgentre").html("0");
            Toast.fire({
              icon: "warning",
              title: response.message || "No hay imágenes disponibles",
            });
            break;

          case "error":
            // Mostrar mensaje de error
            $(".numimgentre").html("0");
            Toast.fire({
              icon: "error",
              title: response.message || "Error al cargar las imágenes",
            });
            break;

          default:
            Toast.fire({
              icon: "error",
              title: "Respuesta no válida del servidor",
            });
        }
      },
      error: function (xhr, status, error) {
        $(".viewimgentre").empty();
        $(".numimgentre").html("0");

        // Intentar obtener mensaje de error del servidor
        let errorMessage = "Error al cargar las imágenes";
        try {
          let response = JSON.parse(xhr.responseText);
          errorMessage = response.message || errorMessage;
        } catch (e) {
          console.error("Error al parsear respuesta:", error);
        }

        Toast.fire({
          icon: "error",
          title: errorMessage,
        });
      },
      complete: function () {
        divLoading.css("display", "none");
      },
    });
  });
  $(".btn-especie-cancel").click(function () {
    $(".especie-view").show("slow");
    $(".especie-edit").hide("fast");
    $(".especie-entre").hide("fast");
  });
  $(".btn-especie-delete").click(function () {
    let id = $("#idenfermedad").val();
    Swal.fire({
      title: "Eliminar Plaga",
      text: "¿Realmente quiere eliminar esta plaga? este proceso eliminara las imagenes de entrenamiento tambien.",
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: "Si, eliminar!",
      cancelButtonText: "No, cancelar!",
    }).then((result) => {
      if (result.isConfirmed) {
        let ajaxUrl = base_url + "admin/plagas/delete";
        $.post(ajaxUrl, { idenfermedad: id }, function (data) {
          if (data.status) {
            Swal.fire({
              title: "Eliminado!",
              text: data.message,
              icon: "success",
              confirmButtonText: "ok",
            }).then((result) => {
              window.location.href = base_url + "admin/plagas";
            });
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
  });

  // dropzone
  Dropzone.autoDiscover = false;

  // Configurar Dropzone
  var myDropzone = new Dropzone("#myDropzone", {
    url: base_url + "admin/plagas/upload",
    paramName: "file", // Nombre del archivo en el backend
    maxFilesize: 5, // Tamaño máximo del archivo en MB
    acceptedFiles: ".jpg, .jpeg, .png", // Tipos de archivo permitidos
    maxFiles: 20, //
    thumbnailWidth: 160,
    thumbnailHeight: 160,
    // thumbnailMethod: "contain",
    parallelUploads: 20,
    // previewTemplate: previewTemplate,
    autoQueue: true,
    // previewsContainer: "#previews",
    // clickable: ".fileinput-button",
    addRemoveLinks: !0,
    init: function () {
      // success
      this.on("success", function (file, response) {
        // Callback cuando el archivo se sube exitosamente
        Toast.fire({
          icon: "success",
          position: "top",
          title: response.message,
        });
        // console.log(response);
      });
      this.on("sending", function (file, xhr, formData) {
        // Callback antes de enviar el archivo
        formData.append("idenfermedad", $("#idenfermedad").val()); // Agregar el parámetro adicional al formData
      });

      this.on("complete", function (file) {
        myDropzone.removeAllFiles(); // Limpiar el área de Dropzone
        // console.log(file);
        $(".btn-especie-entre").eq(0).trigger("click"); // Activará el evento "click" en el primer elemento
      });
    },
  });
});

function update(ths, e) {
  // let sub_nombre = $("#name").val();
  let dat = new FormData(ths);

  dat.append("idenfermedad", $("#idenfermedad").val());
  let editor = CKEDITOR.instances.description.getData();
  dat.append("description", editor);

  // if (sub_nombre == "") {
  //   Swal.fire("Atención", "Es necesario un nombre para continuar.", "warning");
  //   return false;
  // }
  divLoading.css("display", "flex");
  let ajaxUrl = base_url + "admin/plagas/update";
  $.ajax({
    type: "POST",
    url: ajaxUrl,
    data: dat,
    processData: false,
    contentType: false,
    success: function (data) {
      if (data.status) {
        Toast.fire({
          icon: "success",
          position: "top",
          title: data.message,
        });
        // recargar la pagina
        setTimeout(function () {
          location.reload();
        }, 1000);
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
  return false;
}

function btn_butter() {
  $("#eliminar_img").val(1);
  view.html(html).removeClass("m-0");
  $("#btn-butter").remove();
  $("#es_imagen_url").val("");
}

//funcion de eliminar imagen
function delete_img(ths, path) {
  Swal.fire({
    title: "Eliminar",
    text: "¿Realmente quiere eliminar la imagen?",
    icon: "warning",
    showCancelButton: true,
    confirmButtonText: "Si, eliminar!",
    cancelButtonText: "No, cancelar!",
  }).then((result) => {
    if (result.isConfirmed) {
      let ajaxUrl = base_url + "admin/plagas/destroy";
      let data = new FormData();
      data.append("ruta", path);
      $.ajax({
        type: "POST",
        url: ajaxUrl,
        data: data,
        processData: false,
        contentType: false,
        success: function (data) {
          Toast.fire({
            icon: "info",
            title: data.message,
          });
          $(".btn-especie-entre").eq(0).trigger("click"); // Activará el evento "click" en el primer elemento
        },
      });
    }
  });
  return false;
}
