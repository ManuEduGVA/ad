class RecipeApp {
    constructor() {
        this.initializeElements();
        this.attachEventListeners();
    }

    initializeElements() {
        this.textArea = document.getElementById('ingredientes');
        this.charCount = document.getElementById('charCount');
    }

    attachEventListeners() {
        this.textArea.addEventListener('input', () => this.updateCharCount());

        // Actualizar contador al cargar la página
        this.updateCharCount();
    }

    updateCharCount() {
        const count = this.textArea.value.length;
        this.charCount.textContent = `${count}/2000 caracteres`;
        this.charCount.className = `char-count ${count > 2000 ? 'warning' : ''}`;
    }
}

// Inicializar la aplicación cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', () => {
    new RecipeApp();
});
