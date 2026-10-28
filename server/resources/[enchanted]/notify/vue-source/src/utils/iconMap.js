import Success from "@icons/Success.vue";
import Warning from "@icons/Warning.vue";
import Error from "@icons/Error.vue";
import Police from "@icons/Police.vue";
import Server from "@icons/Server.vue";
import Hunger from "@icons/Hunger.vue";
import Thirst from "@icons/Thirst.vue";
import Blood from "@icons/Blood.vue";
import Bell from "@icons/Bell.vue";
import Gift from "@icons/Gift.vue";
import Halloween from "@icons/Halloween.vue";
import Weather from "@icons/Weather.vue";

/** Mapeia o nome da imagem (enviado pelo Lua) para o componente Vue. */
const iconMap = {
  verde: Success,
  amarelo: Warning,
  vermelho: Error,
  policia: Police,
  server: Server,
  fome: Hunger,
  sede: Thirst,
  sangue: Blood,
  default: Bell,
  christmas: Gift,
  halloween: Halloween,
  clima: Weather,
};

export default iconMap;
