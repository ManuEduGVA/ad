import os
from mistralai import Mistral

# Configuración del cliente de Mistral
api_key = os.getenv("MISTRAL_API_KEY", "<<AQUI TU API KEY>>")
model = "mistral-large-latest"

client = Mistral(api_key=api_key)

def LLM_response(ingredientes):
    """
    Genera una receta utilizando Mistral AI basándose en los ingredientes proporcionados
    
    Args:
        ingredientes (str): Texto con los ingredientes para la receta
        
    Returns:
        str: Receta generada por el modelo o mensaje de error
    """
    
    # Plantilla de prompt para el chef
    prompt_template = f"""Eres un chef profesional de un restaurante con estrella Michelin llamado Simarret. 
Tu tarea es crear una receta sofisticada y detallada utilizando ÚNICAMENTE los ingredientes que se te proporcionen.

Ingredientes proporcionados: {ingredientes}

Instrucciones:
- Si encuentras ingredientes válidos en el texto, crea una receta completa y detallada.
- La receta debe incluir: nombre del plato, tiempo de preparación, porciones, ingredientes con cantidades, pasos detallados de preparación y consejos del chef.
- Sé creativo pero realista con las combinaciones de ingredientes.
- Si NO encuentras ingredientes válidos o reconocibles en el texto, responde educadamente: "Disculpe, pero no encuentro ingredientes suficientes o válidos para elaborar una receta. Por favor, proporcione ingredientes específicos como verduras, carnes, pescados, especias, etc."
- Mantén siempre un tono educado y profesional, como corresponde a un chef de alto nivel.

Genera la receta:"""

    try:
        # Realizar la llamada a la API de Mistral
        chat_response = client.chat.complete(
            model=model,
            messages=[
                {
                    "role": "user",
                    "content": prompt_template,
                },
            ]
        )
        
        # Extraer y devolver la respuesta
        return chat_response.choices[0].message.content
        
    except Exception as e:
        return f"Lo siento, ha ocurrido un error al generar la receta: {str(e)}. Por favor, inténtelo de nuevo."

# Comentar cuando ya tengamos la aplicación hecha para evitar redundancia
'''if __name__=="__main__":
    print(">>>>>>>>> Prueba con ingredientes válidos:")
    test_ingredientes = "pollo, limón, ajo, romero, aceite de oliva"
    receta = LLM_response(test_ingredientes)
    print(receta)
    
    print(">>>>>>>>> Prueba sin ingredientes:")
    test_sin_ingredientes = "hola que tal"
    receta2 = LLM_response(test_sin_ingredientes)
    print(receta2) '''