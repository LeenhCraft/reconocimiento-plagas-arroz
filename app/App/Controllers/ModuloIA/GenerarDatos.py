import os
import json
import sys
import yaml
from pathlib import Path

class YOLOConfigGenerator:
    def __init__(self, count_file, output_path, dataset_name, train_ratio=0.8):
        """
        Inicializa el generador de configuración YOLO
        
        Args:
            count_file (str): Ruta al archivo .txt con el conteo de clases
            output_path (str): Ruta donde se guardará la configuración
            dataset_name (str): Nombre para el dataset
            train_ratio (float): Proporción de imágenes para entrenamiento (0.0 a 1.0)
        """
        if not 0 < train_ratio < 1:
            raise ValueError("El ratio de entrenamiento debe estar entre 0 y 1")
            
        self.count_file = Path(count_file)
        self.output_path = Path(output_path)
        self.dataset_name = dataset_name
        self.train_ratio = train_ratio
        self.valid_ratio = 1 - train_ratio
        self.class_stats = {}
        self.class_mapping = {}

    def read_count_file(self):
        """Lee y procesa el archivo de conteo"""
        try:
            with open(self.count_file, 'r', encoding='utf-8') as f:
                content = f.read().strip()
            
            content = content.strip('[]')
            entries = [entry.strip().strip('"\'') for entry in content.split(',')]
            
            total_images = 0
            for idx, entry in enumerate(entries):
                count, class_name = entry.split('=')
                count = int(count.strip())
                class_name = class_name.strip().strip('"\'')
                
                self.class_mapping[idx] = class_name
                train_count = int(count * self.train_ratio)
                valid_count = count - train_count
                
                self.class_stats[class_name] = {
                    "total": count,
                    "train": train_count,
                    "valid": valid_count
                }
                total_images += count

            return True, total_images
            
        except Exception as e:
            raise Exception(f"Error al leer el archivo de conteo: {str(e)}")

    def create_yaml_config(self):
        """Crea el archivo de configuración YAML para YOLO"""
        self.output_path.mkdir(parents=True, exist_ok=True)
        
        yaml_path = self.output_path / f"{self.dataset_name}.yaml"
        
        config = {
            'path': str(self.output_path.absolute()),
            'train': 'train/images',
            'val': 'valid/images',
            'nc': len(self.class_mapping),
            'names': self.class_mapping
        }

        with open(yaml_path, 'w', encoding='utf-8') as f:
            yaml.safe_dump(config, f, sort_keys=False)

        # Crear directorios
        for subset in ['train', 'valid']:
            for subdir in ['images', 'labels']:
                (self.output_path / subset / subdir).mkdir(parents=True, exist_ok=True)

        return str(yaml_path)

def main():
    if len(sys.argv) not in [4, 5]:
        print(json.dumps({
            "status": False,
            "message": "Uso: script.py <archivo_conteo.txt> <ruta_salida> <nombre_dataset> [ratio_train]",
            "data": None
        }))
        sys.exit(1)

    try:
        train_ratio = float(sys.argv[4]) if len(sys.argv) == 5 else 0.8
        
        generator = YOLOConfigGenerator(
            count_file=sys.argv[1],
            output_path=sys.argv[2],
            dataset_name=sys.argv[3],
            train_ratio=train_ratio
        )
        
        # Leer archivo y obtener total de imágenes
        success, total_images = generator.read_count_file()
        
        # Generar configuración
        yaml_path = generator.create_yaml_config()
        
        # Calcular totales
        total_train = int(total_images * train_ratio)
        total_valid = total_images - total_train
        
        # Preparar respuesta simplificada
        response = {
            "status": True,
            "message": "Configuración YOLO generada exitosamente",
            "data": {
                "yaml_path": yaml_path,
                "dataset_name": generator.dataset_name,
                "total_classes": len(generator.class_mapping),
                "ratio": {
                    "train": train_ratio,
                    "valid": 1 - train_ratio
                },
                "totals": {
                    "images": total_images,
                    "train": total_train,
                    "valid": total_valid
                },
                "directories": {
                    "train_images": str(generator.output_path / 'train' / 'images'),
                    "train_labels": str(generator.output_path / 'train' / 'labels'),
                    "valid_images": str(generator.output_path / 'valid' / 'images'),
                    "valid_labels": str(generator.output_path / 'valid' / 'labels')
                }
            }
        }
        
        print(json.dumps(response))
        
    except Exception as e:
        print(json.dumps({
            "status": False,
            "message": f"Error: {str(e)}",
            "data": None
        }))
        sys.exit(1)

if __name__ == "__main__":
    main()