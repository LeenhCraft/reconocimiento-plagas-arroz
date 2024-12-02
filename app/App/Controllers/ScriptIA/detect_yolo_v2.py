#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import sys
import os
import json
import logging
import torch
import yaml
from datetime import datetime
from pathlib import Path
import cv2
import numpy as np
from PIL import Image
import imghdr
import traceback

def dep(data, exit=True):
    print(data)
    if exit:
        sys.exit()

def setup_logging(output_dir, name):
    """Configura el sistema de logging"""
    log_file = os.path.join(output_dir, f'{name}_detection.log')
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_file)
        ]
    )
    return logging.getLogger(__name__)

def validate_image(image_path, max_size_mb=10):
    """
    Valida la imagen de entrada
    
    Args:
        image_path: Ruta a la imagen
        max_size_mb: Tamaño máximo permitido en MB
    
    Returns:
        tuple: (bool, str) - (es_válido, mensaje_error)
    """
    try:
        # Verificar si el archivo existe
        if not os.path.exists(image_path):
            return False, "El archivo no existe"
        
        # Verificar el tamaño del archivo
        file_size = os.path.getsize(image_path) / (1024 * 1024)  # Convertir a MB
        if file_size > max_size_mb:
            return False, f"El archivo excede el tamaño máximo permitido de {max_size_mb}MB"
        
        # Verificar que es una imagen válida
        is_valid, message = is_valid_image(image_path)
        if not is_valid:
            return False, f"Archivo inválido: {message}"
        
        return True, "Imagen válida"
    except Exception as e:
        return False, f"Error validando imagen: {str(e)}"

def load_model(weights_path, data_yaml_path):
    """
    Carga el modelo YOLO y la configuración
    """
    try:
        # Cargar la configuración del modelo
        with open(data_yaml_path, 'r') as f:
            data_yaml = yaml.safe_load(f)
        
        # Cargar el modelo
        model = torch.hub.load('ultralytics/yolov5', 'custom', 
                             path=weights_path, force_reload=True)
        
        return model, data_yaml.get('names', []), None
    except Exception as e:
        error_msg = f"Error cargando el modelo: {str(e)}\n{traceback.format_exc()}"
        return None, None, error_msg


def run_detection(image_path, output_dir, weights_path, data_yaml_path, conf_thres=0.25, name='det'):
    """
    Ejecuta la detección de objetos
    
    Args:
        image_path: Ruta a la imagen de entrada
        output_dir: Directorio base de salida
        weights_path: Ruta a los pesos del modelo
        data_yaml_path: Ruta al archivo de configuración
        conf_thres: Umbral de confianza para detecciones
        name: Nombre del experimento
    """
    try:
        # Crear directorio específico para este experimento
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        experiment_dir = os.path.join(output_dir, f"{name}_{timestamp}")
        os.makedirs(experiment_dir, exist_ok=True)
        
        # Configurar logging
        logger = setup_logging(experiment_dir, name)
        logger.info(f"Iniciando experimento de detección: {name}")
        logger.info(f"Procesando imagen: {image_path}")
        
        # Validar imagen
        is_valid, validation_msg = validate_image(image_path)
        if not is_valid:
            logger.error(validation_msg)
            return {"error": validation_msg}
        
        # Cargar modelo
        logger.info("Cargando modelo...")
        model, class_names, error_msg = load_model(weights_path, data_yaml_path)
        if error_msg:
            logger.error(error_msg)
            return {"error": error_msg}
        
        # Configurar modelo
        model.conf = conf_thres
        
        # Realizar detección
        logger.info("Ejecutando detección...")
        results = model(image_path)
        
        # Procesar resultados
        detections = []
        for pred in results.pred[0]:
            x1, y1, x2, y2, conf, cls = pred.cpu().numpy()
            detection = {
                "class": class_names[int(cls)],
                "confidence": float(conf),
                "bbox": {
                    "x1": int(x1),
                    "y1": int(y1),
                    "x2": int(x2),
                    "y2": int(y2)
                }
            }
            detections.append(detection)
        
        # Guardar imagen con detecciones
        results.save(experiment_dir)
        
        # Preparar resultado
        output = {
            "success": True,
            "experiment_name": name,
            "image_path": image_path,
            "output_dir": experiment_dir,
            "detections": detections,
            "timestamp": datetime.now().isoformat(),
            "time_detected": results.imgs[0].shape[:2],
            "model_info": {
                "weights": weights_path,
                "conf_threshold": conf_thres
            },
            "summary": {
                "total_detections": len(detections),
                "classes_detected": {},
                "average_confidence": 0
            }
        }
        
        # Calcular estadísticas
        if detections:
            confidence_sum = sum(d["confidence"] for d in detections)
            output["summary"]["average_confidence"] = confidence_sum / len(detections)
            
            for det in detections:
                cls = det["class"]
                output["summary"]["classes_detected"][cls] = output["summary"]["classes_detected"].get(cls, 0) + 1
        
        # Guardar resultados en JSON
        results_file = os.path.join(experiment_dir, f'{name}_detection_results.json')
        with open(results_file, 'w') as f:
            json.dump(output, f, indent=4)
        
        logger.info(f"Detección completada exitosamente para experimento {name}")
        return output
        
    except Exception as e:
        error_msg = f"Error durante la detección: {str(e)}\n{traceback.format_exc()}"
        logger.error(error_msg)
        return {"error": error_msg}
    
def main():
    parser = argparse.ArgumentParser(description='YOLO Object Detection Script')
    parser.add_argument('--image', required=True, help='Ruta a la imagen de entrada')
    parser.add_argument('--output', required=True, help='Directorio de salida')
    parser.add_argument('--weights', required=True, help='Ruta a los pesos del modelo')
    parser.add_argument('--data', required=True, help='Ruta al archivo data.yaml')
    parser.add_argument('--conf', type=float, default=0.25, help='Umbral de confianza')
    parser.add_argument('--format', choices=['json', 'both'], default='json',
                       help='Formato de salida: solo JSON o JSON con logs')
    parser.add_argument('--name', type=str, default='det',
                       help='Nombre del experimento de detección (default: det)')
    
    args = parser.parse_args()
    
    # Crear directorio de salida base si no existe
    os.makedirs(args.output, exist_ok=True)
    
    try:
        # Ejecutar detección
        result = run_detection(
            args.image,
            args.output,
            args.weights,
            args.data,
            args.conf,
            args.name
        )
        
        if args.format == 'both':
            # Leer el archivo de log
            log_file = os.path.join(args.output, f'{args.name}_detection.log')
            with open(log_file, 'r') as f:
                logs = f.readlines()
            
            # Crear estructura de salida combinada
            output = {
                'experiment_name': args.name,
                'logs': logs,
                'result': result
            }
        else:
            output = result
        
        # Imprimir resultado en formato JSON
        print(json.dumps(output, indent=4))
        
    except Exception as e:
        error_output = {
            'error': str(e),
            'traceback': traceback.format_exc()
        }
        print(json.dumps(error_output, indent=4), file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()