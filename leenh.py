# Importación de bibliotecas necesarias
import os  # Proporciona funciones para interactuar con el sistema operativo
import shutil  # Proporciona funciones para operaciones de alto nivel con archivos

# Definición de rutas de directorios
# Ruta donde se encuentran los archivos de etiquetas correctos/originales
label_ok_path = r"C:\Users\LEENH\Desktop\DATA PLAGAS\labels"
# Ruta de la carpeta de entrenamiento donde se copiarán las etiquetas
train_path = r"C:\laragon\www\plagas-arroz\public_html\datos_entrenamiento\20241208232110\train\labels"
# Ruta de la carpeta de validación donde se copiarán las etiquetas
val_path = r"C:\laragon\www\plagas-arroz\public_html\datos_entrenamiento\20241208232110\val\labels"

def replace_files():
    # Contadores para seguimiento
    replaced_count = 0  # Contador de archivos reemplazados exitosamente
    not_found_count = 0  # Contador de archivos no encontrados
    
    # Procesamiento de archivos en la carpeta de entrenamiento (train)
    print("Procesando carpeta train...")
    # Obtiene lista de archivos .txt en la carpeta train
    train_files = [f for f in os.listdir(train_path) if f.endswith('.txt')]
    
    # Itera sobre cada archivo en la carpeta train
    for file in train_files:
        # Construye la ruta completa del archivo fuente
        source_file = os.path.join(label_ok_path, file)
        # Verifica si el archivo existe en la carpeta de etiquetas correctas
        if os.path.exists(source_file):
            # Construye la ruta de destino
            dest_file = os.path.join(train_path, file)
            # Copia el archivo manteniendo los metadatos
            shutil.copy2(source_file, dest_file)
            replaced_count += 1
            print(f"Reemplazado: {file}")
        else:
            not_found_count += 1
            print(f"No encontrado en label_ok: {file}")
    
    # Procesamiento de archivos en la carpeta de validación (val)
    print("\nProcesando carpeta val...")
    # Obtiene lista de archivos .txt en la carpeta val
    val_files = [f for f in os.listdir(val_path) if f.endswith('.txt')]
    
    # Itera sobre cada archivo en la carpeta val
    for file in val_files:
        # Construye la ruta completa del archivo fuente
        source_file = os.path.join(label_ok_path, file)
        # Verifica si el archivo existe en la carpeta de etiquetas correctas
        if os.path.exists(source_file):
            # Construye la ruta de destino
            dest_file = os.path.join(val_path, file)
            # Copia el archivo manteniendo los metadatos
            shutil.copy2(source_file, dest_file)
            replaced_count += 1
            print(f"Reemplazado: {file}")
        else:
            not_found_count += 1
            print(f"No encontrado en label_ok: {file}")
    
    # Impresión del resumen de operaciones
    print("\n=== Resumen ===")
    print(f"Total de archivos en train: {len(train_files)}")
    print(f"Total de archivos en val: {len(val_files)}")
    print(f"Total de archivos reemplazados: {replaced_count}")
    print(f"Archivos no encontrados en label_ok: {not_found_count}")

# Punto de entrada del script
if __name__ == "__main__":
    replace_files()