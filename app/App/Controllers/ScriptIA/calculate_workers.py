import multiprocessing
import psutil

def calculate_optimal_workers():
    try:
        # Obtener número de núcleos CPU
        cpu_count = multiprocessing.cpu_count()
        
        # Obtener memoria RAM disponible (en GB)
        available_ram = psutil.virtual_memory().available / (1024 * 1024 * 1024)
        
        # Estimar memoria necesaria por worker (ajustar según tu caso)
        estimated_ram_per_worker = 2  # GB
        
        # Calcular workers basado en CPU y RAM
        workers_by_cpu = cpu_count - 1  # Dejar un núcleo libre
        workers_by_ram = int(available_ram / estimated_ram_per_worker)
        
        # Tomar el mínimo entre ambos límites
        optimal_workers = min(workers_by_cpu, workers_by_ram)
        
        # Establecer límites mínimo y máximo
        optimal_workers = max(1, min(optimal_workers, 16))
        
        return optimal_workers
    except Exception as e:
        return 1

def calculate_patience(epochs: int) -> int:
    """
    Calcula el valor de patience basado en el número total de épocas.
    
    Args:
        epochs (int): Número total de épocas de entrenamiento
        
    Returns:
        int: Valor de patience calculado
    """
    try:
        # Validar entrada
        if epochs <= 0:
            raise ValueError("El número de épocas debe ser positivo")
            
        # Calcular patience como 20% del total de épocas
        patience = int(epochs * 0.2)
        
        # Establecer límites
        min_patience = 5
        max_patience = 50
        
        # Ajustar dentro de los límites
        patience = max(min_patience, min(patience, max_patience))
        
        return patience
        
    except Exception as e:
        return 15  # Valor por defecto seguro