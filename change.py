import os

# Especifica la ruta de la carpeta que contiene los archivos txt
ruta_carpeta = r"C:\Users\LEENH\Desktop\DATA PLAGAS\gusano-enrollador-de-la-hoja"

# Itera sobre todos los archivos en la carpeta
for nombre_archivo in os.listdir(ruta_carpeta):
    # Verifica si el archivo tiene una extensión .txt
    if nombre_archivo.endswith(".txt"):
        ruta_archivo = os.path.join(ruta_carpeta, nombre_archivo)
        
        # Lee el contenido del archivo
        with open(ruta_archivo, "r") as archivo:
            lineas = archivo.readlines()
        
        # Modifica cada línea del archivo
        lineas_modificadas = []
        for linea in lineas:
            valores = linea.split()
            valores[0] = "3"  # Cambia el primer valor a "3"
            linea_modificada = " ".join(valores) + "\n"
            lineas_modificadas.append(linea_modificada)
        
        # Escribe las líneas modificadas de vuelta al archivo
        with open(ruta_archivo, "w") as archivo:
            archivo.writelines(lineas_modificadas)

print("Modificación completada.")