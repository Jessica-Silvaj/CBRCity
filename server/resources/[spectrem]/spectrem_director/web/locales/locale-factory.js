(function registerSpectremLocaleFactory() {
  const globalScope = window;
  const packs = globalScope.SD_LANG_PACKS || (globalScope.SD_LANG_PACKS = {});

  function isObject(value) {
    return Boolean(value) && typeof value === "object" && !Array.isArray(value);
  }

  function cloneValue(value) {
    if (Array.isArray(value)) return value.map(cloneValue);
    if (!isObject(value)) return value;
    return Object.fromEntries(Object.entries(value).map(([key, item]) => [key, cloneValue(item)]));
  }

  function mergeObjects(base, overrides) {
    const output = isObject(base) ? cloneValue(base) : {};
    if (!isObject(overrides)) return output;
    for (const [key, value] of Object.entries(overrides)) {
      output[key] = isObject(value) && isObject(output[key])
        ? mergeObjects(output[key], value)
        : cloneValue(value);
    }
    return output;
  }

  function placeholderSignature(value) {
    return (String(value || "").match(/\{\{\s*[\w.-]+\s*\}\}|\{\s*[\w.-]+\s*\}|%[sdif]/g) || [])
      .map((token) => token.replace(/\s+/g, ""))
      .sort()
      .join("|");
  }

  function safeTranslation(source, candidate, invalidPlaceholders, key) {
    if (typeof candidate !== "string") return source;
    if (placeholderSignature(source) === placeholderSignature(candidate)) return candidate;
    invalidPlaceholders.push(key);
    return source;
  }

  function registerLocale(code, definition) {
    const localeCode = String(code || "").trim().toLowerCase();
    const english = packs.en;
    if (!localeCode || !isObject(english)) {
      throw new Error("Spectrem Director locales require the English catalog to be loaded first.");
    }

    const config = isObject(definition) ? definition : {};
    // Feature catalogs can register precise overrides before locale modules load.
    // Keep them separate from generated locale text so a product term or a
    // placeholder-sensitive message is never replaced by an approximate fallback.
    const localeOverrides = isObject(globalScope.SD_LOCALE_STRING_OVERRIDES)
      && isObject(globalScope.SD_LOCALE_STRING_OVERRIDES[localeCode])
      ? globalScope.SD_LOCALE_STRING_OVERRIDES[localeCode]
      : {};
    const translatedStrings = mergeObjects(
      isObject(config.strings) ? config.strings : {},
      localeOverrides,
    );
    const translatedStaticText = isObject(config.staticText) ? config.staticText : {};
    const invalidPlaceholders = [];
    const pack = {};

    for (const [key, value] of Object.entries(english)) {
      if (key === "staticText" || key === "optionLabels") continue;
      pack[key] = typeof value === "string" && typeof translatedStrings[key] === "string"
        ? safeTranslation(value, translatedStrings[key], invalidPlaceholders, key)
        : cloneValue(value);
    }

    pack.shortLabel = String(config.shortLabel || localeCode).toUpperCase();
    pack.languageName = String(config.languageName || pack.shortLabel);
    pack.direction = config.direction === "rtl" ? "rtl" : "ltr";
    const localizedOptionLabels = cloneValue(config.optionLabels || {});
    const spanishOptionLabels = packs.es && packs.es.optionLabels;
    if (localeCode !== "es" && isObject(spanishOptionLabels)) {
      for (const [group, labels] of Object.entries(localizedOptionLabels)) {
        if (!isObject(labels)) continue;
        for (const [value, label] of Object.entries(labels)) {
          const spanishLabel = spanishOptionLabels[group] && spanishOptionLabels[group][value];
          const englishLabel = english.optionLabels && english.optionLabels[group] && english.optionLabels[group][value];
          if (typeof spanishLabel === "string" && label === spanishLabel && spanishLabel !== englishLabel) {
            delete labels[value];
          }
        }
      }
    }
    pack.optionLabels = mergeObjects(english.optionLabels, localizedOptionLabels);

    const englishStringKeysByValue = new Map();
    for (const [key, value] of Object.entries(english)) {
      if (typeof value !== "string" || !value.trim()) continue;
      if (!englishStringKeysByValue.has(value)) englishStringKeysByValue.set(value, key);
    }

    const canonicalStaticSources = new Set();
    for (const sourcePack of Object.values(packs)) {
      if (!isObject(sourcePack) || !isObject(sourcePack.staticText)) continue;
      for (const source of Object.keys(sourcePack.staticText)) canonicalStaticSources.add(source);
    }
    for (const value of englishStringKeysByValue.keys()) canonicalStaticSources.add(value);
    for (const source of Object.keys(translatedStaticText)) canonicalStaticSources.add(source);

    const staticText = {};
    for (const source of canonicalStaticSources) {
      if (typeof translatedStaticText[source] === "string") {
        staticText[source] = safeTranslation(
          source,
          translatedStaticText[source],
          invalidPlaceholders,
          `staticText.${source}`,
        );
        continue;
      }
      const namedKey = englishStringKeysByValue.get(source);
      staticText[source] = namedKey && typeof pack[namedKey] === "string"
        ? pack[namedKey]
        : source;
    }
    pack.staticText = staticText;

    Object.defineProperty(pack, "__translationMeta", {
      configurable: false,
      enumerable: false,
      writable: false,
      value: Object.freeze({
        authoredNamed: Object.keys(translatedStrings).filter((key) => typeof translatedStrings[key] === "string").length,
        totalNamed: Object.entries(english).filter(([key, value]) => (
          key !== "shortLabel" && key !== "languageName" && key !== "direction" && typeof value === "string"
        )).length,
        authoredStatic: Object.keys(translatedStaticText).filter((key) => typeof translatedStaticText[key] === "string").length,
        totalStatic: canonicalStaticSources.size,
        invalidPlaceholders: Object.freeze(invalidPlaceholders.slice()),
      }),
    });

    packs[localeCode] = pack;
    return pack;
  }

  globalScope.SD_I18N = Object.assign(globalScope.SD_I18N || {}, {
    registerLocale,
  });
})();
