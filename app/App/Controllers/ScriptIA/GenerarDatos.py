import os
import json
import sys
from PIL import Image
import argparse
from typing import Dict, List, Tuple, Union
import shutil
import yaml
import random
from pathlib import Path

BASE_PATH = "C:/laragon/www/plagas-arroz/public_html"

class Logger:
    """
    Clase para manejar los mensajes de depuración.
    """
    def __init__(self, debug: bool = False):
        self.debug = debug
    
    def print(self, message: str):
        """
        Imprime un mensaje solo si el modo debug está activado.
        """
        if self.debug:
            print(message)

def to_url_friendly(text: str) -> str:
    """
    Convierte un texto a formato URL amigable.
    """
    text = text.lower()
    text = text.replace(' ', '-')
    text = ''.join(c for c in text if c.isalnum() or c == '-')
    return text

def validate_paths(image_path: str, output_path: str, classes_file: str, logger: Logger) -> Tuple[bool, Dict]:
    """
    Valida que las rutas existan y tengan los permisos correctos.
    """
    try:
        logger.print("Validando rutas...")
        image_path = Path(image_path)
        output_path = Path(output_path)
        classes_file = Path(classes_file)
        
        if not image_path.exists():
            return False, {"error": "La ruta de imágenes no existe", "path": str(image_path)}
        
        if not classes_file.exists():
            return False, {"error": "El archivo de clases no existe", "path": str(classes_file)}
        
        if not os.access(image_path, os.R_OK):
            return False, {"error": "No hay permisos de lectura en la ruta de imágenes", "path": str(image_path)}
            
        if not os.access(classes_file, os.R_OK):
            return False, {"error": "No hay permisos de lectura en el archivo de clases", "path": str(classes_file)}
        
        # Crear estructura de directorios usando Path
        dirs_to_create = [
            output_path / "train" / "images",
            output_path / "train" / "labels",
            output_path / "val" / "images",
            output_path / "val" / "labels"
        ]
        
        for dir_path in dirs_to_create:
            dir_path.mkdir(parents=True, exist_ok=True)
            if not os.access(dir_path.parent, os.W_OK):
                return False, {"error": f"No hay permisos de escritura en {str(dir_path)}"}
        
        logger.print("Validación de rutas exitosa")
        return True, {"message": "Validación exitosa"}
        
    except Exception as e:
        return False, {"error": f"Error al validar rutas: {str(e)}"}

def load_classes(classes_file: str, logger: Logger) -> Tuple[bool, Union[Dict, Dict]]:
    """
    Carga las clases desde el archivo JSON.
    """
    try:
        logger.print("Cargando clases...")
        classes_path = Path(classes_file)
        with classes_path.open('r', encoding='utf-8') as f:
            classes = json.load(f)
            
        if not isinstance(classes, list):
            return False, {"error": "El archivo de clases debe contener una lista"}
        
        # Crear un diccionario que mapee nombres URL amigables a nombres originales
        class_mapping = {
            to_url_friendly(class_name): class_name 
            for class_name in classes
        }
        
        logger.print(f"Se cargaron {len(classes)} clases")
        return True, class_mapping
        
    except json.JSONDecodeError:
        return False, {"error": "El archivo de clases no es un JSON válido"}
    except Exception as e:
        return False, {"error": f"Error al cargar clases: {str(e)}"}

def process_image(img_path: str, class_idx: int) -> Tuple[bool, Dict]:
    """
    Procesa una imagen y genera su etiqueta YOLO.
    """
    try:
        img_path = Path(img_path)
        img = Image.open(img_path)
        
        # En este caso, asumimos que el objeto ocupa toda la imagen
        x_center = 0.5
        y_center = 0.5
        w = 1.0
        h = 1.0
        
        return True, {
            "class_idx": class_idx,
            "x_center": x_center,
            "y_center": y_center,
            "width": w,
            "height": h
        }
        
    except Exception as e:
        return False, {"error": f"Error al procesar imagen {str(img_path)}: {str(e)}"}

def create_yaml(output_path: str, class_names: List[str], logger: Logger) -> Dict:
    """
    Crea el archivo data.yaml para YOLOv5 usando rutas absolutas.
    """
    try:
        logger.print("Generando data.yaml...")
        output_path = Path(output_path).resolve()  # Convertir a ruta absoluta
        
        # Usar rutas absolutas para train y val
        dataset_path = Path(BASE_PATH) / "entrenamiento" / "Clases"
        train_path = (output_path / 'train' / 'images').resolve()
        val_path = (output_path / 'val' / 'images').resolve()

        yaml_data = {
            'path': str(dataset_path.absolute()),
            'train': str(train_path),
            'val': str(val_path),
            'nc': len(class_names),
            'names': class_names
        }
        
        yaml_path = output_path / 'data.yaml'
        with yaml_path.open('w', encoding='utf-8') as f:
            yaml.safe_dump(yaml_data, f, sort_keys=False, allow_unicode=True)
            
        logger.print(f"Archivo data.yaml creado en: {str(yaml_path)}")
        return {
            "success": True,
            "yaml_path": str(yaml_path),
            "config": yaml_data
        }
    except Exception as e:
        return {
            "success": False,
            "error": f"Error al crear YAML: {str(e)}"
        }

def process_and_save_files(file_info: Dict, output_path: str, dataset: str) -> Tuple[bool, Dict]:
    """
    Procesa y guarda un archivo de imagen y su etiqueta correspondiente.
    """
    try:
        output_path = Path(output_path)
        # Copiar imagen
        dest_img = output_path / dataset / "images" / file_info["image"]
        shutil.copy2(file_info["image_path"], dest_img)
        
        # Guardar etiqueta
        label_name = Path(file_info["image"]).stem + '.txt'
        label_path = output_path / dataset / "labels" / label_name
        label_path.write_text(file_info["label_content"])
            
        return True, {}
    except Exception as e:
        return False, {
            "error": str(e),
            "file": file_info["image"],
            "dataset": dataset
        }

def split_data(processed_files: List[Dict], val_split: float, logger: Logger) -> Tuple[List[Dict], List[Dict]]:
    """
    Divide los archivos procesados en conjuntos de entrenamiento y validación.
    Mantiene una distribución balanceada por clase.
    
    Args:
        processed_files: Lista de diccionarios con información de los archivos procesados
        val_split: Proporción de datos para validación (0-1)
        logger: Instancia del logger para mensajes de depuración
        
    Returns:
        Tuple con listas de archivos para entrenamiento y validación
    """
    logger.print(f"Dividiendo datos con ratio de validación: {val_split}")
    
    # Agrupar archivos por clase
    files_by_class = {}
    for file in processed_files:
        class_name = file['class']
        if class_name not in files_by_class:
            files_by_class[class_name] = []
        files_by_class[class_name].append(file)
    
    train_files = []
    val_files = []
    
    # Dividir los archivos de cada clase manteniendo la proporción
    for class_name, files in files_by_class.items():
        random.shuffle(files)  # Mezclar aleatoriamente los archivos de cada clase
        split_idx = int(len(files) * (1 - val_split))
        
        # Dividir los archivos de esta clase
        train_files.extend(files[:split_idx])
        val_files.extend(files[split_idx:])
        
        logger.print(f"- Clase {class_name}: {len(files[:split_idx])} train, {len(files[split_idx:])} val")
    
    # Mezclar aleatoriamente los conjuntos finales
    random.shuffle(train_files)
    random.shuffle(val_files)
    
    logger.print(f"División completada: {len(train_files)} train, {len(val_files)} val")
    return train_files, val_files

def main(image_path: str, output_path: str, classes_file: str, val_split: float = 0.2, debug: bool = False) -> Dict:    
    """
    Función principal que procesa las imágenes, genera etiquetas y prepara los datos para YOLOv5.
    """
    logger = Logger(debug)
    try:
        logger.print("\n=== Iniciando preparación de datos para YOLOv5 ===")
        
        # Convertir rutas a objetos Path
        image_path = Path(image_path)
        output_path = Path(output_path)
        classes_file = Path(classes_file)
        
        # Validar rutas
        valid, message = validate_paths(str(image_path), str(output_path), str(classes_file), logger)
        if not valid:
            return message
        
        # Cargar clases
        valid, class_mapping = load_classes(str(classes_file), logger)
        if not valid:
            return class_mapping
        
        results = {
            "success": True,
            "errors": [],
            "stats": {
                "train": {
                    "total": 0,
                    "by_class": {},
                },
                "val": {
                    "total": 0,
                    "by_class": {},
                }
            }
        }
        
        processed_files = []  # Lista temporal para split
        class_counters = {}  # Contador por clase
        
        # Procesar cada carpeta de clase
        logger.print("\nProcesando imágenes por clase...")
        for folder_name, original_name in class_mapping.items():
            class_idx = list(class_mapping.keys()).index(folder_name)
            class_path = image_path / folder_name
            
            if not class_path.exists():
                results["errors"].append({
                    "class": original_name,
                    "folder": str(folder_name),
                    "error": "Carpeta de clase no encontrada"
                })
                logger.print(f"- Advertencia: Carpeta no encontrada para clase {original_name}")
                continue
                
            logger.print(f"- Procesando clase: {original_name}")
            class_counters[original_name] = 0
            
            # Procesar cada imagen en la carpeta
            for img_file in class_path.glob('*.[pjJ][pnNjJ][gG]*'):
                if img_file.suffix.lower() in ['.png', '.jpg', '.jpeg']:
                    # Procesar imagen
                    success, data = process_image(str(img_file), class_idx)
                    
                    if success:
                        label_content = f"{data['class_idx']} {data['x_center']} {data['y_center']} {data['width']} {data['height']}"
                        processed_files.append({
                            "image": img_file.name,
                            "image_path": str(img_file),
                            "class": original_name,
                            "class_idx": class_idx,
                            "label_content": label_content
                        })
                        class_counters[original_name] += 1
                    else:
                        results["errors"].append({
                            "image": img_file.name,
                            "class": original_name,
                            "error": data["error"]
                        })

        results["stats"]["total_images"] = sum(class_counters.values())
        results["stats"]["images_by_class"] = class_counters

        if not processed_files:
            return {
                "success": False,
                "error": "No se encontraron imágenes para procesar"
            }
        
        # Dividir datos en train y val
        logger.print("\nDividiendo datos...")
        train_files, val_files = split_data(processed_files, val_split, logger)
        
        # Copiar archivos a sus respectivos directorios
        logger.print("\nGuardando archivos...")
        for dataset, files in [("train", train_files), ("val", val_files)]:
            dataset_counters = {}
            logger.print(f"- Procesando conjunto {dataset}...")

            for file_info in files:
                success, error = process_and_save_files(file_info, str(output_path), dataset)
                
                if success:
                    # Actualizar estadísticas
                    class_name = file_info["class"]
                    if class_name not in dataset_counters:
                        dataset_counters[class_name] = 0
                    dataset_counters[class_name] += 1
                    results["stats"][dataset]["total"] += 1
                else:
                    results["errors"].append(error)
            
            # Actualizar estadísticas del dataset
            results["stats"][dataset]["by_class"] = dataset_counters
        
        logger.print("\nFinalizando...")
        
        # Generar data.yaml
        yaml_result = create_yaml(str(output_path), list(class_mapping.values()), logger)

        if not yaml_result["success"]:
            results["errors"].append(yaml_result)
        else:
            results["yaml"] = yaml_result
        
        results["summary"] = {
            "total_processed": results["stats"]["total_images"],
            "train_total": results["stats"]["train"]["total"],
            "val_total": results["stats"]["val"]["total"],
            "errors_count": len(results["errors"]),
            "processing_success_rate": (results["stats"]["total_images"] - len(results["errors"])) / results["stats"]["total_images"] * 100 if results["stats"]["total_images"] > 0 else 0
        }
        logger.print("\n=== Procesamiento completado ===")
        return results

    except Exception as e:
        return {
            "success": False,
            "error": f"Error general en el procesamiento: {str(e)}"
        }

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Prepara datos para entrenamiento de YOLOv5')

    parser.add_argument('--images', required=True, 
                       help='Ruta a la carpeta que contiene las carpetas de clases con imágenes')
    parser.add_argument('--output', required=True, 
                       help='Ruta donde se guardarán los datos preparados')
    parser.add_argument('--classes', required=True, 
                       help='Ruta al archivo JSON con la lista de clases')
    parser.add_argument('--val-split', type=float, default=0.2, 
                       help='Proporción de datos para validación (default: 0.2)')
    parser.add_argument('--debug', action='store_true',
                       help='Activa los mensajes de depuración')
    
    args = parser.parse_args()

    if args.debug:
        print("Argumentos recibidos:", args)
    
    result = main(
        image_path=args.images,
        output_path=args.output,
        classes_file=args.classes,
        val_split=args.val_split,
        debug=args.debug
    )
    
    # Siempre mostrar el resultado final en JSON
    print(json.dumps(result, indent=2, ensure_ascii=False))