</div>
<!-- / Content -->
<div class="content-backdrop fade"></div>
</div>
<!-- Content wrapper -->
</div>
<!-- / Layout page -->
</div>
<!-- Overlay -->
<div class="layout-overlay layout-menu-toggle"></div>
</div>
<!-- / Layout wrapper -->
<script>
    const base_url = "<?php echo base_url(); ?>";
</script>
<!-- Core JS -->
<script src="/js/jquery.min.js"></script>
<script src="/js/popper.min.js"></script>
<script src="/js/bootstrap.min.js"></script>
<script src="/js/jquery.dataTables.min.js"></script>
<script src="/js/dataTables.bootstrap.min.js"></script>
<script src="/node_modules/sweetalert2/dist/sweetalert2.all.min.js"></script>

<script src="/js/menu.js"></script>
<!-- Main JS -->
<script src="/js/main.js"></script>

<script>
    var divLoading = $("#divLoading");
    const Toast = Swal.mixin({
        toast: true,
        position: "top-end",
        showConfirmButton: false,
        showCloseButton: true,
        timer: 5000,
        timerProgressBar: true,
        didOpen: (toast) => {
            toast.addEventListener("mouseenter", Swal.stopTimer);
            toast.addEventListener("mouseleave", Swal.resumeTimer);
        },
    });

    function addCeros(int, cantidadCeros = 4) {
        const intString = int.toString(); // Convertir el número a cadena
        const length = intString.length; // Obtener la longitud de la cadena

        if (length < cantidadCeros) {
            // Agregar ceros a la izquierda si la longitud es menor que la cantidad especificada
            const ceros = '0'.repeat(cantidadCeros - length);
            return ceros + intString;
        } else {
            // Devolver el número como cadena si la longitud es mayor o igual
            return intString;
        }
    }

    function limitChars(event) {
        var $input = $(event.target);
        var charLimit = $input.data("char-limit");
        if (charLimit && $input.val().length > charLimit) {
            $input.val($input.val().substring(0, charLimit));
        }
    }
</script>
<?php
if (isset($data['js']) && !empty($data['js'])) {
    for ($i = 0; $i < count($data['js']); $i++) {
        echo '<script src="' . $data['js'][$i] . '"></script>' . PHP_EOL;
    }
}
?>
</body>

</html>