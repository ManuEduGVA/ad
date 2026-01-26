from utilities_chef import LLM_response
from flask import Flask, render_template, request
import markdown

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('home.html', val='')

@app.route('/generar_receta', methods=['POST'])
def generate_recipe():
    if request.method == 'POST':
        ingredientes = request.form.get('INGREDIENTES', '').strip()
        
        # Comprobamos que tenemos los datos necesarios
        if not ingredientes or ingredientes == '':
            return render_template('home.html', 
                val='Por favor, introduce los ingredientes para generar una receta.')
        
        # Solicitamos la generación de receta a Mistral AI
        try:
            receta_generada = LLM_response(ingredientes)
            
            # Temporalmente mostramos por consola la receta
            print("=" * 50)
            print("RECETA GENERADA:")
            print(receta_generada)
            print("=" * 50)
            
            # Convertir markdown a HTML
            receta_html = markdown.markdown(
                receta_generada,
                extensions=['extra', 'nl2br', 'sane_lists']
            )
            
            # Mostrar html con el resultado
            return render_template('home.html',
                ingredientes_input=ingredientes,
                val=receta_html)
                
        except Exception as e:
            return render_template('home.html',
                val=f'Error al generar la receta: {str(e)}. Por favor, inténtalo de nuevo.')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)