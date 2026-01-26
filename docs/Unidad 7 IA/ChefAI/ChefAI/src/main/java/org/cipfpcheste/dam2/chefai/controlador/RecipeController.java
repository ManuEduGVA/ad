package org.cipfpcheste.dam2.chefai.controlador;


import org.cipfpcheste.dam2.chefai.modelo.RecetaRequest;
import org.cipfpcheste.dam2.chefai.modelo.RecetaResponse;
import org.cipfpcheste.dam2.chefai.service.RecetaService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class RecipeController {

    private final RecetaService recetaService;

    public RecipeController(RecetaService recetaService) {
        this.recetaService = recetaService;
    }

    @GetMapping("/")
    public String showHomePage(Model model) {
        model.addAttribute("recetaRequest", new RecetaRequest());
        model.addAttribute("recetaResponse", new RecetaResponse());
        return "index";
    }

    @PostMapping("/receta")
    public String generateReceta(@ModelAttribute RecetaRequest request, Model model) {
        try {
            System.out.println("📨 Recibiendo solicitud de receta...");

            RecetaResponse response = recetaService.generateRecipe(request);

            model.addAttribute("recetaRequest", request);
            model.addAttribute("recetaResponse", response);
            model.addAttribute("success", "Receta generada exitosamente");

        } catch (Exception e) {
            System.err.println("❌ Error en receta: " + e.getMessage());
            model.addAttribute("error", "Error: " + e.getMessage());
            model.addAttribute("recetaRequest", request);
            model.addAttribute("recetaResponse", new RecetaResponse());
        }

        return "index";
    }
}
