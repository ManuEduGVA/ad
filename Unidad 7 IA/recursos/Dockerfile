# Configuramos la imagen oficial de Python 3.11.2
FROM python:3.11.2

# Copia el archivo requirements.txt al directorio de trabajo en el contenedor
COPY requirements.txt .
# Instala las dependencias listadas en requirements.txt usando pip
RUN pip install -r requirements.txt
# Copia todos los archivos del directorio actual al directorio de trabajo en el contenedor
COPY . .
# Expone el puerto 5000 para que pueda ser accedido externamente
EXPOSE 5000
# Comando a ejecutar cuando se inicie el contenedor, inicia la aplicación Flask
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
