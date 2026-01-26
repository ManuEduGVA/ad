package com.cipfpcheste.dam2.chatbot.service.controller;

import com.cipfpcheste.dam2.chatbot.service.GroqAIService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api/v1")
public class GroqAIController {

    private final GroqAIService groqService;

    public GroqAIController(GroqAIService groqService) {
        this.groqService = groqService;
    }

    @GetMapping("/getPresentacionAlUsuario")
    public String getPresentacionAlUsuario() {
        return groqService.getPresentacionAlUsuario("Simarret");
    }

    @GetMapping("/getChisteTematico")
    public String getChisteTematico(@RequestParam String tema) {
        return groqService.getChisteTematico(tema);
    }
}
