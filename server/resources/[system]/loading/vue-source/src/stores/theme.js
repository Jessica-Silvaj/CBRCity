import { ref } from "vue";

// Estado do tema da loading screen (mesmo padrão do bundle original): um ref
// de módulo preenchido pelo applyTheme com Theme.loading ({ mode, model }) e a
// flag grayscale (quando a cor principal é acinzentada, o hover/ativo troca o
// verde por branco). A visibilidade do progresso não mora aqui — vem do
// Progress do shared-side via settings.progressVisible. Não é Pinia de
// propósito — é um estado de "tema" global como na HUD, reativo para todos.
export const themeState = ref({});
