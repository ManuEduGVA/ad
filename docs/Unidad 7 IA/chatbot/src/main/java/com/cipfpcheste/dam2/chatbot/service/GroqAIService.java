package com.cipfpcheste.dam2.chatbot.service;

public interface GroqAIService {    /**
 * Genera una respuesta de presentación personalizada para el usuario.
 *
 * @param nombre El nombre del usuario que se incluirá en la presentación
 * @return Un String que contiene la respuesta de presentación generada por la IA
 */

String getPresentacionAlUsuario(String nombre);

    /**
     * Genera una respuesta con un chiste sobre la temática especificada.
     *
     * @param tema La temática sobre la cual se generará el chiste
     * @return Un String que contiene el chiste generado por la IA
     */
    String getChisteTematico(String tema);

}
