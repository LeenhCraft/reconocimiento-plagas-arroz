import os
import sys
import json
import argparse
import yaml
import torch
from pathlib import Path
from datetime import datetime

# Constantes globales
DEFAULT_EPOCHS = 300
DEFAULT_BATCH_SIZE = 16
DEFAULT_IMG_SIZE = 640
DEFAULT_MODEL_SIZE = 's'
VALID_MODEL_SIZES = ['n', 's', 'm', 'l', 'x']

class Logger:
    def __init__(self, debug: bool = False, log_file: str = None):
        self.debug = debug
        self.log_file = Path(log_file) if log_file else None
        
        if self.log_file:
            self.log_file.parent.mkdir(parents=True, exist_ok=True)
    
    def print(self, message: str):
        if self.debug:
            timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            formatted_message = f'[{timestamp}] {message}'
            print(formatted_message)
            if self.log_file:
                with open(self.log_file, 'a', encoding='utf-8') as f:
                    f.write(formatted_message + '\n')

def verify_dataset_structure(train_path: Path, val_path: Path) -> bool:
    """Verifica que la estructura del dataset sea correcta"""
    # Verificar que existen las carpetas de imágenes
    if not train_path.exists() or not val_path.exists():
        return False
     
    # Verificar que existen las carpetas de etiquetas (labels)
    train_labels = train_path.parent / 'labels'
    val_labels = val_path.parent / 'labels'
    
    if not train_labels.exists() or not val_labels.exists():
        return False
    
    return True

def create_data_yaml(base_path: Path, output_dir: Path) -> Path:
    """
    Crea un archivo data.yaml con la estructura correcta para YOLOv5
    """
    # Definir rutas relativas al directorio base
    dataset_path = base_path / "entrenamiento" / "Clases"
    train_images = dataset_path / "train" / "images"
    val_images = dataset_path / "val" / "images"
    
    # Verificar estructura del dataset
    if not verify_dataset_structure(train_images, val_images):
        raise ValueError("Estructura del dataset incorrecta")
    
    data_config = {
        'path': str(dataset_path.absolute()),  # Ruta base del dataset
        'train': str(train_images.absolute()),  # Ruta a las imágenes de entrenamiento
        'val': str(val_images.absolute()),      # Ruta a las imágenes de validación
        'test': str(val_images.absolute()),     # Usar mismo conjunto de validación para pruebas
        'nc': 5,  # Número de clases
        'names': [
            'Caracol manzana',
            'Falso medidor',
            'Gusano cogollero',
            'Gusano enrollador de la hoja',
            'Sogata del arroz'
        ]
    }
    
    # Crear archivo data.yaml
    yaml_path = output_dir / 'data.yaml'
    with open(yaml_path, 'w', encoding='utf-8') as f:
        yaml.safe_dump(data_config, f, default_flow_style=False, allow_unicode=True)
    
    return yaml_path

def train_model(base_path: Path, output_path: Path, epochs: int, 
                batch_size: int, img_size: int, device: str, 
                logger: Logger, model_size: str) -> dict:
    try:
        logger.print("\n=== Iniciando entrenamiento ===")
        
        # Crear directorio de salida
        output_path.mkdir(parents=True, exist_ok=True)
        
        # Crear archivo data.yaml
        try:
            data_yaml = create_data_yaml(base_path, output_path)
            logger.print(f"Archivo data.yaml creado en: {data_yaml}")
            
            # Mostrar contenido del data.yaml
            with open(data_yaml, 'r') as f:
                logger.print(f"Contenido del data.yaml:\n{f.read()}")
        except Exception as e:
            return {"success": False, "error": f"Error creando data.yaml: {str(e)}"}
        
        # Importar YOLOv5
        from yolov5 import train

        print(data_yaml)
        exit()


        # Configurar argumentos de entrenamiento
        args = {
            'data': str(data_yaml.absolute()),
            'epochs': epochs,
            'batch_size': batch_size,
            'imgsz': img_size,
            'weights': None,  # Entrenamiento desde cero
            'cfg': f'models/yolov5{model_size}.yaml',
            'project': str(output_path.absolute()),
            'name': 'exp',
            'device': device,
            'save_period': -1,
            'exist_ok': True,
            'patience': 100,
            'workers': 8,
            'freeze': [0],
        }
        
        logger.print("Configuración de entrenamiento:")
        logger.print(json.dumps(args, indent=2))
        
        # Entrenar modelo
        results = train.run(**args)
        
        training_stats = {
            "best_fitness": float(results.best_fitness),
            "final_epoch": int(results.epoch),
            "training_time": str(results.duration),
            "model_paths": {
                "best": str(results.best),
                "last": str(results.last)
            }
        }
        
        logger.print("Entrenamiento completado exitosamente")
        return {
            "success": True,
            "stats": training_stats
        }
        
    except Exception as e:
        return {
            "success": False,
            "error": f"Error durante el entrenamiento: {str(e)}"
        }

def main(base_path: str, output_path: str, epochs: int, batch_size: int, 
         img_size: int, device: str, debug: bool, model_size: str, 
         log_file: str = None) -> dict:
    """Función principal que coordina el entrenamiento"""
    logger = Logger(debug, log_file)
    try:
        # Convertir rutas a objetos Path
        base_dir = Path(base_path)
        output_dir = Path(output_path)
        
        # Entrenar modelo
        train_result = train_model(
            base_path=base_dir,
            output_path=output_dir,
            epochs=epochs,
            batch_size=batch_size,
            img_size=img_size,
            device=device,
            logger=logger,
            model_size=model_size
        )
        
        if not train_result["success"]:
            return train_result
            
        train_result["config"] = {
            "base_path": str(base_dir),
            "output_path": str(output_dir),
            "epochs": epochs,
            "batch_size": batch_size,
            "img_size": img_size,
            "device": device,
            "model_size": model_size
        }
        
        return train_result
        
    except Exception as e:
        return {
            "success": False,
            "error": f"Error general: {str(e)}"
        }

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Entrena un modelo YOLOv5')
    
    parser.add_argument('--base-path', required=True,
                       help='Ruta base del proyecto (e.g., C:/laragon/www/plagas-arroz/public_html)')
    parser.add_argument('--output', required=True,
                       help='Ruta donde se guardará el modelo entrenado')
    parser.add_argument('--epochs', type=int, default=DEFAULT_EPOCHS,
                       help=f'Número de épocas de entrenamiento (default: {DEFAULT_EPOCHS})')
    parser.add_argument('--batch-size', type=int, default=DEFAULT_BATCH_SIZE,
                       help=f'Tamaño del batch (default: {DEFAULT_BATCH_SIZE})')
    parser.add_argument('--img-size', type=int, default=DEFAULT_IMG_SIZE,
                       help=f'Tamaño de las imágenes (default: {DEFAULT_IMG_SIZE})')
    parser.add_argument('--device', default='',
                       help='Dispositivo cuda device, i.e. 0 o cpu')
    parser.add_argument('--debug', action='store_true',
                       help='Activa los mensajes de depuración')
    parser.add_argument('--model-size', choices=VALID_MODEL_SIZES, default=DEFAULT_MODEL_SIZE,
                       help='Tamaño del modelo (n=nano, s=small, m=medium, l=large, x=xlarge)')
    parser.add_argument('--log-file',
                       help='Ruta al archivo de log (opcional)')
    
    args = parser.parse_args()

    result = main(
        base_path=args.base_path,
        output_path=args.output,
        epochs=args.epochs,
        batch_size=args.batch_size,
        img_size=args.img_size,
        device=args.device,
        debug=args.debug,
        model_size=args.model_size,
        log_file=args.log_file
    )
    
    print(json.dumps(result, indent=2, ensure_ascii=False))