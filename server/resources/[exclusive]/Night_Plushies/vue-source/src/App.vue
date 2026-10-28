<script setup>
import { ref, computed, onMounted, onUnmounted, watch } from 'vue';
import { useSound } from '@vueuse/sound';
import rouletteSound from './assets/sounds/roulette.mp3';

const { play: playRoulette, stop: stopRoulette } = useSound(rouletteSound);

const show = ref(false);
const activeMainTab = ref('roleta'); 
const activeCategory = ref('Todos');
const myPlushies = ref([]);
const catalog = ref([]);
const inventory = ref([]);
const balance = ref(0);
const roulettePrice = ref(250); 
const isSpinning = ref(false);
const resetTransition = ref(false);
const spinItems = ref([]);
const wonItem = ref(null);
const showProgressBar = ref(false);
const viewingPlushie = ref(null);
const worldCount = ref(0);
const displayLimit = ref(120);

const getResourceName = () => {
  if (typeof window !== 'undefined' && window.GetParentResourceName) {
    try {
      return window.GetParentResourceName();
    } catch (e) {
      return 'Night_Plushies';
    }
  }
  return 'Night_Plushies';
};

const fetchMyPlushies = () => {
  if (!window.invokeNative && !window.GetParentResourceName) return;

  fetch(`https://${getResourceName()}/getMyPlushies`, {
    method: 'POST',
    body: JSON.stringify({})
  })
  .then(res => res.json())
  .then(data => {
    myPlushies.value = data;
  })
  .catch(() => {
    if (window.invokeNative) myPlushies.value = [];
  });
};

watch([activeMainTab, activeCategory], ([newMenu, newCat]) => {
  displayLimit.value = 120;
  
  const container = document.querySelector('.my-plushies-section');
  if (container) container.scrollTop = 0;

  if (newMenu === 'minhas') {
    fetchMyPlushies();
  }
});

const displayedPlushies = computed(() => {
  return groupedMyPlushies.value.slice(0, displayLimit.value);
});

const handlePlushiesScroll = (e) => {
  const container = e.target;
  const { scrollTop, scrollHeight, clientHeight } = container;

  if (scrollTop + clientHeight >= scrollHeight - 100) {
    if (displayLimit.value < groupedMyPlushies.value.length) {
      displayLimit.value += 20;
    }
  }
};

const fetchWorldCount = (plushieId) => {
  worldCount.value = 0;
  if (!window.invokeNative && !window.GetParentResourceName) {
    worldCount.value = 14; 
    return;
  }

  fetch(`https://${getResourceName()}/getTotalPlushies`, {
    method: 'POST',
    body: JSON.stringify({ id: plushieId })
  })
  .then(res => res.json())
  .then(count => {
    worldCount.value = Number(count);
  })
  .catch(() => {
    worldCount.value = 0;
  });
};

const hexToRgb = (hex) => {
  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result ? {
    r: parseInt(result[1], 16),
    g: parseInt(result[2], 16),
    b: parseInt(result[3], 16)
  } : null;
};

const updateTheme = (themeData) => {
  const root = document.documentElement;

  if (typeof themeData === 'string') {
    const rgb = hexToRgb(themeData);
    if (!rgb) return;
    const mainRgb = `${rgb.r} ${rgb.g} ${rgb.b}`;
    const fromRgb = `${Math.round(rgb.r * 0.125)} ${Math.round(rgb.g * 0.129)} ${Math.round(rgb.b * 0.09)}`;
    const toRgb = `${Math.round(rgb.r * 0.215)} ${Math.round(rgb.g * 0.223)} ${Math.round(rgb.b * 0.136)}`;
    const hoverRgb = `${Math.round(rgb.r * 0.8)} ${Math.round(rgb.g * 0.8)} ${Math.round(rgb.b * 0.77)}`;

    root.style.setProperty('--main', mainRgb);
    root.style.setProperty('--from', fromRgb);
    root.style.setProperty('--to', toRgb);
    root.style.setProperty('--accept-background', mainRgb);
    root.style.setProperty('--accept-background-hover', hoverRgb);
    return;
  }

  if (themeData.main) {
    const rgb = hexToRgb(themeData.main);
    if (rgb) {
      const mainRgb = `${rgb.r} ${rgb.g} ${rgb.b}`;
      const fromRgb = `${Math.round(rgb.r * 0.125)} ${Math.round(rgb.g * 0.129)} ${Math.round(rgb.b * 0.09)}`;
      const toRgb = `${Math.round(rgb.r * 0.215)} ${Math.round(rgb.g * 0.223)} ${Math.round(rgb.b * 0.136)}`;
      const hoverRgb = `${Math.round(rgb.r * 0.8)} ${Math.round(rgb.g * 0.8)} ${Math.round(rgb.b * 0.77)}`;

      root.style.setProperty('--main', mainRgb);
      root.style.setProperty('--from', fromRgb);
      root.style.setProperty('--to', toRgb);
      root.style.setProperty('--accept-background', mainRgb);
      root.style.setProperty('--accept-background-hover', hoverRgb);
    }
  }

  ['common', 'rare', 'epic', 'legendary'].forEach(rarity => {
    if (themeData[rarity]) {
      const rgb = hexToRgb(themeData[rarity]);
      if (rgb) {
        root.style.setProperty(`--rarity-${rarity}`, `${rgb.r} ${rgb.g} ${rgb.b}`);
      }
    }
  });
};

const equippedPlushies = ref({});

const equipPlushie = (plushie, positionId = null) => {
  const plushieId = plushie.Plushie || plushie.id;
  fetch(`https://${getResourceName()}/equipPlushie`, {
    method: 'POST',
    body: JSON.stringify({ 
      id: plushieId,
      position: positionId 
    })
  });
};

const isCurrentlyEquipped = (plushie, positionId = null) => {
  if (!plushie || !equippedPlushies.value) return false;
  const plushieId = plushie.Plushie || plushie.id;
  for (const slot in equippedPlushies.value) {
    const item = equippedPlushies.value[slot];
    if (item && item.id === plushieId) {
      if (positionId) {
        if (item.position === positionId) return true;
      } else {
        return true;
      }
    }
  }
  return false;
};

const handleEquip = (plushie, positionId = null) => {
  const plushieId = plushie.Plushie || plushie.id;
  if (isCurrentlyEquipped(plushie, positionId)) {
    handleUnequip(plushie);
    return;
  }

  equipPlushie(plushie, positionId);
};

const handleUnequip = (plushie = null) => {
  if (plushie && isCurrentlyEquipped(plushie)) {
    equipPlushie(plushie, 'unequip');
  } else {
    equipPlushie({ id: 'none' });
  }
};

const transferPlushie = (plushie) => {
  fetch(`https://${getResourceName()}/transferPlushie`, {
    method: 'POST',
    body: JSON.stringify({ id: plushie.id })
  });
};

const getPlushieImage = (item) => {
  if (!item) return '';
  
  const icon = item.icon || (item.id ? `${item.id}.png` : '');
  if (!icon) return '';
  
  if (icon.startsWith('http')) return icon;
  
  const categoryMap = {
    'Gatos': 'Cats',
    'Pets': 'Dogs',
    'Dragões': 'Dragons',
    'Fadas': 'Fairys',
    'Caquinhos': 'Monkeys',
    'Pokemon': 'PokemonJPX',
    'Pokemons': 'PokemonJPX',
    'Poderosas': 'PowerpuffJPX',
    'Meninas Super Poderosas': 'PowerpuffJPX',
    'Banguela': 'ToothlessJPX',
    'Patos': 'DuckJPX',
    'Asas': 'Asas'
  };

  const folder = item.category ? (categoryMap[item.category] || item.category) : '';
  
  try {
    if (folder) {
      return new URL(`./assets/images/${folder}/${icon}`, import.meta.url).href;
    } else {
      // Fallback para quando não tem categoria ou não está no mapa
      return new URL(`./assets/images/${icon}`, import.meta.url).href;
    }
  } catch (e) {
    // Tenta carregar direto da pasta images se falhar com a categoria
    try {
      return new URL(`./assets/images/${icon}`, import.meta.url).href;
    } catch (err) {
      return '';
    }
  }
};

const getRarityLabel = (rarity) => {
  const labels = {
    'common': 'Comum',
    'rare': 'Raro',
    'epic': 'Épico',
    'legendary': 'Lendário'
  };
  return labels[rarity] || rarity;
};

const categories = computed(() => {
  if (myPlushies.value.length === 0) return [];
  
  const ownedCategories = new Set();
  myPlushies.value.forEach(p => {
    if (p.Plushie === 'pokemon1') return;
    const item = catalog.value.find(c => c.id === p.Plushie) || catalog.value.find(c => c.name === p.Plushie);
    if (item && item.category !== 'Asas') {
      ownedCategories.add(item.category);
    }
  });
  
  return ['Todos', ...ownedCategories];
});

const filteredCatalog = computed(() => {
  if (activeMainTab.value !== 'minhas') return [];
  if (activeCategory.value === 'Todos') return catalog.value;
  return catalog.value.filter(item => item.category === activeCategory.value);
});

const groupedMyPlushies = computed(() => {
  let result = myPlushies.value
    .filter(p => p.Plushie !== 'pokemon1')
    .map((p, index) => {
      const item = catalog.value.find(c => c.id === p.Plushie) || catalog.value.find(c => c.name === p.Plushie);
      return {
        id: p.id || index, 
        Plushie: p.Plushie,
        name: item ? item.name : p.Plushie,
        category: item ? item.category : 'Outros',
        item: item
      };
    })
    .filter(p => p.item && p.category !== 'Asas' && p.category !== 'Outros');
  
  if (activeCategory.value !== 'Todos') {
    result = result.filter(p => p.category === activeCategory.value);
  }
  return result;
});

const toggleItem = (item) => {
};

const spinRoulette = () => {
  if (isSpinning.value || showProgressBar.value || balance.value < roulettePrice.value || catalog.value.length === 0) return;
  
  isSpinning.value = true;
  
  fetch(`https://${getResourceName()}/trySpin`, {
    method: 'POST',
    body: JSON.stringify({})
  })
  .then(res => res.json())
  .then(data => {
    if (!data || !data.success) {
      isSpinning.value = false;
      return;
    }

    const serverWinner = data.winner;
    wonItem.value = null;
    isSpinning.value = false;
    resetTransition.value = true;

    setTimeout(() => {
      resetTransition.value = false; 
      
      const validCatalog = catalog.value.filter(item => item && item.name);
      const items = [];
      let lastItemIds = [];
      for (let i = 0; i < 100; i++) {
        let selectedItem;
        
        const maxHistory = Math.min(5, Math.floor(validCatalog.length / 2));
        
        do {
          const randomIndex = Math.floor(Math.random() * validCatalog.length);
          selectedItem = validCatalog[randomIndex];
        } while (lastItemIds.includes(selectedItem.id));
        
        items.push(selectedItem);
        lastItemIds.push(selectedItem.id);
        if (lastItemIds.length > maxHistory) lastItemIds.shift();
      }

      // Garante que o item no índice do vencedor seja o que o servidor escolheu
      const winnerIndex = 80;
      items[winnerIndex] = catalog.value.find(i => i.id === serverWinner.id) || serverWinner;
      
      spinItems.value = items;

      setTimeout(() => {
        isSpinning.value = true;
        playRoulette(); 
        const winner = items[winnerIndex];

        setTimeout(() => {
          isSpinning.value = false;
          stopRoulette(); 
          wonItem.value = winner;
          showProgressBar.value = true;
          
          fetch(`https://${getResourceName()}/winNotify`, {
            method: 'POST',
            body: JSON.stringify({
              id: winner.id,
              name: winner.name
            })
          });

          setTimeout(() => {
            wonItem.value = null;
            showProgressBar.value = false;
            resetTransition.value = true;
            setTimeout(() => {
              resetTransition.value = false;
            }, 50);
          }, 5000);
        }, 5000); 
      }, 50);
    }, 50);
  });
};

const closeUI = () => {
  if (isSpinning.value || showProgressBar.value) return; 
  show.value = false;
  fetch(`https://${getResourceName()}/close`, {
    method: 'POST',
    body: JSON.stringify({})
  });
};

const initializeSpinItems = () => {
  if (catalog.value.length > 0) {
    // Filtra apenas itens válidos do catálogo
    const validCatalog = catalog.value.filter(item => item && item.name);
    
    // Mostra todas as pelúcias configuradas no catálogo
    // Ordenamos por raridade para ficar mais bonito visualmente
    const sortedCatalog = [...validCatalog].sort((a, b) => {
      const rarities = { 'common': 1, 'rare': 2, 'epic': 3, 'legendary': 4 };
      const rarityA = rarities[a.rarity] || 0;
      const rarityB = rarities[b.rarity] || 0;
      if (rarityA !== rarityB) return rarityA - rarityB;
      return a.name.localeCompare(b.name);
    });
    
    spinItems.value = sortedCatalog;
  }
};

const messageHandler = (event) => {
  const data = event.data;
  if (data.action === 'open') {
    activeCategory.value = 'Todos';
    if (data.gems !== undefined) balance.value = data.gems;
    if (data.price !== undefined) roulettePrice.value = data.price;
    if (data.theme !== undefined) updateTheme(data.theme);
    
    if (data.catalog) {
      if (!Array.isArray(data.catalog)) {
        catalog.value = Object.keys(data.catalog)
          .map(key => ({
            id: key,
            ...data.catalog[key]
          }))
          .filter(item => item.category !== 'Asas'); // Remove categoria Asas
      } else {
        // Se for array, remove nulos (comum em conversão Lua -> JSON) e garante ID
        catalog.value = data.catalog
          .filter(i => i !== null && i !== undefined && i.category !== 'Asas') // Remove nulos e categoria Asas
          .map((item, index) => ({
            id: item.id || index,
            ...item
          }));
      }
    }
    
    if (data.inventory) inventory.value = data.inventory;

    if (data.equipped && typeof data.equipped === 'object') {
      equippedPlushies.value = data.equipped;
    } else {
      equippedPlushies.value = {};
    }
    
    initializeSpinItems();
    
    setTimeout(() => {
      show.value = true;
    }, 50);
  } else if (data.action === 'syncPlushies') {
    equippedPlushies.value = (data.equipped && typeof data.equipped === 'object') ? data.equipped : {};
  } else if (data.action === 'updateGems') {
    if (data.gems !== undefined) balance.value = data.gems;
  } else if (data.action === 'close') {
    show.value = false;
  }
};

onMounted(() => {
  window.addEventListener('message', messageHandler);
  
  window.onkeydown = (e) => {
    if (e.key === 'Escape') {
      if (show.value) {
        closeUI();
      }
    }
    if (e.key === 'Tab') {
      e.preventDefault();
    }
  };
});

onUnmounted(() => {
  window.removeEventListener('message', messageHandler);
});
</script>

<template>
  <Transition name="slide">
    <div v-if="show" class="container">
      <div class="bg-effects">
        <svg class="svg-bg svg-1" viewBox="0 0 256 194.3">
          <path fill="currentColor" d="M2.4,88.7c0.2,1-0.1,1.1,0.2,0.8c16-20.1,34.7-43.7,50.3-57.1C34.3,63.7,15.3,94.7,0.2,126.3c-0.8,1.7,0.6,2.1,2.9,2.2c1.8,0.1,3.4,2.9,4.7,5.8c0.9,2.1,2.2,2.8,3.6,1.1C28,114.1,43.9,94,60,75.8c-18.4,24.9-35.3,49.9-48.7,75.2c-1,1.8,0.3,2.9,2.7,3.4c2,0.4,4.1,1.7,5.2,5.2c0.6,1.9,1.9,3.5,3.1,2.1c18.9-19.9,35.3-42.4,54.4-61.3c-4.1,5.9-8.2,11.6-11.7,17.5c-0.7,1.2,0.7,1.7,2.3,1.9c2.1,0.3,3.2,2.9,4.5,5.4c0.7,1.4,2.2,1.4,3.3,0.2c11.4-12,22.7-23.7,35-34.8c-8.6,11.7-17,23.2-24.1,35.5c-1.1,1.9,0.4,3.3,2.4,3.9c2.1,0.6,3.4,1.8,4.4,4.6c0.6,1.7,2.6,2.9,4.3,1.5c11.6-9.5,22.3-19.7,34.7-29.6c-10.9,17.2-21.2,34-28.4,51.9c-0.9,2.3,0.9,3.1,2.6,3.4c2.1,0.4,3.4,2.5,4.6,5.1c1.1,2.3,4.2,2.1,7.5-1.2c15.1-14.9,44.5-58.8,92.3-106.4c-32.6,44.4-59.4,85.6-74.6,121.9c-1.4,3.4-0.6,5.1,2.2,5.4c1.9,0.2,3.9,1.6,4.9,5c0.8,2.8,3.9,3.6,6.2,0.7c11.3-13.9,23.5-27.1,35.7-40c-2.4,3.8-4.7,7.6-6.9,11.4c-1.3,2.2,0.2,2.7,2.3,3.1c2.4,0.5,3.3,2.2,4.6,5.1c1.2,2.5,2.9,2.3,4.1,1c10.8-11.2,21.5-21.2,34.2-28.5c-5,12-10.6,24.6-16.2,36.6c-0.3,0.7,0.4,0.9,1.8,0c11.6-7.3,23.9-23.9,26.9-35.3c1.4-5.3,0.3-10-2.6-12.8c-2.5-2.5-8-1.9-12.1-0.4c-5,1.8-7.7,3.8-12.6,6.8c5.5-8.9,11.8-16.4,17.9-25.3c2.2-3.2,1.8-7.6-0.7-9.8c-2.2-2-7.2-1.9-12,2.1c-19.5,16.6-36.9,34.5-54.3,54.8c28.5-49.8,60.1-94.6,94.1-138.4c3.2-4.1,2.9-9,0.1-11.2c-3.7-2.8-8.1-1.8-13.3,2.8c-41.4,36.6-78.1,76.9-112.6,121.6c6.6-12.2,15.2-23.9,21.8-37.6c2.1-4.4,1.3-8.9-0.8-10.6c-2.8-2.4-7.8-2-12.8,1.5c-9.3,6.5-17.9,13.8-26.4,21.3C120.8,94.9,133,80,144.5,64.2c2.2-3,2.5-6,0.2-8.3c-2.3-2.2-5.9-2.5-9.6-0.3c-5.5,3.2-10.4,7.3-11.5,11.5c4.1-4.9,7.5-9.1,10.5-14.4c2-3.6,0.6-6.7-1.2-8.6c-2.3-2.3-7.5-1.9-11.2,1c-21.5,16.7-41.1,36.4-60.3,57.2C79,71.2,104.7,41,127.5,9.9c1.9-2.6,0.9-6.4-1.5-8.5c-3-2.7-8.7-1.3-12.8,2.2C85.7,27.5,61.1,53.8,37.3,81.9c11.6-21.1,25-42.1,36.2-63.7c1.4-2.7,0.3-6.6-1.8-8c-4-2.6-7.9-0.8-11,2.1c-30.9,29-49.9,53.2-59.9,73c-0.7,1.3-0.3,2,0.6,2.5C1.8,88.1,2.4,88.3,2.4,88.7z"></path>
        </svg>
        <div class="shadow-circle shadow-1"></div>
        <svg class="svg-bg svg-2" viewBox="0 0 256 194.3">
          <path fill="currentColor" d="M2.4,88.7c0.2,1-0.1,1.1,0.2,0.8c16-20.1,34.7-43.7,50.3-57.1C34.3,63.7,15.3,94.7,0.2,126.3c-0.8,1.7,0.6,2.1,2.9,2.2c1.8,0.1,3.4,2.9,4.7,5.8c0.9,2.1,2.2,2.8,3.6,1.1C28,114.1,43.9,94,60,75.8c-18.4,24.9-35.3,49.9-48.7,75.2c-1,1.8,0.3,2.9,2.7,3.4c2,0.4,4.1,1.7,5.2,5.2c0.6,1.9,1.9,3.5,3.1,2.1c18.9-19.9,35.3-42.4,54.4-61.3c-4.1,5.9-8.2,11.6-11.7,17.5c-0.7,1.2,0.7,1.7,2.3,1.9c2.1,0.3,3.2,2.9,4.5,5.4c0.7,1.4,2.2,1.4,3.3,0.2c11.4-12,22.7-23.7,35-34.8c-8.6,11.7-17,23.2-24.1,35.5c-1.1,1.9,0.4,3.3,2.4,3.9c2.1,0.6,3.4,1.8,4.4,4.6c0.6,1.7,2.6,2.9,4.3,1.5c11.6-9.5,22.3-19.7,34.7-29.6c-10.9,17.2-21.2,34-28.4,51.9c-0.9,2.3,0.9,3.1,2.6,3.4c2.1,0.4,3.4,2.5,4.6,5.1c1.1,2.3,4.2,2.1,7.5-1.2c15.1-14.9,44.5-58.8,92.3-106.4c-32.6,44.4-59.4,85.6-74.6,121.9c-1.4,3.4-0.6,5.1,2.2,5.4c1.9,0.2,3.9,1.6,4.9,5c0.8,2.8,3.9,3.6,6.2,0.7c11.3-13.9,23.5-27.1,35.7-40c-2.4,3.8-4.7,7.6-6.9,11.4c-1.3,2.2,0.2,2.7,2.3,3.1c2.4,0.5,3.3,2.2,4.6,5.1c1.2,2.5,2.9,2.3,4.1,1c10.8-11.2,21.5-21.2,34.2-28.5c-5,12-10.6,24.6-16.2,36.6c-0.3,0.7,0.4,0.9,1.8,0c11.6-7.3,23.9-23.9,26.9-35.3c1.4-5.3,0.3-10-2.6-12.8c-2.5-2.5-8-1.9-12.1-0.4c-5,1.8-7.7,3.8-12.6,6.8c5.5-8.9,11.8-16.4,17.9-25.3c2.2-3.2,1.8-7.6-0.7-9.8c-2.2-2-7.2-1.9-12,2.1c-19.5,16.6-36.9,34.5-54.3,54.8c28.5-49.8,60.1-94.6,94.1-138.4c3.2-4.1,2.9-9,0.1-11.2c-3.7-2.8-8.1-1.8-13.3,2.8c-41.4,36.6-78.1,76.9-112.6,121.6c6.6-12.2,15.2-23.9,21.8-37.6c2.1-4.4,1.3-8.9-0.8-10.6c-2.8-2.4-7.8-2-12.8,1.5c-9.3,6.5-17.9,13.8-26.4,21.3C120.8,94.9,133,80,144.5,64.2c2.2-3,2.5-6,0.2-8.3c-2.3-2.2-5.9-2.5-9.6-0.3c-5.5,3.2-10.4,7.3-11.5,11.5c4.1-4.9,7.5-9.1,10.5-14.4c2-3.6,0.6-6.7-1.2-8.6c-2.3-2.3-7.5-1.9-11.2,1c-21.5,16.7-41.1,36.4-60.3,57.2C79,71.2,104.7,41,127.5,9.9c1.9-2.6,0.9-6.4-1.5-8.5c-3-2.7-8.7-1.3-12.8,2.2C85.7,27.5,61.1,53.8,37.3,81.9c11.6-21.1,25-42.1,36.2-63.7c1.4-2.7,0.3-6.6-1.8-8c-4-2.6-7.9-0.8-11,2.1c-30.9,29-49.9,53.2-59.9,73c-0.7,1.3-0.3,2,0.6,2.5C1.8,88.1,2.4,88.3,2.4,88.7z"></path>
        </svg>
        <div class="shadow-circle shadow-2"></div>
      </div>

      <aside class="sidebar">
        <Transition name="fade">
          <div v-if="viewingPlushie" class="plushie-details-overlay">
            <div class="details-content">
              <button class="btn-back" @click="viewingPlushie = null">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                Voltar
              </button>
              
              <div class="details-main-info" :class="viewingPlushie.item?.rarity ? `rarity-${viewingPlushie.item.rarity}` : ''">
                <div class="details-image" :class="viewingPlushie.item?.rarity ? `rarity-${viewingPlushie.item.rarity}` : ''">
                  <img :src="getPlushieImage(viewingPlushie.item)" :alt="viewingPlushie.name">
                </div>

                <div class="details-info">
                  <h2>{{ viewingPlushie.name }}</h2>
                  <div class="tags-container">
                    <span class="id-tag">#{{ viewingPlushie.id }}</span>
                    <span class="category-tag">{{ viewingPlushie.category }}</span>
                    <span v-if="viewingPlushie.item?.rarity" class="rarity-tag" :class="`rarity-${viewingPlushie.item.rarity}`">
                      {{ getRarityLabel(viewingPlushie.item.rarity) }}
                    </span>
                  </div>
                </div>
              </div>

              <div class="details-world-count">
                <i class="fas fa-globe-americas"></i>
                <span v-if="worldCount > 1">Existem <b>{{ worldCount }}</b> unidades desta pelúcia no mundo</span>
                <span v-else-if="worldCount === 1">Essa pelúcia é <b>única</b></span>
                <span v-else>Carregando informações...</span>
              </div>

              <div v-if="viewingPlushie.item && ( (viewingPlushie.item.benefits && viewingPlushie.item.benefits.length > 0) || (viewingPlushie.item.bonus && (viewingPlushie.item.bonus.salary || viewingPlushie.item.bonus.illegal)) )" class="details-benefits">
                <h3>Benefícios</h3>
                <div class="benefits-list">
                  <div class="benefits-grid">
                    <template v-if="viewingPlushie.item.bonus">
                      <div v-if="viewingPlushie.item.bonus.salary" class="benefit-item bonus-salary">
                        <i class="fa-solid fa-hand-holding-dollar"></i>
                        <div class="benefit-info">
                          <span class="benefit-label">Bônus de Salário</span>
                          <span class="benefit-value">+{{ (viewingPlushie.item.bonus.salary * 100).toFixed(1) }}%</span>
                        </div>
                      </div>
                      <div v-if="viewingPlushie.item.bonus.illegal" class="benefit-item bonus-illegal">
                        <i class="fa-solid fa-skull-crossbones"></i>
                        <div class="benefit-info">
                          <span class="benefit-label">Atividades Ilegais</span>
                          <span class="benefit-value">+{{ (viewingPlushie.item.bonus.illegal * 100).toFixed(1) }}%</span>
                        </div>
                      </div>
                    </template>

                    <div v-for="(benefit, index) in viewingPlushie.item.benefits" :key="index" class="benefit-item">
                      <i :class="benefit.icon || 'fas fa-star'"></i>
                      <span>{{ benefit.text }}</span>
                    </div>
                  </div>
                </div>
              </div>

              <div class="details-actions">
                <template v-if="viewingPlushie.item && viewingPlushie.item.prop && viewingPlushie.item.prop.positions">
                  <button 
                    v-for="pos in viewingPlushie.item.prop.positions" 
                    :key="pos.id"
                    class="btn-details equip" 
                    :class="{ active: isCurrentlyEquipped(viewingPlushie, pos.id) }"
                    @click="handleEquip(viewingPlushie, pos.id)"
                  >
                    <i :class="isCurrentlyEquipped(viewingPlushie, pos.id) ? 'fas fa-check-circle' : 'fas fa-tshirt'"></i> {{ pos.label }}
                  </button>
                </template>
                <button 
                  v-else 
                  class="btn-details equip" 
                  :class="{ active: isCurrentlyEquipped(viewingPlushie) }"
                  @click="handleEquip(viewingPlushie)"
                >
                  <i :class="isCurrentlyEquipped(viewingPlushie) ? 'fas fa-check-circle' : 'fas fa-tshirt'"></i> {{ isCurrentlyEquipped(viewingPlushie) ? 'Equipado' : 'Equipar' }}
                </button>
                
                <button class="btn-details unequip" @click="handleUnequip(viewingPlushie)">
                  <i class="fas fa-undo"></i> Desequipar
                </button>

                <button class="btn-details transfer" @click="transferPlushie(viewingPlushie)">
                  <i class="fas fa-exchange-alt"></i> Transferir
                </button>
              </div>
            </div>
          </div>
        </Transition>

        <div class="header">
          <h1>Pelúcias</h1>
          <p>Confira sua coleção de pelúcias exclusivas</p>
        </div>

        <nav class="nav-main">
          <button 
            class="nav-main-item" 
            :class="{ active: activeMainTab === 'roleta', disabled: isSpinning || showProgressBar }"
            @click="!(isSpinning || showProgressBar) && (activeMainTab = 'roleta')"
          >
            Roleta
          </button>
          <button 
            class="nav-main-item" 
            :class="{ active: activeMainTab === 'minhas', disabled: isSpinning || showProgressBar }"
            @click="!(isSpinning || showProgressBar) && (activeMainTab = 'minhas')"
          >
            Minhas
          </button>
        </nav>

        <nav v-if="activeMainTab === 'minhas' && categories.length > 0" class="nav-categories">
          <button 
            v-for="cat in categories" 
            :key="cat"
            class="nav-cat-item"
            :class="{ active: activeCategory === cat, disabled: isSpinning || showProgressBar }"
            @click="!(isSpinning || showProgressBar) && (activeCategory = cat)"
          >
            {{ cat }}
          </button>
        </nav>

        <div v-if="activeMainTab === 'minhas'" class="my-plushies-section" @scroll="handlePlushiesScroll">
          <div v-if="groupedMyPlushies.length === 0" class="empty-plushies">
            <i class="fas fa-dharmachakra"></i>
            <p>Você não possui nenhuma pelúcia ainda.</p>
            <span>Gire a roleta surpresa para começar sua coleção!</span>
          </div>
          <div v-else class="plushies-grid">
              <div 
                v-for="plushie in displayedPlushies" 
                :key="plushie.id" 
                class="plushie-card-slot"
                :class="[
                  plushie.item?.rarity ? `rarity-${plushie.item.rarity}` : '',
                  { disabled: isSpinning || showProgressBar }
                ]"
                @click="!(isSpinning || showProgressBar) && (viewingPlushie = plushie, fetchWorldCount(plushie.Plushie))"
              >
              <div class="plushie-card-bg"></div>
              <div class="plushie-image">
                <img :src="getPlushieImage(plushie.item)" :alt="plushie.name">
              </div>
              <div class="plushie-info">
                <h3>{{ plushie.name }}</h3>
              </div>
            </div>
          </div>
        </div>

        <div v-else class="roulette-container">
          <div class="roulette-content">
            <div class="roulette-info">
              <div class="info-card">
                  <span class="info-label">Seu Saldo</span>
                  <span class="info-value">
                    <svg class="diamond-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                      <path fill-rule="evenodd" clip-rule="evenodd" d="M9.32289 2.25003L9.23265 2.25001C8.47304 2.24984 7.96465 2.24972 7.47672 2.36883C7.25578 2.42277 7.03998 2.49476 6.83189 2.58414C6.37 2.78253 5.97535 3.08651 5.39532 3.53329L5.32472 3.58766L5.29273 3.61228C4.24651 4.41768 3.41746 5.0559 2.80797 5.62799C2.1851 6.21262 1.72591 6.7865 1.48506 7.48693C1.28734 8.06193 1.21295 8.66844 1.26722 9.27182C1.33356 10.0094 1.64582 10.6679 2.11451 11.3677C2.57202 12.0509 3.22764 12.8427 4.05236 13.8386L4.05239 13.8387L4.05242 13.8387L8.11023 18.7392L8.11025 18.7392L8.11026 18.7392C8.84673 19.6287 9.45218 20.3599 10.0079 20.8609C10.5914 21.3869 11.2168 21.75 12 21.75C12.7832 21.75 13.4086 21.3869 13.9921 20.8609C14.5478 20.3599 15.1533 19.6287 15.8898 18.7392L19.9476 13.8386C20.7724 12.8427 21.428 12.0509 21.8855 11.3677C22.3542 10.6679 22.6664 10.0094 22.7328 9.27182C22.7871 8.66844 22.7127 8.06193 22.5149 7.48693C22.2741 6.7865 21.8149 6.21262 21.192 5.62799C20.5825 5.05591 19.7535 4.41769 18.7073 3.6123L18.7072 3.61226L18.6753 3.58766L18.6047 3.53329C18.0246 3.08651 17.63 2.78253 17.1681 2.58414C16.96 2.49476 16.7442 2.42277 16.5233 2.36883C16.0353 2.24972 15.527 2.24984 14.7673 2.25001L14.6771 2.25003H9.32289ZM10 7.75C9.58579 7.75 9.25 8.08579 9.25 8.5C9.25 8.91421 9.58579 9.25 10 9.25H14C14.4142 9.25 14.75 8.91421 14.75 8.5C14.75 8.08579 14.4142 7.75 14 7.75H10Z" fill="currentColor"></path>
                    </svg>
                    {{ balance.toLocaleString() }}
                  </span>
                </div>
                <div class="info-card highlight">
                  <span class="info-label">Valor da Rodada</span>
                  <span class="info-value">
                    <svg class="diamond-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                      <path fill-rule="evenodd" clip-rule="evenodd" d="M9.32289 2.25003L9.23265 2.25001C8.47304 2.24984 7.96465 2.24972 7.47672 2.36883C7.25578 2.42277 7.03998 2.49476 6.83189 2.58414C6.37 2.78253 5.97535 3.08651 5.39532 3.53329L5.32472 3.58766L5.29273 3.61228C4.24651 4.41768 3.41746 5.0559 2.80797 5.62799C2.1851 6.21262 1.72591 6.7865 1.48506 7.48693C1.28734 8.06193 1.21295 8.66844 1.26722 9.27182C1.33356 10.0094 1.64582 10.6679 2.11451 11.3677C2.57202 12.0509 3.22764 12.8427 4.05236 13.8386L4.05239 13.8387L4.05242 13.8387L8.11023 18.7392L8.11025 18.7392L8.11026 18.7392C8.84673 19.6287 9.45218 20.3599 10.0079 20.8609C10.5914 21.3869 11.2168 21.75 12 21.75C12.7832 21.75 13.4086 21.3869 13.9921 20.8609C14.5478 20.3599 15.1533 19.6287 15.8898 18.7392L19.9476 13.8386C20.7724 12.8427 21.428 12.0509 21.8855 11.3677C22.3542 10.6679 22.6664 10.0094 22.7328 9.27182C22.7871 8.66844 22.7127 8.06193 22.5149 7.48693C22.2741 6.7865 21.8149 6.21262 21.192 5.62799C20.5825 5.05591 19.7535 4.41769 18.7073 3.6123L18.7072 3.61226L18.6753 3.58766L18.6047 3.53329C18.0246 3.08651 17.63 2.78253 17.1681 2.58414C16.96 2.49476 16.7442 2.42277 16.5233 2.36883C16.0353 2.24972 15.527 2.24984 14.7673 2.25001L14.6771 2.25003H9.32289ZM10 7.75C9.58579 7.75 9.25 8.08579 9.25 8.5C9.25 8.91421 9.58579 9.25 10 9.25H14C14.4142 9.25 14.75 8.91421 14.75 8.5C14.75 8.08579 14.4142 7.75 14 7.75H10Z" fill="currentColor"></path>
                    </svg>
                    {{ roulettePrice }}
                  </span>
                </div>
            </div>

            <div class="roulette-description">
              <h3>Sorteio de Pelúcias</h3>
              <p>Tente a sorte para ganhar uma pelúcia exclusiva! Cada sorteio garante uma pelúcia aleatória da nossa coleção para você colecionar.</p>
            </div>

            <div class="sortable-area">
              <div 
                class="sortable-track" 
                :class="{ spinning: isSpinning, 'no-transition': resetTransition }"
                :style="isSpinning || wonItem ? { transform: `translateX(-563.25rem)` } : { transform: `translateX(-10.25rem)` }"
              >
                <div 
                  v-for="(item, index) in spinItems" 
                  :key="index" 
                  class="sortable-item" 
                  :class="[
                    { 
                      opaque: wonItem && index !== 80,
                      winning: wonItem && index === 80
                    },
                    item?.rarity ? `rarity-${item.rarity}` : ''
                  ]"
                >
                  <div class="roulette-visual-img" :style="{ backgroundImage: `url(${getPlushieImage(item)})` }"></div>
                  <span class="roulette-item-name" :title="item?.name">{{ item?.name }}</span>
                </div>
              </div>
              <div class="sortable-arrow-top"></div>
              <div class="sortable-arrow-bottom"></div>
            </div>

            <transition name="fade">
              <div v-if="wonItem" class="win-message-container">
                <p class="win-message-text">Você acaba de ganhar uma <span>{{ wonItem.name }}</span></p>
                <div v-if="showProgressBar" class="win-progress-bar">
                  <div class="win-progress-fill"></div>
                </div>
              </div>
            </transition>

            <div class="btn-container">
              <button 
                   class="spin-button" 
                   :disabled="isSpinning || showProgressBar || balance < roulettePrice"
                   @click="spinRoulette"
                 >
                   <template v-if="isSpinning || showProgressBar">
                     Aguarde...
                   </template>
                   <template v-else>
                     Girar Roleta 
                     <svg class="diamond-icon-small" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                       <path fill-rule="evenodd" clip-rule="evenodd" d="M9.32289 2.25003L9.23265 2.25001C8.47304 2.24984 7.96465 2.24972 7.47672 2.36883C7.25578 2.42277 7.03998 2.49476 6.83189 2.58414C6.37 2.78253 5.97535 3.08651 5.39532 3.53329L5.32472 3.58766L5.29273 3.61228C4.24651 4.41768 3.41746 5.0559 2.80797 5.62799C2.1851 6.21262 1.72591 6.7865 1.48506 7.48693C1.28734 8.06193 1.21295 8.66844 1.26722 9.27182C1.33356 10.0094 1.64582 10.6679 2.11451 11.3677C2.57202 12.0509 3.22764 12.8427 4.05236 13.8386L4.05239 13.8387L4.05242 13.8387L8.11023 18.7392L8.11025 18.7392L8.11026 18.7392C8.84673 19.6287 9.45218 20.3599 10.0079 20.8609C10.5914 21.3869 11.2168 21.75 12 21.75C12.7832 21.75 13.4086 21.3869 13.9921 20.8609C14.5478 20.3599 15.1533 19.6287 15.8898 18.7392L19.9476 13.8386C20.7724 12.8427 21.428 12.0509 21.8855 11.3677C22.3542 10.6679 22.6664 10.0094 22.7328 9.27182C22.7871 8.66844 22.7127 8.06193 22.5149 7.48693C22.2741 6.7865 21.8149 6.21262 21.192 5.62799C20.5825 5.05591 19.7535 4.41769 18.7073 3.6123L18.7072 3.61226L18.6753 3.58766L18.6047 3.53329C18.0246 3.08651 17.63 2.78253 17.1681 2.58414C16.96 2.49476 16.7442 2.42277 16.5233 2.36883C16.0353 2.24972 15.527 2.24984 14.7673 2.25001L14.6771 2.25003H9.32289ZM10 7.75C9.58579 7.75 9.25 8.08579 9.25 8.5C9.25 8.91421 9.58579 9.25 10 9.25H14C14.4142 9.25 14.75 8.91421 14.75 8.5C14.75 8.08579 14.4142 7.75 14 7.75H10Z" fill="currentColor"></path>
                     </svg>
                     {{ roulettePrice }}
                   </template>
                 </button>
            </div>
          </div>
        </div>
      </aside>
    </div>
  </Transition>
</template>

<style scoped>
.container {
  display: flex;
  align-items: center;
  height: 100%;
  padding: 4rem;
  position: relative;
  background-image: 
    linear-gradient(to right, rgba(13, 13, 13, 0.95) 0%, rgba(13, 13, 13, 0.85) 30%, rgba(13, 13, 13, 0.4) 50%, transparent 70%);
}

.bg-effects {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
  pointer-events: none;
  opacity: 0.5;
  overflow: hidden;
  -webkit-mask-image: linear-gradient(to right, #000 0%, #000 30%, rgba(0, 0, 0, 0) 65%);
  mask-image: linear-gradient(to right, #000 0%, #000 30%, rgba(0, 0, 0, 0) 65%);
  background-image: radial-gradient(circle at 20% 50%, rgba(255, 255, 255, 0.15), transparent 70%);
}

.shadow-circle {
  position: absolute;
  width: 60rem;
  height: 60rem;
  background-image: radial-gradient(circle, #ffffff, rgba(255, 255, 255, 0) 75%);
  border-radius: 50%;
}

.shadow-1 { top: -34.5rem; left: -30rem; opacity: 0.4; }
.shadow-2 { top: -17.5rem; left: -15.5rem; opacity: 0.2; }

.svg-bg {
  position: absolute;
  width: 50rem;
  height: 50rem;
  color: #ffffff;
}

.svg-1 { top: -25rem; left: -17.5rem; opacity: 0.05; }
.svg-2 { top: -29.5rem; left: -25rem; opacity: 0.5; }

.sidebar {
  position: relative;
  width: 25.875rem;
  height: 100%;
  max-height: 100%;
  display: flex;
  flex-direction: column;
  gap: 1rem; 
  z-index: 10;
  overflow: hidden;
}

.header h1 {
  font-size: 2.25rem;
  font-weight: 800;
  line-height: 2.5rem;
}

.header p {
  color: rgba(255, 255, 255, 0.3);
}

.nav-main {
  display: flex;
  gap: 0.5rem;
  background-color: rgb(var(--from) / 0.4);
  padding: 0.25rem;
  border-radius: 0.25rem;
}

.nav-main-item {
  flex: 1;
  padding: 0.75rem;
  border: none;
  background: transparent;
  color: rgba(255, 255, 255, 0.3);
  font-size: 0.85rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  cursor: pointer;
  border-radius: 0.2rem;
  transition: all 0.15s ease;
}

.nav-main-item.active {
  background-color: rgba(255, 255, 255, 0.12);
  color: #ffffff;
}

.nav-main-item.disabled {
  opacity: 0.5;
  pointer-events: none;
  filter: grayscale(0.5);
}

.nav-main-item:hover:not(.active):not(.disabled) {
  color: #ffffff;
}

.nav-categories {
  display: flex;
  gap: 0.5rem;
  overflow-x: auto;
  padding-bottom: 0.3rem; 
  margin: 0;
}

.nav-categories::-webkit-scrollbar {
  height: 2px;
}

.nav-categories::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 2px;
}

.nav-cat-item {
  padding: 0.5rem 1rem;
  border: 1px solid rgb(var(--from) / 0.1);
  background-color: rgb(var(--from) / 0.4);
  color: rgba(255, 255, 255, 0.5);
  font-size: 0.75rem;
  border-radius: 0.25rem;
  cursor: pointer;
  white-space: nowrap;
  transition: all 0.15s ease;
}

.nav-cat-item.active, .nav-cat-item:hover:not(.disabled) {
  border-color: rgba(255, 255, 255, 0.4);
  color: #ffffff;
  background-color: rgba(255, 255, 255, 0.1);
}

.nav-cat-item.disabled {
  opacity: 0.5;
  pointer-events: none;
  filter: grayscale(0.5);
}

.my-plushies-section {
  flex: 1;
  padding: 0.2rem;
  margin-top: 0;
  overflow-y: auto;
  overflow-x: hidden;
  min-height: 0;
}

.empty-plushies {
  margin: auto;
  text-align: center;
  color: rgba(255, 255, 255, 0.5);
}

.empty-plushies i {
  font-size: 4rem;
  margin-bottom: 1rem;
  opacity: 0.3;
}

.empty-plushies p {
  font-size: 1.2rem;
  font-weight: 500;
  color: white;
  margin-bottom: 0.5rem;
}

.empty-plushies span {
  font-size: 0.9rem;
}

.plushies-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr); 
  gap: 0.75rem;
  padding: 0.2rem;
}

.plushie-card-slot {
  position: relative;
  background: rgba(255, 255, 255, 0.02);
  border: 1px solid rgba(255, 255, 255, 0.05);
  border-radius: 0.5rem;
  aspect-ratio: 1/1.2;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
  overflow: hidden;
  padding: 0.5rem;
  cursor: pointer;
}

.plushie-card-bg {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 70%;
  height: 70%;
  background: radial-gradient(circle, rgb(var(--main) / 0.15) 0%, transparent 70%);
  z-index: 0;
  pointer-events: none;
}

.plushie-card-slot:hover {
  background: rgba(255, 255, 255, 0.05);
  border-color: rgba(var(--main) / 0.4);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
}

.plushie-card-slot.disabled {
  opacity: 0.7;
  pointer-events: none;
  filter: grayscale(0.3);
}

.plushie-card-slot.rarity-common {
  border-color: rgb(var(--rarity-common) / 0.3);
}
.plushie-card-slot.rarity-common .plushie-card-bg {
  background: radial-gradient(circle, rgb(var(--rarity-common) / 0.15) 0%, transparent 70%);
}

.plushie-card-slot.rarity-rare {
  border-color: rgb(var(--rarity-rare) / 0.4);
  background: linear-gradient(135deg, rgb(var(--rarity-rare) / 0.05), rgba(255, 255, 255, 0.02));
}
.plushie-card-slot.rarity-rare .plushie-card-bg {
  background: radial-gradient(circle, rgb(var(--rarity-rare) / 0.25) 0%, transparent 70%);
}

.plushie-card-slot.rarity-epic {
  border-color: rgb(var(--rarity-epic) / 0.5);
  background: linear-gradient(135deg, rgb(var(--rarity-epic) / 0.08), rgba(255, 255, 255, 0.02));
  box-shadow: inset 0 0 15px rgb(var(--rarity-epic) / 0.05);
}
.plushie-card-slot.rarity-epic .plushie-card-bg {
  background: radial-gradient(circle, rgb(var(--rarity-epic) / 0.3) 0%, transparent 70%);
}

.plushie-card-slot.rarity-legendary {
  border-color: rgb(var(--rarity-legendary) / 0.6);
  background: linear-gradient(135deg, rgb(var(--rarity-legendary) / 0.12), rgba(255, 255, 255, 0.02));
  box-shadow: inset 0 0 20px rgb(var(--rarity-legendary) / 0.08);
}
.plushie-card-slot.rarity-legendary .plushie-card-bg {
  background: radial-gradient(circle, rgb(var(--rarity-legendary) / 0.4) 0%, transparent 70%);
}

.plushie-card-slot.rarity-common:hover { border-color: rgb(var(--rarity-common) / 0.4); box-shadow: inset 0 0 10px rgb(var(--rarity-common) / 0.15); }
.plushie-card-slot.rarity-rare:hover { border-color: rgb(var(--rarity-rare) / 0.5); box-shadow: inset 0 0 12px rgb(var(--rarity-rare) / 0.2); }
.plushie-card-slot.rarity-epic:hover { border-color: rgb(var(--rarity-epic) / 0.6); box-shadow: inset 0 0 15px rgb(var(--rarity-epic) / 0.25); }
.plushie-card-slot.rarity-legendary:hover { border-color: rgb(var(--rarity-legendary) / 0.7); box-shadow: inset 0 0 20px rgb(var(--rarity-legendary) / 0.3); }

.plushie-card-slot.rarity-common:hover .plushie-card-bg { background: radial-gradient(circle, rgb(var(--rarity-common) / 0.2) 0%, transparent 70%); }
.plushie-card-slot.rarity-rare:hover .plushie-card-bg { background: radial-gradient(circle, rgb(var(--rarity-rare) / 0.25) 0%, transparent 70%); }
.plushie-card-slot.rarity-epic:hover .plushie-card-bg { background: radial-gradient(circle, rgb(var(--rarity-epic) / 0.3) 0%, transparent 70%); }
.plushie-card-slot.rarity-legendary:hover .plushie-card-bg { background: radial-gradient(circle, rgb(var(--rarity-legendary) / 0.35) 0%, transparent 70%); }

.plushie-card-slot:hover .plushie-card-bg {
  background: radial-gradient(circle, rgb(var(--main) / 0.25) 0%, transparent 70%);
}

.details-main-info.rarity-common { border-color: rgb(var(--rarity-common) / 0.2); background: linear-gradient(180deg, rgb(var(--rarity-common) / 0.03) 0%, rgba(255, 255, 255, 0.02) 100%); }
.details-main-info.rarity-rare { border-color: rgb(var(--rarity-rare) / 0.3); background: linear-gradient(180deg, rgb(var(--rarity-rare) / 0.05) 0%, rgba(255, 255, 255, 0.02) 100%); }
.details-main-info.rarity-epic { border-color: rgb(var(--rarity-epic) / 0.4); background: linear-gradient(180deg, rgb(var(--rarity-epic) / 0.08) 0%, rgba(255, 255, 255, 0.02) 100%); }
.details-main-info.rarity-legendary { border-color: rgb(var(--rarity-legendary) / 0.5); background: linear-gradient(180deg, rgb(var(--rarity-legendary) / 0.12) 0%, rgba(255, 255, 255, 0.02) 100%); }

.tags-container {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1rem; 
  justify-content: center;
  align-items: center;
}

.rarity-tag {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 0.65rem;
  font-weight: 700;
  padding: 0.35rem 0.9rem;
  border-radius: 0.2rem;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  line-height: normal;
  height: fit-content;
}

.id-tag {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.35rem 0.9rem;
  background: rgba(255, 255, 255, 0.05);
  color: rgba(255, 255, 255, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 0.2rem;
  font-size: 0.65rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  line-height: normal;
  height: fit-content;
}

.rarity-tag.rarity-common { color: rgb(var(--rarity-common)); border-color: rgb(var(--rarity-common) / 0.3); background: rgb(var(--rarity-common) / 0.1); }
.rarity-tag.rarity-rare { color: rgb(var(--rarity-rare)); border-color: rgb(var(--rarity-rare) / 0.3); background: rgb(var(--rarity-rare) / 0.1); }
.rarity-tag.rarity-epic { color: rgb(var(--rarity-epic)); border-color: rgb(var(--rarity-epic) / 0.3); background: rgb(var(--rarity-epic) / 0.1); }
.rarity-tag.rarity-legendary { color: rgb(var(--rarity-legendary)); border-color: rgb(var(--rarity-legendary) / 0.3); background: rgb(var(--rarity-legendary) / 0.1); }

.plushie-details-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(to bottom, rgb(var(--to) / 0.98), rgb(var(--from) / 0.99));
  z-index: 100;
  display: flex;
  flex-direction: column;
  padding: 2rem 1.5rem;
  border-radius: 0.25rem;
  border: 1px solid rgb(var(--main) / 0.15);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  transform: translateZ(0);
  backface-visibility: hidden;
  will-change: opacity;
}

.btn-back {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.15);
  color: #ffffff;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.85rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.15s ease;
  margin-bottom: 1rem;
  width: fit-content;
  padding: 0.75rem 1.25rem;
  border-radius: 0.2rem;
  text-transform: uppercase;
  letter-spacing: 0.1em;
}

.btn-back svg {
  transition: transform 0.2s ease;
}

.btn-back:hover svg {
  transform: translateX(-2px);
}

.btn-back:hover {
  background: rgba(255, 255, 255, 0.2);
  color: #ffffff;
}

.details-content {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.details-main-info {
  background: rgba(255, 255, 255, 0.02);
  border: 1px solid rgba(255, 255, 255, 0.05);
  border-radius: 0.5rem;
  padding: 1.5rem 1rem;
  margin-bottom: 1rem;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.details-image {
  width: 100%;
  height: 10rem;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 1rem;
}

.details-image img {
  max-width: 80%;
  max-height: 80%;
  object-fit: contain;
  filter: drop-shadow(0 10px 20px rgba(0, 0, 0, 0.5));
}

.details-info {
  text-align: center;
}

.details-info h2 {
  font-size: 1.5rem;
  font-weight: 800;
  margin-bottom: 0.5rem;
  color: white;
  letter-spacing: -0.02em;
}

.category-tag {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.35rem 0.9rem;
  background: rgba(255, 255, 255, 0.1);
  color: #ffffff;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 0.2rem;
  font-size: 0.65rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  line-height: normal;
  height: fit-content;
}

.details-world-count {
  margin-bottom: 1rem;
  background: rgba(255, 255, 255, 0.03);
  padding: 0.8rem 1rem;
  border-radius: 0.5rem;
  display: flex;
  align-items: center;
  gap: 0.8rem;
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.details-world-count i {
  color: #ffffff;
  font-size: 1rem;
  opacity: 0.9;
}

.details-world-count span {
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.6);
  font-weight: 500;
}

.details-world-count b {
  color: white;
  font-weight: 800;
}

.details-benefits {
  background: rgba(255, 255, 255, 0.02);
  border: 1px solid rgba(255, 255, 255, 0.05);
  border-radius: 0.5rem;
  padding: 1rem;
  margin-bottom: 1rem;
}

.details-benefits h3 {
  font-size: 0.8rem;
  text-transform: uppercase;
  color: #ffffff;
  margin-bottom: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.1em;
}

.benefits-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 0.5rem;
}

.benefit-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  background: rgba(255, 255, 255, 0.03);
  padding: 0.6rem 0.75rem;
  border-radius: 0.25rem;
}

.benefit-item i {
  color: #ffffff;
  font-size: 0.8rem;
  width: 1rem;
  text-align: center;
}

.benefit-item span {
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.6);
}

.benefit-info {
  display: flex;
  flex-direction: column;
  gap: 0.1rem;
}

.benefit-label {
  font-size: 0.7rem;
  color: rgba(255, 255, 255, 0.4);
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.benefit-value {
  font-size: 0.85rem;
  font-weight: 800;
  color: white;
}

.benefit-item.bonus-salary i {
  color: #4ade80;
  background: rgba(74, 222, 128, 0.1);
  width: 2.2rem;
  height: 2.2rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.5rem;
  font-size: 1rem;
}

.benefit-item.bonus-salary .benefit-value {
  color: #4ade80;
}

.benefit-item.bonus-illegal i {
  color: #f87171;
  background: rgba(248, 113, 113, 0.1);
  width: 2.2rem;
  height: 2.2rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.5rem;
  font-size: 1rem;
}

.benefit-item.bonus-illegal .benefit-value {
  color: #f87171;
}

.no-benefits p {
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.2);
  text-align: center;
  font-style: italic;
}

.details-actions {
  margin-top: auto;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 0.5rem;
  padding: 0.1rem;
}

.details-actions > :first-child:nth-last-child(odd) {
  grid-column: span 2;
}

.btn-details {
  width: 100%;
  padding: 0.8rem;
  border: none;
  border-radius: 0.25rem;
  font-size: 0.8rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  transition: all 0.2s ease;
}

.btn-details.equip {
  background-color: rgb(var(--accept-background));
  color: rgb(var(--accept-letter));
}

.btn-details.equip.active {
  background-color: rgb(var(--main));
  box-shadow: 0 0 14px rgba(var(--main), 0.55);
  border: 1px solid rgba(255, 255, 255, 0.45);
  filter: brightness(1.2);
}

.btn-details.unequip {
  background: rgba(255, 50, 50, 0.1);
  color: rgba(255, 80, 80, 0.8);
  border: 1px solid rgba(255, 50, 50, 0.2);
}

.btn-details.unequip:hover {
  background: rgba(255, 50, 50, 0.2);
  color: rgb(255, 100, 100);
}

.btn-details.transfer {
  background: rgb(255 255 255 / 0.02);
  color: rgba(255, 255, 255, 0.4);
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.btn-details:hover {
  filter: brightness(1.1);
}

.btn-details.equip:hover {
  background-color: rgb(var(--accept-background-hover));
}

.btn-details.transfer:hover {
  color: white;
  border-color: rgba(255, 255, 255, 0.2);
  background: rgb(255 255 255 / 0.05);
}

.plushie-image {
  width: 100%;
  height: 70%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 0.25rem;
  z-index: 1;
}

.plushie-image img {
  max-width: 85%;
  max-height: 85%;
  object-fit: contain;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.3));
}

.plushie-info {
  width: 100%;
  text-align: center;
  display: flex;
  flex-direction: column;
  gap: 0.2rem;
  z-index: 1;
}

.plushie-info h3 {
  font-size: 0.6rem;
  font-weight: 700;
  color: rgba(255, 255, 255, 0.8);
  text-transform: uppercase;
  letter-spacing: 0.02em;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.plushie-card .amount {
  display: none;
}

.my-plushies-section::-webkit-scrollbar {
  width: 2px;
}

.my-plushies-section::-webkit-scrollbar-track {
  background: transparent;
}

.my-plushies-section::-webkit-scrollbar-thumb {
  background: rgb(var(--main) / 0.3);
  border-radius: 2px;
}

.roulette-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  background-color: rgb(var(--from) / 0.2);
  border-radius: 0.25rem;
  border: 1px solid rgb(var(--from) / 0.1);
  overflow: hidden;
}

.roulette-content {
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  height: 100%;
}

.roulette-info {
  display: flex;
  gap: 1rem;
}

.info-card {
  flex: 1;
  background-color: rgb(var(--from) / 0.4);
  padding: 1rem;
  border-radius: 0.25rem;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  border: 1px solid rgb(var(--from) / 0.1);
}

.info-card.highlight {
  border-color: rgba(255, 255, 255, 0.25);
  background-color: rgba(255, 255, 255, 0.08);
}

.info-label {
  font-size: 0.7rem;
  text-transform: uppercase;
  color: #ffffff80;
  letter-spacing: 0.05em;
}

.info-value {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 1.1rem;
  font-weight: 700;
  color: #ffffff;
}

.diamond-icon {
  width: 14px;
  height: 14px;
  flex-shrink: 0;
  color: #ffffff;
  filter: drop-shadow(0 0 5px rgba(255, 255, 255, 0.6));
}

.diamond-icon-small {
  width: 12px;
  height: 12px;
  flex-shrink: 0;
  color: #fff;
  margin-right: 4px;
  vertical-align: middle;
}

.spin-button {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  width: 100%;
  padding: 0.85rem;
  background-color: rgba(255, 255, 255, 0.15);
  border: 1px solid rgba(255, 255, 255, 0.25);
  color: white;
  border-radius: 0.25rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 0.8rem;
}

.spin-button:hover:not(:disabled) {
  background-color: rgba(255, 255, 255, 0.25);
  border-color: rgba(255, 255, 255, 0.45);
  color: #ffffff;
  filter: brightness(1.1);
}

.spin-button:disabled {
  opacity: 0.4;
  filter: grayscale(0.5);
  cursor: not-allowed;
}

.roulette-description {
  background-color: rgba(255, 255, 255, 0.04);
  padding: 1rem;
  border-radius: 0.25rem;
  border-left: 3px solid rgba(255, 255, 255, 0.4);
}

.roulette-description h3 {
  font-size: 0.9rem;
  font-weight: 700;
  margin-bottom: 0.4rem;
  color: white;
}

.roulette-description p {
  font-size: 0.8rem;
  color: rgba(255, 255, 255, 0.4);
  line-height: 1.4;
}

.sortable-area {
  position: relative;
  height: 9rem;
  background-color: rgb(0 0 0 / 0.2);
  border-radius: 0.25rem;
  overflow: hidden;
  border: 1px solid rgb(255 255 255 / 0.05);
  display: flex;
  align-items: center;
  justify-content: flex-start; 
}

.sortable-track {
  position: absolute;
  left: 50%;
  display: flex;
  gap: 0.5rem;
  transition: transform 5s cubic-bezier(0.15, 0, 0, 1);
  align-items: center;
  will-change: transform;
}

.sortable-track.no-transition {
  transition: none !important;
}

.sortable-track.spinning {
}

.sortable-item {
  position: relative;
  width: 6.5rem;
  height: 6.5rem;
  flex-shrink: 0;
  background-color: rgb(var(--from) / 0.6);
  border-radius: 0.25rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid rgb(255 255 255 / 0.05);
  transition: all 0.4s ease;
  box-sizing: border-box;
}

.sortable-item.rarity-common { border-color: rgb(var(--rarity-common) / 0.2); background-color: rgb(var(--rarity-common) / 0.05); }
.sortable-item.rarity-rare { border-color: rgb(var(--rarity-rare) / 0.3); background-color: rgb(var(--rarity-rare) / 0.08); }
.sortable-item.rarity-epic { border-color: rgb(var(--rarity-epic) / 0.4); background-color: rgb(var(--rarity-epic) / 0.12); }
.sortable-item.rarity-legendary { border-color: rgb(var(--rarity-legendary) / 0.5); background-color: rgb(var(--rarity-legendary) / 0.15); }

.sortable-item.winning {
  border: 0.5px solid #ffd700 !important;
  box-shadow: 0 0 5px rgba(255, 215, 0, 0.4), inset 0 0 5px rgba(255, 215, 0, 0.2) !important;
  z-index: 10;
  background-color: rgb(var(--from) / 0.7);
  opacity: 1 !important;
  animation: neonPulse 1.5s infinite alternate ease-in-out;
}

@keyframes neonPulse {
  from {
    box-shadow: 0 0 2px rgba(255, 215, 0, 0.2), inset 0 0 2px rgba(255, 215, 0, 0.1);
    border-color: rgba(255, 215, 0, 0.5);
  }
  to {
    box-shadow: 0 0 10px rgba(255, 215, 0, 0.6), inset 0 0 8px rgba(255, 215, 0, 0.3);
    border-color: rgba(255, 215, 0, 1);
  }
}

.sortable-item.opaque {
  opacity: 0.3;
  filter: grayscale(0.8);
}

.roulette-visual-img {
  width: 80%;
  height: 62%;
  margin-bottom: 1.4rem;
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
  filter: drop-shadow(0 0 5px rgba(0,0,0,0.5));
}

.roulette-item-name {
  position: absolute;
  bottom: 0.35rem;
  left: 0.3rem;
  right: 0.3rem;
  color: #fff;
  font-size: 0.65rem;
  font-weight: 700;
  line-height: 1.2;
  text-align: center;
  overflow-wrap: anywhere;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.roulette-visual {
  font-size: 2rem;
  font-weight: 800;
  color: rgb(var(--main) / 0.2);
}

.sortable-arrow-top {
  position: absolute;
  top: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 0;
  height: 0;
  border-left: 6px solid transparent;
  border-right: 6px solid transparent;
  border-top: 10px solid #ffffff;
  filter: drop-shadow(0 0 4px rgba(255, 255, 255, 0.6));
  z-index: 5;
}

.sortable-arrow-bottom {
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 0;
  height: 0;
  border-left: 6px solid transparent;
  border-right: 6px solid transparent;
  border-bottom: 10px solid #ffffff;
  filter: drop-shadow(0 0 4px rgba(255, 255, 255, 0.6));
  z-index: 5;
}

 .win-label-container {
    display: none;
 }

 .win-message-container {
   width: 100%;
   text-align: center;
   margin-top: -0.5rem;
   animation: slideUp 0.4s ease-out;
 }

 .win-message-text {
   color: rgba(255, 255, 255, 0.7);
   font-size: 0.85rem;
   font-weight: 500;
 }

 .win-message-text span {
   color: #ffd700;
   font-weight: 800;
   text-transform: uppercase;
   text-shadow: 0 0 10px rgba(255, 215, 0, 0.3);
 }

 .win-progress-bar {
   width: 100%;
   height: 4px;
   background: rgba(255, 255, 255, 0.1);
   border-radius: 2px;
   margin-top: 1rem;
   overflow: hidden;
 }

 .win-progress-fill {
   height: 100%;
   background: #ffffff;
   width: 100%;
   animation: progressFill 5s linear forwards;
   box-shadow: 0 0 10px rgba(255, 255, 255, 0.7);
 }

 @keyframes progressFill {
   from { width: 0%; }
   to { width: 100%; }
 }

 @keyframes slideUp {
   from { transform: translateY(10px); opacity: 0; }
   to { transform: translateY(0); opacity: 1; }
 }

.btn-container {
  display: flex;
  justify-content: center;
  width: 100%;
  margin-top: auto;
}

.empty-state {
  text-align: center;
  color: rgba(255, 255, 255, 0.2);
  font-size: 0.9rem;
  font-weight: 500;
}



*:disabled {
  cursor: default !important;
}

.slide-enter-active,
.slide-leave-active {
  transition: all 0.6s cubic-bezier(0.16, 1, 0.3, 1);
}

.slide-enter-from {
  opacity: 0;
  transform: translateX(-100%);
}

.slide-leave-to {
  opacity: 0;
  transform: translateX(-100%);
}

.fade-enter-active {
  transition: opacity 0.2s ease-out;
}

.fade-leave-active {
  transition: opacity 0.1s ease-in;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
