package org.cipfpcheste.dam2.chefai.service;


import org.cipfpcheste.dam2.chefai.modelo.RecetaRequest;
import org.cipfpcheste.dam2.chefai.modelo.RecetaResponse;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.stereotype.Service;

@Service
public class RecetaService {

    private final ChatClient chatClient;

    public RecetaService(ChatClient.Builder chatClientBuilder) {
        this.chatClient = chatClientBuilder.build();
    }

    public RecetaResponse generateRecipe(RecetaRequest request) {
        validateRequest(request);

        String prompt = createRecipePrompt(request);

        System.out.println("*** INICIANDO ASISTENTE DE COCINA ***");
        System.out.println("Ingredientes: " + request.getIngredientes());
        System.out.println("Tipo de comida: " + request.getTipoComida());
        System.out.println("Objetivo saludable: " + request.getObjetivoDieta());

        try {
            // Usar solo el modelo llama-3.3-70b-versatile
            OpenAiChatOptions requestOptions = OpenAiChatOptions.builder()
                    .model("llama-3.3-70b-versatile")
                    .temperature(0.5d)
                    .topP(0.7d)
                    .maxTokens(1000)
                    .build();

            System.out.println("Enviando solicitud a Groq API con llama-3.3-70b-versatile ...");

            String recipeText = chatClient.prompt()
                    .user(prompt)
                    .options(requestOptions)
                    .call()
                    .content();

            System.out.println("Respuesta recibida: " + recipeText);

            // Limpiar la receta generada
            recipeText = cleanRecipeText(recipeText);

            System.out.println("Receta limpia: " + recipeText);

            return new RecetaResponse(
                    request.getIngredientes(),
                    recipeText,
                    request.getTipoComida(),
                    request.getObjetivoDieta()
            );

        } catch (Exception e) {
            System.err.println("Error en el servicio de cocina: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error al generar la receta: " + e.getMessage());
        }
    }

    private String createRecipePrompt(RecetaRequest request) {
        return String.format(
                "Eres un asistente de cocina saludable. Con los ingredientes proporcionados, " +
                        "crea una receta saludable y fácil de seguir. " +
                        "Incluye: nombre del plato, lista de ingredientes (con cantidades aproximadas), " +
                        "pasos numerados y un consejo saludable final. " +
                        "Tipo de comida: %s. Objetivo saludable: %s. " +
                        "Devuelve SOLO la receta, sin introducciones ni notas adicionales.\n\nIngredientes: %s",
                request.getTipoComida(),
                request.getObjetivoDieta(),
                request.getIngredientes()
        );
    }

    private String cleanRecipeText(String text) {
        if (text == null) return "";

        text = text.trim();

        // Remover comillas al inicio y final si existen
        if (text.startsWith("\"") && text.endsWith("\"")) {
            text = text.substring(1, text.length() - 1).trim();
        }
        if (text.startsWith("'") && text.endsWith("'")) {
            text = text.substring(1, text.length() - 1).trim();
        }

        return text;
    }

    private void validateRequest(RecetaRequest request) {
        if (request.getIngredientes() == null || request.getIngredientes().trim().isEmpty()) {
            throw new IllegalArgumentException("Los ingredientes no pueden estar vacíos");
        }
        if (request.getTipoComida() == null || request.getTipoComida().trim().isEmpty()) {
            throw new IllegalArgumentException("El tipo de comida no puede estar vacío");
        }
        if (request.getObjetivoDieta() == null || request.getObjetivoDieta().trim().isEmpty()) {
            throw new IllegalArgumentException("El objetivo saludable no puede estar vacío");
        }
        if (request.getIngredientes().length() > 2000) {
            throw new IllegalArgumentException("Los ingredientes no pueden exceder los 2000 caracteres");
        }
    }
}
