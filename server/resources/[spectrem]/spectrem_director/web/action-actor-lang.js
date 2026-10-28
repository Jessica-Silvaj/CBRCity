(function () {
  const es = {
    'ACTION · Choose a character': 'ACTION · Elige un personaje',
    'Record as an actor or replay driver using the normal game camera. Everything plays automatically; you do not control their movement.': 'Graba como un actor o conductor del replay con la cámara normal del juego. Todo se reproduce automáticamente; no controlas sus movimientos.',
    'You return to your character when the selected clip ends or recording stops. If the clip starts later, possession starts with it.': 'Vuelves a tu personaje cuando termina el clip seleccionado o detienes la grabación. Si el clip empieza más tarde, lo poseerás cuando comience.',
    'Without possession': 'Sin poseer un personaje',
    'Record as selected': 'Grabar como seleccionado',
    'ACTION actors could not be loaded.': 'No se pudieron cargar los actores para ACTION.',
    'Choose an actor for ACTION again.': 'Vuelve a elegir un actor para ACTION.',
    'This Timeline already has a camera. Use its camera for ACTION.': 'Este Timeline ya tiene una cámara. Úsala para ACTION.',
    'The selected ACTION actor is no longer available. Choose again.': 'El actor seleccionado para ACTION ya no está disponible. Elige de nuevo.',
    'Return to your character before starting ACTION with an actor.': 'Vuelve a tu personaje antes de iniciar ACTION con un actor.',
    'Your character is unavailable.': 'Tu personaje no está disponible.',
    'The selected ACTION actor could not be spawned. Check its clip and try again.': 'No se pudo crear el actor seleccionado para ACTION. Revisa su clip y vuelve a intentarlo.',
  };
  const pack = window.SD_LANG_PACKS?.es;
  if (pack) Object.assign(pack.staticText || (pack.staticText = {}), es);
})();
