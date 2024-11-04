$("#entrenarModelo").click(function (e) {
    e.preventDefault();
    let data = new FormData();
    data.append("entrenarModelo", true);
    data.append("uuid", $("#uuid").val());
  
    // Confirmar antes de enviar
    Swal.fire({
      title: "¿Estás seguro?",
      text: "¿Deseas enternar un nuevo modelo?",
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
              text: response.message || "Datos generados correctamente",
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
  