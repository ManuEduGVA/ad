document.addEventListener("DOMContentLoaded", () => {
    const temaInput = document.getElementById("temaInput");
    const enviarBtn = document.getElementById("enviarBtn");
    const historial = document.getElementById("historial");
    
    // Función para simular efecto máquina de escribir
    async function typewriterEffect(text, element, speed = 40) {
        for (let i = 0; i < text.length; i++) {
            element.innerHTML += text[i];
            await new Promise(resolve => setTimeout(resolve, speed));
        }
    }

    // Función para procesar la respuesta completa
    async function processResponse(response) {
        const reader = response.body.getReader();
        const decoder = new TextDecoder();
        let result = '';

        while (true) {
            const {done, value} = await reader.read();
            if (done) break;
            result += decoder.decode(value, {stream: true});
        }

        return result;
    }

    // Cargar presentación al inicio
    fetch("/api/v1/getPresentacionAlUsuario")
        .then(response => processResponse(response))
        .then(async text => {
            const presentacionP = document.createElement('p');
            historial.appendChild(presentacionP);
            await typewriterEffect(text, presentacionP);
        });

    // Habilitar/deshabilitar botón
    temaInput.addEventListener("input", () => {
        enviarBtn.disabled = temaInput.value.trim() === "";
    });

    // Enviar tema al hacer clic
    enviarBtn.addEventListener("click", async () => {
        const tema = temaInput.value.trim();
        if (tema) {
            const responseP = document.createElement('p');
            const strongTema = document.createElement('strong');
            strongTema.textContent = `${tema}: `;
            responseP.appendChild(strongTema);
            historial.appendChild(responseP);

            try {
                const response = await fetch(`/api/v1/getChisteTematico?tema=${encodeURIComponent(tema)}`);
                const text = await processResponse(response);
                
                // Simular efecto de escritura
                await typewriterEffect(text, responseP);
                
                // Limpiar campo y deshabilitar botón
                temaInput.value = "";
                enviarBtn.disabled = true;
                
                // Hacer scroll al final del historial
                historial.scrollTop = historial.scrollHeight;
            } catch (error) {
                responseP.innerHTML += `Error: ${error.message}`;
            }
        }
    });

    // Permitir enviar con Enter
    temaInput.addEventListener("keypress", (e) => {
        if (e.key === "Enter" && !enviarBtn.disabled) {
            enviarBtn.click();
        }
    });
});