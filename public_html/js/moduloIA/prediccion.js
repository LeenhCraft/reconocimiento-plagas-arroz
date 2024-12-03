document.addEventListener("DOMContentLoaded", function () {
  const photoInput = document.getElementById("photo");
  const form = document.querySelector("form");
  const containerImg = document.querySelector(".container-img");
  const cardResult = document.querySelector(".card-result");
  const resultImg = document.querySelector(".result-img");
  const resultName = document.querySelector(".result-name");
  const resultName2 = document.querySelector(".result-name-2");
  const resultLink = document.querySelector(".result-link");
  const resultTime = document.querySelector(".result-time");
  const submitBtn = document.querySelector('button[type="button"]');
  const downloadBtn = document.querySelector(".generate-pdf");
  const modalPDF = document.getElementById("mdlVerPDF");
  const embedPDF = document.getElementById("pdf");
  const modalTitle = document.querySelector("#mdlVerPDF .modal-title");

  // Función para previsualizar la imagen
  function previewImage(file) {
    if (file) {
      const reader = new FileReader();

      reader.onload = function (e) {
        // Crear contenedor para la imagen
        const imgContainer = document.createElement("div");
        imgContainer.className = "preview-container";

        // Crear imagen de previsualización
        const img = document.createElement("img");
        img.src = e.target.result;
        img.className = "preview-img";

        // Esperar a que la imagen cargue para manejar su tamaño
        img.onload = function () {
          const imgAspectRatio = img.naturalWidth / img.naturalHeight;
          const containerWidth = containerImg.clientWidth;
          const containerHeight = 300; // Altura fija del contenedor

          if (
            img.naturalHeight > containerHeight ||
            img.naturalWidth > containerWidth
          ) {
            if (containerWidth / containerHeight > imgAspectRatio) {
              // La altura es el factor limitante
              img.style.height = "280px"; // 20px de padding
              img.style.width = "auto";
            } else {
              // El ancho es el factor limitante
              img.style.width = containerWidth - 40 + "px"; // 20px de padding a cada lado
              img.style.height = "auto";
            }
          } else {
            // La imagen es más pequeña que el contenedor
            img.style.maxHeight = "280px";
            img.style.maxWidth = containerWidth - 40 + "px";
          }
        };

        // Limpiar contenedor y agregar nueva estructura
        containerImg.innerHTML = "";
        imgContainer.appendChild(img);
        containerImg.appendChild(imgContainer);

        // Agregar botón para eliminar
        const removeBtn = document.createElement("button");
        removeBtn.type = "button";
        removeBtn.className = "btn btn-danger remove-btn";
        removeBtn.innerHTML = '<i class="bx bx-x"></i>';
        removeBtn.onclick = resetImage;
        containerImg.appendChild(removeBtn);
      };

      reader.readAsDataURL(file);
    }
  }

  // Función para resetear la imagen
  function resetImage() {
    photoInput.value = "";
    containerImg.innerHTML = `
            <input type="file" id="photo" name="photo" class="file" accept="image/*">
            <div class="dz-message fw-bold needsclick text-center">
                Haga click aqui para cargar una imagen
                <br>
                <span class="note needsclick">(Esta imagen es la <strong>referencia</strong> para la especie.)</span>
            </div>
        `;
    cardResult.style.display = "none";
  }

  // Evento para cuando se selecciona un archivo
  photoInput.addEventListener("change", function (e) {
    const file = e.target.files[0];
    if (file) {
      if (!file.type.startsWith("image/")) {
        Swal.fire({
          icon: "error",
          title: "Error",
          text: "Por favor, seleccione un archivo de imagen válido",
        });
        resetImage();
        return;
      }

      if (file.size > 10 * 1024 * 1024) {
        Swal.fire({
          icon: "error",
          title: "Error",
          text: "La imagen no debe superar los 10MB",
        });
        resetImage();
        return;
      }

      previewImage(file);
    }
  });

  // Eventos drag & drop
  containerImg.addEventListener("dragover", function (e) {
    e.preventDefault();
    this.classList.add("dragover");
  });

  containerImg.addEventListener("dragleave", function (e) {
    e.preventDefault();
    this.classList.remove("dragover");
  });

  containerImg.addEventListener("drop", function (e) {
    e.preventDefault();
    this.classList.remove("dragover");

    const file = e.dataTransfer.files[0];
    if (file) {
      photoInput.files = e.dataTransfer.files;
      previewImage(file);
    }
  });

  // Evento click en el contenedor
  containerImg.addEventListener("click", function (e) {
    if (!e.target.closest(".btn")) {
      photoInput.click();
    }
  });

  // Evento click del botón
  submitBtn.addEventListener("click", async function (e) {
    e.preventDefault();

    if (!photoInput.files.length) {
      Swal.fire({
        icon: "warning",
        title: "Atención",
        text: "Por favor, seleccione una imagen",
      });
      return;
    }

    // Mostrar loader
    divLoading.css("display", "flex");

    try {
      const formData = new FormData();
      formData.append("image", photoInput.files[0]);

      const response = await fetch("/admin/prediccion", {
        method: "POST",
        body: formData,
        headers: {
          "X-Requested-With": "XMLHttpRequest",
        },
      });

      if (!response.ok) {
        // Intentar obtener mensaje de error del servidor
        let errorMessage = "Error al procesar la imagen";
        try {
          const errorData = await response.json();
          errorMessage = errorData.error || errorMessage;
        } catch (e) {
          console.error("Error parsing error response:", e);
        }
        throw new Error(errorMessage);
      }

      const data = await response.json();

      if (!data.success) {
        throw new Error(data.error || "Error al procesar la imagen");
      }

      // Mostrar resultados
      cardResult.style.display = "block";

      // Scroll suave hacia los resultados
      cardResult.scrollIntoView({ behavior: "smooth", block: "start" });

      // Actualizar información
      if (data.data.detections && data.data.detections.length > 0) {
        const detection = data.data.detections[0];
        resultName.textContent = detection.class || "No disponible";
        resultName2.textContent =
          detection.additional_info?.common_name || "No disponible";
        resultLink.href = detection.additional_info?.url || "#";
        resultImg.src = detection.additional_info?.image || "#";
        resultTime.textContent = data.data.execution_time || "No disponible";
        downloadBtn.setAttribute("onclick", `downloadPDF(${data.data.cod})`);

        // Mostrar mensaje de éxito
        Swal.fire({
          icon: "success",
          title: "Identificación Exitosa",
          text: `Se ha identificado: ${detection.class}`,
          timer: 2000,
          showConfirmButton: false,
        });
      } else {
        // No se encontraron detecciones
        Swal.fire({
          icon: "info",
          title: "Sin Detecciones",
          text: "No se encontraron especies en la imagen proporcionada",
        });
      }
    } catch (error) {
      console.error("Error:", error);
      Swal.fire({
        icon: "error",
        title: "Error",
        text: error.message || "Error al procesar la imagen",
        confirmButtonColor: "#3085d6",
      });
    } finally {
      divLoading.css("display", "none");
      // reproducir sonido
      new Audio(base_url + "notificacion.mp3").play();
    }
  });
});

// Estilos actualizados
const style = document.createElement("style");
style.textContent = `
  .container-img {
      position: relative;
      height: 300px;
      border: 2px dashed #d4d4d4;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      overflow: hidden;
      background-color: #f8f9fa;
      transition: all 0.3s ease;
      padding: 10px;
  }

  .container-img input[type="file"] {
      position: absolute;
      width: 100%;
      height: 100%;
      opacity: 0;
      cursor: pointer;
      z-index: -1;
  }

  .preview-container {
      width: 100%;
      height: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: hidden;
      padding: 10px;
  }

  .preview-img {
      display: block;
      max-width: 100%;
      max-height: 100%;
      object-fit: contain;
      border-radius: 4px;
      transition: transform 0.3s ease;
  }

  .dz-message {
      padding: 2rem;
      text-align: center;
      color: #6c757d;
  }

  .container-img:hover {
      border-color: #696cff;
  }

  .remove-btn {
      position: absolute;
      top: 10px;
      right: 10px;
      z-index: 10;
      width: 32px;
      height: 32px;
      padding: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 50%;
      transition: all 0.3s ease;
      background-color: rgba(220, 53, 69, 0.9);
  }

  .remove-btn:hover {
      background-color: #dc3545;
      transform: scale(1.1);
  }

  .remove-btn i {
      font-size: 20px;
  }

  .dragover {
      border-color: #696cff;
      background-color: rgba(105, 108, 255, 0.05);
  }

  /* Estilo para el mensaje de arrastrar */
  .dz-message {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 0.5rem;
  }

  .dz-message .note {
      font-size: 0.875rem;
      color: #6c757d;
  }
  .result-img{
    max-height: 300px;
    object-fit: contain;
    border: 1px solid #d4d4d4;
  }
`;
document.head.appendChild(style);

function downloadPDF(data) {
  divLoading.css("display", "flex");

  // Generar URL segura con base_url
  // const pdfURL = base_url + "admin/prediccion/" + data;
  const pdfURL = `${base_url}admin/prediccion/pdf/${data}`;

  // Obtener el modal y el embed del PDF
  const modal = new bootstrap.Modal(document.getElementById("mdlVerPDF"));
  const pdfEmbed = document.getElementById("pdf");

  // Actualizar el título del modal con el título de la práctica
  const modalTitle = document.querySelector("#mdlVerPDF .modal-title");
  modalTitle.textContent = `Reporte`;

  // Establecer la URL del PDF en el embed
  pdfEmbed.src = pdfURL;

  // Manejar errores de carga del PDF
  pdfEmbed.onerror = function () {
    Toast.fire({
      icon: "info",
      title: "Error al cargar el PDF. Por favor, intente nuevamente.",
    });
    modal.hide();
  };

  // Mostrar el modal
  modal.show();

  // Limpiar el embed cuando se cierre el modal
  document
    .getElementById("mdlVerPDF")
    .addEventListener("hidden.bs.modal", function () {
      pdfEmbed.src = "";
    });

  divLoading.css("display", "none");
}
