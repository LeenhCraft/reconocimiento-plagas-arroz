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
