<!DOCTYPE html>
<html
    lang="es"
    class="light-style customizer-hide"
    dir="ltr"
    data-theme="theme-default"
    data-assets-path="/assets/"
    data-template="vertical-menu-template-free">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $data['titulo_web'] ?? $_ENV["APP_NAME"]; ?></title>
    <!-- Fonts -->
    <link rel="stylesheet" href="/css/appfonts.css">
    <!-- Icons. Uncomment required icon fonts -->
    <link rel="stylesheet" href="/css/boxicons.css" />
    <script src="https://kit.fontawesome.com/b4dffa1b79.js" crossorigin="anonymous"></script>
    <!-- Core CSS -->
    <link rel="stylesheet" href="/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="/css/custom.css" />
    <!-- Vendors CSS -->
    <link rel="stylesheet" href="/css/perfect-scrollbar.css" />
    <link rel="stylesheet" href="/css/page-misc.css" />
    <!-- Helpers -->
    <script src="/js/helpers.js"></script>
    <!-- Other -->
    <script src="/js/config.js"></script>
    <link rel="stylesheet" href="/css/demo.css">
    <link rel="stylesheet" href="/css/datatables.bootstrap5.css">
    <?php
    if (isset($data['css']) && !empty($data['css'])) {
        for ($i = 0; $i < count($data['css']); $i++) {
            echo '<link rel="stylesheet" type="text/css" href="' . $data['css'][$i] . '">' . PHP_EOL;
        }
    }
    ?>
</head>

<body>
    <!-- Error -->
    <div class="container-xxl container-p-y">
        <div class="misc-wrapper">
            <h2 class="mb-2 mx-2">Pagina no Encontrada :(</h2>
            <p class="mb-4 mx-2">Oops! 😖 La URL solicitada no se encontró en este servidor.</p>
            <a href="javascript:history.back()" class="btn btn-primary">Back to home</a>
            <div class="mt-3">
                <img src="/img/page-misc-error-dark.png" alt="page-misc-error-light" width="500" class="img-fluid" data-app-dark-img="illustrations/page-misc-error-dark.png" data-app-light-img="illustrations/page-misc-error-light.png">
            </div>
        </div>
    </div>
    <!-- /Error -->
    <!-- Overlay -->
    <div class="layout-overlay layout-menu-toggle"></div>

    <!-- Drag Target Area To SlideIn Menu On Small Screens -->
    <div class="drag-target"></div>
    </div>
    <script>
        const base_url = "<?php echo base_url(); ?>";
    </script>
    <!-- Core JS -->
    <script src="/js/jquery.min.js"></script>
    <script src="/js/popper.min.js"></script>
    <script src="/js/bootstrap.min.js"></script>

    <script src="/js/menu.js"></script>
    <!-- Main JS -->
    <script src="/js/main.js"></script>
</body>

</html>