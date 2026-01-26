package com.cipfpcheste.dam2.chatbot.service.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class FrontendController {
    // Este controlador maneja la ruta raíz y devuelve la vista index.html
    @GetMapping("/")
    public String index(Model model) {
        // Aquí puedes agregar datos al modelo si fuera necesario
        return "index"; // Renderiza index.html
    }
}
