import { defineStore } from "pinia";

let closeTimer = null;

export const useDynamicStore = defineStore("dynamic", {
  state: () => ({
    visible: false,
    display: false,
    menus: [],
    buttons: [],
    progressItems: [],
    currentParent: null,
    history: [],
  }),

  getters: {
    currentItems() {
      const items = [];
      for (const menu of this.menus) {
        if (menu.parentId === this.currentParent) {
          items.push({ type: "menu", ...menu });
        }
      }
      for (const btn of this.buttons) {
        if (btn.parentId === this.currentParent) {
          items.push({ type: "button", ...btn });
        }
      }
      for (const prog of this.progressItems) {
        if (prog.parentId === this.currentParent) {
          items.push({ type: "progress", ...prog });
        }
      }
      return items;
    },
    isSubmenu() {
      return this.currentParent !== null;
    },
    currentParentMenu() {
      if (!this.currentParent) return null;
      return this.menus.find((m) => m.id === this.currentParent) || null;
    },
  },

  actions: {
    open() {
      if (closeTimer) { clearTimeout(closeTimer); closeTimer = null; }
      this.currentParent = null;
      this.history = [];
      this.visible = true;
      this.display = true;
    },

    close() {
      this.display = false;
      closeTimer = setTimeout(() => {
        this.visible = false;
        this.menus = [];
        this.buttons = [];
        this.progressItems = [];
        this.currentParent = null;
        this.history = [];
        closeTimer = null;
      }, 150);
    },

    addMenu(title, description, id, parentId, image) {
      this.menus.push({ id, title, description, parentId: parentId || null, image: image || null });
    },

    addButton(title, description, trigger, param, parentId, server, back) {
      this.buttons.push({
        title,
        description,
        trigger: trigger || "",
        param: param ?? null,
        parentId: parentId || null,
        server: !!server,
        back: !!back,
      });
    },

    addProgress(title, description, value, parentId) {
      this.progressItems.push({
        title,
        description,
        value: Math.min(100, Math.max(0, Number(value) || 0)),
        parentId: parentId || null,
      });
    },

    navigateTo(menuId) {
      this.history.push(this.currentParent);
      this.currentParent = menuId;
    },

    goBack() {
      if (this.history.length > 0) {
        this.currentParent = this.history.pop();
      } else {
        this.currentParent = null;
      }
    },
  },
});
