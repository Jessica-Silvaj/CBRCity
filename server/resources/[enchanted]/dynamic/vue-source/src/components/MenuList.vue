<script setup>
import { computed } from "vue";
import { useDynamicStore } from "@stores/dynamic";
import fetchNui from "@utils/fetchNui";
import MenuItem from "@components/MenuItem.vue";

const dynamic = useDynamicStore();

const headerTitle = computed(() => dynamic.currentParentMenu?.title || null);

const listItems = computed(() => {
  const items = [];
  if (dynamic.isSubmenu) {
    items.push({
      type: "back",
      title: "Voltar",
      description: headerTitle.value
        ? `Voltar para ${headerTitle.value}`
        : "Voltar.",
      index: -1,
    });
  }
  for (let i = 0; i < dynamic.currentItems.length; i++) {
    items.push({ ...dynamic.currentItems[i], index: i });
  }
  return items;
});

const contentKey = computed(() => dynamic.currentParent || "__root__");

function handleItemAction(item) {
  if (item.type === "back") { dynamic.goBack(); return; }
  if (item.type === "menu") { dynamic.navigateTo(item.id); return; }
  if (item.type === "progress") { return; }
  // Buttons without trigger are read-only — do nothing
  if (!item.trigger || item.trigger === "") { return; }
  fetchNui("Clicked", { Trigger: item.trigger, Param: item.param, Server: item.server });
  dynamic.close();
  fetchNui("Close");
}
</script>

<template>
  <div
    class="absolute left-10 z-50 w-96 flex flex-col min-h-0"
    style="top: 50%; transform: translateY(-50%); max-height: 80vh"
  >
    <!-- Panel open/close -->
    <transition name="panel">
      <div v-show="dynamic.display" class="w-96 flex flex-col min-h-0 gap-2">
        <!-- Submenu swap -->
        <Transition name="slide" mode="out-in">
          <div :key="contentKey" class="flex flex-col min-h-0 gap-2">
            <div class="flex-1 min-h-0 overflow-y-auto scrollbar-hide pr-1 mt-2" style="contain: content; overscroll-behavior: contain">
              <div class="flex flex-col gap-1.5">
                <MenuItem
                  v-for="(item, index) in listItems"
                  :key="`${item.type}-${item.title}-${index}`"
                  :title="item.title"
                  :description="item.description"
                  :type="item.type"
                  :menu-id="item.id"
                  :trigger="item.trigger"
                  :param="item.param"
                  :server="item.server"
                  :back="item.back"
                  :value="item.value"
                  :image="item.image"
                  :index="item.type === 'back' ? 0 : index"
                  @action="handleItemAction(item)"
                />
              </div>
            </div>
          </div>
        </Transition>
      </div>
    </transition>
  </div>
</template>
