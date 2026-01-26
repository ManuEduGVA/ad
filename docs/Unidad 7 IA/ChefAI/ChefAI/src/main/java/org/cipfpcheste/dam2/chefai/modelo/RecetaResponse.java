package org.cipfpcheste.dam2.chefai.modelo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecetaResponse {
    private String ingredientes;
    private String receta;
    private String tipoComida;
    private String objetivoDieta;
}
