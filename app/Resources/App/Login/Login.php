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
    <!-- Page -->
    <link rel="stylesheet" href="/css/page-auth.css" />
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
    <!-- Content -->
    <div class="container-xxl">
        <div class="authentication-wrapper authentication-basic container-p-y">
            <div class="authentication-inner">
                <div class="divLoading" style="display: none;">
                    <div>
                        <img src="/img/loading.svg" alt="Loading">
                    </div>
                </div>
                <!-- Register -->
                <div class="text-end mb-4 zindex-1 position-relative">
                    <a href="/" class="text-end fw-bold" tabindex="0">
                        <i class='bx bx-arrow-back'></i>
                        Regresar
                    </a>
                </div>
                <div class="text-end mb-4 zindex-1 position-relative d-none">
                    <a href="/" class="text-end fw-bold" tabindex="0">
                        <i class='bx bx-arrow-back'></i>
                        Regresar
                    </a>
                </div>
                <div class="card">
                    <div class="card-body card-content">
                        <!-- Logo -->
                        <div class="app-brand justify-content-center mb-3">
                            <a href="/admin/login" class="app-brand-link gap-2">
                                <picture>
                                    <source srcset="/img/logo-dark.png" type="image/webp">
                                    <img src="/img/logo-dark.png" alt="<?= $_ENV["APP_NAME"]; ?>" class="app-brand-logo w-px-150">
                                </picture>
                            </a>
                        </div>
                        <!-- /Logo -->
                        <h4 class="mb-2 text-center ff-niconne fs-1"><?= $_ENV["APP_NAME"] ?></h4>
                        <form id="frmlogin" class="mb-3">
                            <div class="mb-3">
                                <label for="email" class="form-label">Usuario</label>
                                <input type="text" class="form-control" id="email" name="email" placeholder="Ingrese su usuario" tabindex="1" value="developer" autofocus>
                            </div>
                            <div class="mb-3 form-password-toggle">
                                <div class="d-flex justify-content-between">
                                    <label class="form-label" for="password">Contraseña</label>
                                </div>
                                <div class="input-group input-group-merge">
                                    <input type="password" id="password" class="form-control" name="password" placeholder="&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;" aria-describedby="pass" tabindex="2" value="123123" />
                                    <span class="input-group-text cursor-pointer"><i class="bx bx-hide"></i></span>
                                </div>
                            </div>
                            <div class="mb-3">
                                <button id="boton" class="btn btn-primary d-grid w-100" type="submit" tabindex="3">Ingresar</button>
                            </div>
                        </form>

                        <p class="text-center">
                            <a href="#" class="">
                                <span>¿Ha olvidado tu contraseña?</span>
                            </a>
                        </p>
                    </div>
                    <div class="card-body card-success" style="display: none;">
                        <div class="app-brand justify-content-center">
                            <a href="/admin/login" class="app-brand-link gap-2">
                                <picture>
                                    <source srcset="/img/logo-dark.png" type="image/webp">
                                    <img src="/img/logo-dark.png" alt="<?= $_ENV["APP_NAME"]; ?>" class="app-brand-logo w-px-150">
                                </picture>
                            </a>
                        </div>
                        <h4 class="fs-1 ff-niconne mb-2 text-center"><?= $_ENV["APP_NAME"] ?></h4>
                        <p class="fs-2 text-center text-success">Redirigiendo...</p>
                    </div>
                </div>
                <!-- /Register -->
            </div>
        </div>
    </div>
    <!-- / Content -->
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
    <!-- Other -->
    <script src="/node_modules/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <!--  -->
    <script>
        var divLoading = $(".divLoading");
        const Toast = Swal.mixin({
            toast: true,
            position: "top-end",
            showConfirmButton: false,
            showCloseButton: true,
            timer: 3000,
            timerProgressBar: true,
            didOpen: (toast) => {
                toast.addEventListener("mouseenter", Swal.stopTimer);
                toast.addEventListener("mouseleave", Swal.resumeTimer);
            },
        });

        function verpass(e, input) {
            let selector = "#" + input;
            let elem = $(selector);
            console.log(elem);

            if (elem.attr("type") == "password") {
                elem.attr("type", "text");
            } else {
                elem.attr("type", "password");
            }
        }
        document.addEventListener('DOMContentLoaded', (event) => {
            const tabOrder = ["email", "password", "boton"];
            const elements = tabOrder.map(id => document.getElementById(id));

            elements.forEach((el, index) => {
                el.addEventListener('keydown', (event) => {
                    if (event.key === 'Tab') {
                        event.preventDefault();
                        const nextIndex = (index + 1) % elements.length;
                        elements[nextIndex].focus();
                    }
                });
            });
        });
    </script>
    <?php
    if (isset($data['js']) && !empty($data['js'])) {
        for ($i = 0; $i < count($data['js']); $i++) {
            echo '<script src="' . $data['js'][$i] . '"></script>';
        }
    }
    ?>
</body>

</html>