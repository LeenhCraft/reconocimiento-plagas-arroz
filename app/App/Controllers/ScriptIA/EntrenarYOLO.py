import os
import sys
import json
import argparse
import yaml
import torch
from pathlib import Path
from datetime import datetime

# Constantes globales para valores por defecto
DEFAULT_EPOCHS = 300
DEFAULT_BATCH_SIZE = 16
DEFAULT_IMG_SIZE = 640
DEFAULT_MODEL_SIZE = 's'
VALID_MODEL_SIZES = ['n', 's', 'm', 'l', 'x']

class Logger:
    def __init__(self, debug: bool = False, log_file: str = None):
        """
        Inicializa el logger con opciones de debug y archivo de log.
        Si no se especifica log_file, crea uno por defecto.
        
        Args:
            debug (bool): Si True, imprime mensajes de debug en consola
            log_file (str): Ruta opcional al archivo de log
        """
        self.debug = debug
        
        # Si no se especifica archivo de log, crear uno por defecto
        if log_file is None:
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            log_dir = Path('logs')
            log_dir.mkdir(exist_ok=True)
            self.log_file = str(log_dir / f'training_{timestamp}.log')
        else:
            self.log_file = log_file
            
        # Crear directorio de logs
        os.makedirs(os.path.dirname(self.log_file), exist_ok=True)
        
        # Registrar inicio de sesión
        self.log_to_file(f"=== Inicio de sesión: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} ===")

    def print(self, message: str):
        """
        Imprime mensaje en consola si debug está activado y siempre lo guarda en el log.
        
        Args:
            message (str): Mensaje a registrar
        """
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        formatted_message = f'[{timestamp}] {message}'
        
        # Siempre escribir al archivo de log
        self.log_to_file(formatted_message)
        
        # Imprimir en consola solo si debug está activado
        if self.debug:
            print(formatted_message)

    def log_to_file(self, message: str):
        """
        Escribe mensaje en el archivo de log.
        
        Args:
            message (str): Mensaje a registrar
        """
        try:
            with open(self.log_file, 'a', encoding='utf-8') as f:
                f.write(message + '\n')
        except Exception as e:
            if self.debug:
                print(f"Error escribiendo en log: {str(e)}")
                
    def log_dict(self, data: dict, title: str = None):
        """
        Registra un diccionario en formato JSON en el log.
        
        Args:
            data (dict): Diccionario a registrar
            title (str): Título opcional para la sección
        """
        try:
            if title:
                self.log_to_file(f"\n=== {title} ===")
            json_str = json.dumps(data, indent=2)
            self.log_to_file(json_str)
        except Exception as e:
            if self.debug:
                print(f"Error registrando diccionario: {str(e)}")

def dep(data, exit=True):
    print(data)
    if exit:
        sys.exit()

def get_time_diff(start_time, end_time):
    """
    Calcula la diferencia de tiempo entre dos momentos.
    
    Args:
        start_time (datetime): Tiempo inicial
        end_time (datetime): Tiempo final
        
    Returns:
        dict: Diccionario con los tiempos y diferencias
    """
    time_diff = end_time - start_time
    seconds_diff = time_diff.total_seconds()
    
    hours = int(seconds_diff // 3600)
    minutes = int((seconds_diff % 3600) // 60)
    seconds = int(seconds_diff % 60)
    
    return {
        'inicio': start_time.timestamp(),
        'fin': end_time.timestamp(),
        'diferencia_segundos': seconds_diff,
        'tiempo_formateado': f"{hours:02d}:{minutes:02d}:{seconds:02d}"
    }


def debug_json_serialization(data):
    """
    Verifica la serialización JSON de cada campo en el diccionario.
    """
    for key, value in data.items():
        try:
            json.dumps({key: value})
        except TypeError as e:
            print(f"Error en el campo '{key}':")
            print(f"  Tipo: {type(value)}")
            print(f"  Valor: {value}")
            print(f"  Error: {str(e)}")
            
            # Si es un diccionario anidado, verifica sus campos
            if isinstance(value, dict):
                print(f"\nRevisando campos dentro de '{key}':")
                debug_json_serialization(value)

def validate_paths(data_yaml: str, output_path: str, logger: Logger) -> dict:
    """
    Valida que las rutas y archivos necesarios existan y tengan los permisos correctos.
    
    Args:
        data_yaml (str): Ruta al archivo de configuración
        output_path (str): Ruta donde se guardarán los resultados
        logger (Logger): Instancia del logger
        
    Returns:
        dict: Resultado de la validación con claves 'success' y opcionalmente 'error'
    """
    try:
        logger.print("Validando rutas...")

        data_yaml = Path(data_yaml)
        output_path = Path(output_path)
        
        # Validar extensión del archivo
        if data_yaml.suffix != '.yaml':
            return {"success": False, "error": "El archivo debe tener extensión .yaml"}
        
        # Validar existencia del archivo
        if not data_yaml.exists():
            return {"success": False, "error": "El archivo data.yaml no existe"}
        
        # Validar que sea un archivo y no un directorio
        if not data_yaml.is_file():
            return {"success": False, "error": "La ruta data.yaml no es un archivo"}
        
        # Crear directorio de salida si no existe
        output_path.mkdir(parents=True, exist_ok=True)
            
        # Validar permisos de escritura
        if not os.access(output_path, os.W_OK):
            return {"success": False, "error": "No hay permisos de escritura en la ruta de salida"}
        
        logger.print("Validación de rutas exitosa")
        return {"success": True}
        
    except Exception as e:
        return {"success": False, "error": f"Error al validar rutas: {str(e)}"}

def load_data_config(yaml_path: str, logger: Logger) -> dict:
    """
    Carga y valida la configuración del data.yaml
    
    Args:
        yaml_path (str): Ruta al archivo yaml
        logger (Logger): Instancia del logger
        
    Returns:
        dict: Resultado de la carga con claves 'success' y 'data' o 'error'
    """
    try:
        logger.print("Cargando configuración...")

        yaml_path = Path(yaml_path)  # Convertir a Path
        if not yaml_path.exists():
            return {"success": False, "error": "Archivo de configuración no encontrado"}
        
        with open(yaml_path, 'r', encoding='utf-8') as f:
            data = yaml.safe_load(f)
        
        # Validar claves requeridas
        required_keys = ['train', 'val', 'nc', 'names']
        missing_keys = [key for key in required_keys if key not in data]
        
        if missing_keys:
            return {
                "success": False, 
                "error": f"Faltan las siguientes claves en data.yaml: {', '.join(missing_keys)}"
            }
        
        # Validar tipos de datos
        if not isinstance(data['nc'], int):
            return {"success": False, "error": "'nc' debe ser un número entero"}
        
        if not isinstance(data['names'], list):
            return {"success": False, "error": "'names' debe ser una lista"}
        
        if len(data['names']) != data['nc']:
            return {
                "success": False, 
                "error": f"El número de clases ({data['nc']}) no coincide con la cantidad de nombres ({len(data['names'])})"
            }
        
        logger.print("Configuración cargada exitosamente")
        return {"success": True, "data": data}
        
    except yaml.YAMLError as e:
        return {"success": False, "error": f"Error al parsear YAML: {str(e)}"}
    except Exception as e:
        return {"success": False, "error": f"Error al cargar data.yaml: {str(e)}"}

def validate_training_params(epochs: int, batch_size: int, img_size: int, 
                           model_size: str, device: str, logger: Logger) -> dict:
    """
    Valida los parámetros de entrenamiento.
    
    Args:
        epochs (int): Número de épocas
        batch_size (int): Tamaño del batch
        img_size (int): Tamaño de las imágenes
        model_size (str): Tamaño del modelo
        logger (Logger): Instancia del logger
        
    Returns:
        dict: Resultado de la validación
    """
    try:
        logger.print("Validando parámetros de entrenamiento...")
        
        if epochs <= 0:
            return {"success": False, "error": "El número de épocas debe ser positivo"}
            
        if batch_size <= 0:
            return {"success": False, "error": "El tamaño del batch debe ser positivo"}
            
        if img_size <= 0:
            return {"success": False, "error": "El tamaño de imagen debe ser positivo"}
            
        if model_size not in VALID_MODEL_SIZES:
            return {
                "success": False, 
                "error": f"Tamaño de modelo inválido. Debe ser uno de: {', '.join(VALID_MODEL_SIZES)}"
                }
        # Validar device
        if device not in ['cpu', '0', '1', '2', '3']:
            return {
                "success": False,
                "error": "Device debe ser 'cpu' o un número de GPU válido (0-3)"
            }
        
        if device != 'cpu':
            if not torch.cuda.is_available():
                return {
                    "success": False,
                    "error": "CUDA no está disponible en el sistema"
                }
            if int(device) >= torch.cuda.device_count():
                return {
                    "success": False,
                    "error": f"GPU {device} no existe. Dispositivos disponibles: 0-{torch.cuda.device_count()-1}"
                }
        if device == 'cuda' and not torch.cuda.is_available():
            return {
                "success": False,
                "error": "CUDA solicitado pero no disponible en el sistema"
                }
        logger.print("Validación de parámetros exitosa")
        return {"success": True}
        
    except Exception as e:
        return {"success": False, "error": f"Error al validar parámetros: {str(e)}"}

def train_model(data_config: dict, output_path: str, name_experiment:str, epochs: int, 
                batch_size: int, img_size: int, device: str, 
                logger: Logger, model_size: str, weights: str = None) -> dict:
    """
    Ejecuta el entrenamiento del modelo YOLOv5.
    
    Args:
        data_config (dict): Configuración del dataset desde data.yaml
        output_path (str): Ruta donde se guardarán los resultados
        epochs (int): Número de épocas de entrenamiento
        batch_size (int): Tamaño del batch para entrenamiento
        img_size (int): Tamaño de las imágenes de entrada
        device (str): Dispositivo para entrenamiento ('cpu' o 'cuda')
        logger (Logger): Instancia del logger para debugging
        model_size (str): Tamaño del modelo ('n','s','m','l','x')
        weights (str, optional): Ruta a pesos pre-entrenados
    
    Returns:
        dict: Diccionario con resultados del entrenamiento y estadísticas
    """
    try:
        start_time = datetime.now()
        logger.print("\n=== Iniciando entrenamiento ===")
        
        # Validar parámetros
        param_validation = validate_training_params(epochs, batch_size, img_size, model_size, device, logger)
        if not param_validation["success"]:
            logger.log_dict(param_validation, "Error en validación de parámetros")
            return param_validation
        
        # Si hay pesos, verificar que existan
        if weights and not os.path.exists(weights):
            logger.print(f"No se encontró el archivo de pesos: {weights}")
            return {
                "success": False,
                "error": f"No se encontró el archivo de pesos: {weights}"
            }
        
        # Importar YOLOv5
        from yolov5 import train
        
        # Obtener la configuración desde el paquete yolov5
        from yolov5.models.yolo import Model
        from yolov5.utils.downloads import attempt_download

        # Asegurar que output_path sea string
        output_path = str(output_path) if isinstance(output_path, Path) else output_path

        # Configurar modelo
        cfg = f'yolov5{model_size}.yaml'

        # cfg_path = attempt_download(f'models/{cfg}')
        models_dir = Path('models')
        if not models_dir.exists():
            logger.print("Directorio 'models' no encontrado")
            return {
                "success": False,
                "error": "Directorio 'models' no encontrado"
            }

        # Obtener la ruta absoluta directamente en un solo paso
        cfg_path = str((models_dir / cfg).absolute())   

        # Configurar argumentos de entrenamiento
        args = {
            'data': data_config,
            'epochs': epochs,
            'batch_size': batch_size,
            'imgsz': img_size,
            'weights': weights,  # Indica entrenamiento desde cero
            'cfg': cfg_path,
            'project': output_path,
            'name': name_experiment,
            'device': device,
            'save_period': -1,  # Guardar último y mejor modelo
            'exist_ok': True,
            'patience': 100,    # Early stopping patience
            'workers': 8,
            'freeze': [0],
            # 'verbose': False # No imprimir logs
        }

        # Registrar configuración
        logger.log_dict(args, "Configuración de entrenamiento")
        
        # Depurar antes de la serialización
        logger.print("Verificando serialización de parámetros...")
        debug_json_serialization(args)

        try:
            # Intentar serializar para logging
            logger.print("Configuración de entrenamiento (serealizando):")
            logger.print(json.dumps(args, indent=2))

        except TypeError as e:
            logger.print(f"Error al serializar argumentos: {e}")
            return {
                "success": False,
                "error": f"Error de serialización: {e}"
            }
      
        # Entrenar modelo
        results = train.run(**args)

        # Obtener rutas de los modelos
        model_dir = Path(output_path) / name_experiment / 'weights'
        best_model_path = model_dir / 'best.pt'
        last_model_path = model_dir / 'last.pt'
        
        end_time = datetime.now()
        training_time = get_time_diff(start_time, end_time)

        # Procesar resultados
        training_stats = {
            "final_epoch": epochs,  # Número total de épocas ejecutadas
            "training_time": training_time["tiempo_formateado"],  # Se podría implementar midiendo el tiempo de ejecución
            "model_paths": {
                "best": str(best_model_path),
                "last": str(last_model_path)
            },
        }

        try:
            # Evaluar el mejor modelo
            evaluate = evaluate_model(
                name_experiment = name_experiment,
                weights_path = best_model_path,
                data_yaml = data_config,
                img_size = img_size,
                device='0'  # usa GPU si está disponible
            )
            evaluate['metrics'] = {k: v.tolist() if hasattr(v, 'tolist') else list(v) for k,v in evaluate['metrics'].items()}
        except TypeError as e:
            logger.print(f"Error al evaluar modelo: {e}")
            return {
                "success": False,
                "error": f"Error al evaluar modelo: {e}"
            }

        # Registrar resultados
        logger.log_dict(training_stats, "Estadísticas de entrenamiento")
        logger.log_dict(evaluate["metrics"], "Métricas de evaluación")

        logger.print("Entrenamiento completado exitosamente")
        return {
            "success": True,
            "stats": training_stats,
            "evaluation": evaluate["metrics"]
        }
        
    except Exception as e:
        error_info = {"success": False, "error": f"Error durante el entrenamiento: {str(e)}"}
        logger.log_dict(error_info, "Error en entrenamiento")
        return error_info

def evaluate_model(name_experiment:str, weights_path, data_yaml, img_size=640, device='cpu'):
    """
    Evalúa un modelo YOLOv5 entrenado
    """
    from yolov5 import val
    
    try:
        results = val.run(
            weights=weights_path,
            data=data_yaml,
            name=name_experiment,
            batch_size=32,
            imgsz=img_size,
            device=device,
            save_txt=False,
            save_hybrid=False,
            save_conf=True,
            verbose=True
        )
        
        # Extraer métricas
        metrics = {
            'precision': results[0],
            'recall': results[1],
            'mAP50': results[2],
            'mAP50_95': results[3]
        }

        return {
            "success": True,
            "metrics": metrics
        }
        
    except Exception as e:
        return {
            "success": False,
            "error": str(e)
        }

def main(data_yaml: str, output_path: str, name_experiment: str, epochs: int, 
         batch_size: int, img_size: int, device: str, 
         debug: bool, model_size: str, weights: str = None, log_file: str = None) -> dict:
    """
    Función principal que coordina el entrenamiento.
    
    Args:
        data_yaml (str): Ruta al archivo de configuración
        output_path (str): Ruta de salida para los resultados
        epochs (int): Número de épocas
        batch_size (int): Tamaño del batch
        img_size (int): Tamaño de las imágenes
        device (str): Dispositivo de entrenamiento
        debug (bool): Activar modo debug
        model_size (str): Tamaño del modelo
        weights (str, optional): Ruta a pesos pre-entrenados
        log_file (str): Ruta opcional al archivo de log
        
    Returns:
        dict: Resultado del proceso completo
    """
    logger = Logger(debug, log_file)
    try:
        logger.print("=== Iniciando script de entrenamiento ===")
        # Registrar parámetros de entrada
        input_params = {
            "data_yaml": str(data_yaml),
            "output_path": str(output_path),
            "name_experiment": name_experiment,
            "epochs": epochs,
            "batch_size": batch_size,
            "img_size": img_size,
            "device": device,
            "model_size": model_size,
            "weights": str(weights) if weights else None
        }
        logger.log_dict(input_params, "Parámetros de entrada")

        # Validar rutas
        validation = validate_paths(data_yaml, output_path, logger)
        if not validation["success"]:
            logger.log_dict(validation, "Error en validación de rutas")
            return validation
        
        # Cargar configuración
        config_result = load_data_config(data_yaml, logger)
        if not config_result["success"]:
            logger.log_dict(config_result, "Error al cargar configuración")
            return config_result
        
        # Entrenar modelo
        train_result = train_model(
            data_config=data_yaml,
            output_path=output_path,
            name_experiment=name_experiment,
            epochs=epochs,
            batch_size=batch_size,
            img_size=img_size,
            device=device,
            logger=logger,
            model_size=model_size,
            weights=weights
        )
        
        if not train_result["success"]:
            logger.log_dict(train_result, "Error en entrenamiento")
            return train_result
        
        # Agregar información adicional al resultado
        train_result["config"] = {
            "data_yaml": data_yaml,
            "output_path": str(output_path / name_experiment),
            "epochs": epochs,
            "batch_size": batch_size,
            "img_size": img_size,
            "device": device,
            "model_size": model_size
        }

        # Registrar resultado final
        logger.log_dict(train_result, "Resultado final del entrenamiento")

        return train_result
        
    except Exception as e:
        error_result = {"success": False, "error": f"Error general: {str(e)}"}
        logger.log_dict(error_result, "Error general")
        return error_result

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Entrena un modelo YOLOv5')
    
    parser.add_argument('--data', required=True,
                       help='Ruta al archivo data.yaml')
    parser.add_argument('--output', required=True,
                       help='Ruta donde se guardará el modelo entrenado')
    parser.add_argument('--name', type=str, default='exp',
                        help='Nombre del experimento (default: exp)')
    parser.add_argument('--epochs', type=int, default=DEFAULT_EPOCHS,
                       help=f'Número de épocas de entrenamiento (default: {DEFAULT_EPOCHS})')
    parser.add_argument('--batch-size', type=int, default=DEFAULT_BATCH_SIZE,
                       help=f'Tamaño del batch (default: {DEFAULT_BATCH_SIZE})')
    parser.add_argument('--img-size', type=int, default=DEFAULT_IMG_SIZE,
                       help=f'Tamaño de las imágenes (default: {DEFAULT_IMG_SIZE})')
    parser.add_argument('--device', type=str, default='0',
                       help='Dispositivo cuda device, i.e. 0 o cpu')
    parser.add_argument('--debug', action='store_true',
                       help='Activa los mensajes de depuración')
    parser.add_argument('--model-size', choices=VALID_MODEL_SIZES, default=DEFAULT_MODEL_SIZE,
                       help='Tamaño del modelo (n=nano, s=small, m=medium, l=large, x=xlarge)')
    parser.add_argument('--weights', default=None, type=str ,
                       help='Ruta a pesos pre-entrenados (opcional)')
    parser.add_argument('--log-file',
                       help='Ruta al archivo de log (opcional)')
    
    args = parser.parse_args()

    # obtener la ruta absoluta de args.output usando Path
    args.output = Path(args.output).absolute()
    if args.log_file:
        args.log_file = Path(args.log_file).absolute()

    result = main(
        data_yaml=args.data,
        output_path=args.output,
        name_experiment=args.name,
        epochs=args.epochs,
        batch_size=args.batch_size,
        img_size=args.img_size,
        device=args.device,
        debug=args.debug,
        model_size=args.model_size,
        weights=args.weights,
        log_file=args.log_file
    )

    # Mostrar resultado en JSON
    # print(json.dumps(result, indent=2, ensure_ascii=False))
    print(json.dumps(result, indent=2))