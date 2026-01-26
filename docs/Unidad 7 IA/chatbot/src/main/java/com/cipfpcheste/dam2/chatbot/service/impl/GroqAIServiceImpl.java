package com.cipfpcheste.dam2.chatbot.service.impl;


import com.cipfpcheste.dam2.chatbot.service.GroqAIService;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.chat.prompt.PromptTemplate;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

/**
 * Clase de servicio para interactuar con un modelo de chat y generar respuestas basadas en prompts.
 * Este servicio está diseñado para proporcionar una experiencia de chatbot con la capacidad de
 * presentarse y contar chistes temáticos de manera sensible y amigable para el usuario.
 */
@Service
public class GroqAIServiceImpl implements GroqAIService {

    private final ChatModel chatModel;

    /**
     * Construye una nueva instancia de GroqAIService con el modelo de chat especificado.
     *
     * @param chatModel el modelo de chat que se utilizará para generar respuestas
     */
    public GroqAIServiceImpl(ChatModel chatModel) {
        this.chatModel = chatModel;
    }
    // Definir el nombre del modelo de Groq (LLM) que utilizaremos
    private final String modelName = "llama-3.3-70b-versatile";
    //Definir el límite de tokens de respuesta para el modelo llama-3.3-70b-versatile
    private final String maxTokens = "32768";

    /**
     * Configura y devuelve las opciones para el modelo de chat Groq AI.
     *
     * Este método crea un objeto OpenAiChatOptions con configuraciones predefinidas:
     * - Utiliza el modelo especificado en modelName
     * - Establece la temperatura en 0.4 para equilibrar creatividad/consistencia
     * - Establece el máximo de tokens basado en la configuración maxTokens
     *
     * @return OpenAiChatOptions objeto configurado con los parámetros especificados
     */
    private OpenAiChatOptions getOptions() {
        OpenAiChatOptions options = OpenAiChatOptions.builder()
                .model(modelName)
                .temperature(0.4)
                .maxTokens(Integer.parseInt(maxTokens))
                .build();
        return options;
    }

    /**
     * Genera una respuesta utilizando el modelo de chat basado en el prompt proporcionado.
     *
     * @param prompt El objeto prompt que contiene el mensaje de entrada para generar una respuesta
     * @return La respuesta generada como texto en formato String
     * @throws RuntimeException si el modelo de chat falla al generar una respuesta
     */

    private String generateResponse(Prompt prompt) {
        ChatResponse response = chatModel.call(prompt);
        return response.getResult().getOutput().getText();
    }

    /**
     * Genera una respuesta de presentación personalizada para el usuario.
     *
     * @param nombre El nombre del usuario que se incluirá en la presentación
     * @return Un String que contiene la respuesta de presentación generada por la IA
     */

    @Override
    public String getPresentacionAlUsuario(String nombre) {
        return generateResponse(getPromptPresentacionAlUsuario(nombre));
    }

    /**
     * Genera una respuesta con un chiste sobre la temática especificada.
     *
     * @param tema La temática sobre la cual se generará el chiste
     * @return Un String que contiene el chiste generado por la IA
     */
    @Override
    public String getChisteTematico(String tema) {
        return generateResponse(getPromptChisteTematico(tema));
    }

    /**
     * Crea un prompt para la interacción inicial con el usuario, configurando un chatbot de IA
     * que se especializa en contar chistes.
     *
     * El método configura una plantilla de prompt que presenta al chatbot con un nombre dado
     * y lo prepara para contar chistes sobre cualquier tema solicitado por el usuario.
     *
     * @param nombre El nombre que se usará para el chatbot en la interacción
     * @return Prompt Un objeto prompt configurado que contiene el mensaje y las opciones de chat OpenAI
     */

    private Prompt getPromptPresentacionAlUsuario(String nombre) {
        // 1. Crear plantilla de prompt con variables
        PromptTemplate promptTemplate = new PromptTemplate(
                """
                    Por favor, actúa como chatBot de inteligencia artificial llamado '{nombre}'
                    que siempre tiene ingenio para contar chistes sobre cualquier temática.
                    No hace falta que hagas una introducción, simplemente preséntate y pregunta 
                    sobre qué temática le gustaría al usuario que le contaras un chiste en una 
                    frase no demasiado larga.
                    Por favor, ten cuidado y sé sensible respecto al contenido.
                """
        );
        // 2. Reemplazar variables en el prompt
        Message message = promptTemplate.createMessage(
                Map.of("nombre", nombre)
        );
        // 3. Leer las opciones del modelo
        OpenAiChatOptions options = getOptions();
        // 4. Crear Prompt combinando mensaje y opciones
        return new Prompt(List.of(message), options);
    }

    /**
     * Crea un prompt para generar un chiste sobre una temática específica.
     *
     * El método configura una plantilla de prompt que solicita al modelo
     * generar un chiste apropiado sobre el tema proporcionado, asegurando
     * que el contenido sea adecuado y sensible.
     *
     * @param tema La temática sobre la cual se generará el chiste
     * @return Prompt Un objeto prompt configurado con el mensaje y las opciones de chat
     */
    private Prompt getPromptChisteTematico(String tema) {
        // 1. Crear plantilla de prompt con variables
        PromptTemplate promptTemplate = new PromptTemplate(
                """
                    Vas a actuar como una persona graciosa y contarme un chiste sobre la temática 
                    '{tema}' teniendo en cuenta lo siguiente:
                    · Si crees que la temática es sobre un tema controvertido que puede ofender a alguien,
                    por favor, cambia la temática a algo más seguro lo más parecido posible a la temática original,
                    pero no digas que has cambiado de temática.
                    · No empieces diciendo la temática del chiste ni cuál es tu intención al contarlo, simplemente 
                    cuenta el chiste de una manera graciosa y divertida sin ser demasiado escueto ni demasiado largo.
                    · El chiste debe ser adecuado para un público general pensando que lo está contando un 
                    profesor a sus alumnos. Por favor, ten cuidado y sé sensible respecto al contenido.
                    · Por último, acaba preguntando al usuario de manera divertida y sobre todo escueta sobre qué 
                    otra temática le gustaría que le contaras un chiste.
                """
        );
        // 2. Reemplazar variables en el prompt
        Message message = promptTemplate.createMessage(
                Map.of("tema", tema)
        );
        // 3. Leer las opciones del modelo
        OpenAiChatOptions options = getOptions();
        // 4. Crear Prompt combinando mensaje y opciones
        return new Prompt(List.of(message), options);
    }
}