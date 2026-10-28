import Folder from "@icons/Folder.vue";
import Shirt from "@icons/Shirt.vue";
import Person from "@icons/Person.vue";
import Door from "@icons/Door.vue";
import Laptop from "@icons/Laptop.vue";
import Dots from "@icons/Dots.vue";
import Siren from "@icons/Siren.vue";
import Badge from "@icons/Badge.vue";
import House from "@icons/House.vue"

/**
 * Maps menu IDs to their icon components.
 * Falls back to Folder for unmapped menus.
 * Buttons no longer display icons.
 */
const menuIcons = {
  wardrobe: Folder,
  clothes: Shirt,
  closestpeds: Person,
  player: Person,
  doors: Door,
  painel: Laptop,
  others: Dots,
  tencode: Siren,
  prePolice: Badge,
  preMedic: Badge,
  vehicle: Door,
  // Property interiors
  amethyst: House,
  amber: House,
  sapphire: House,
  emerald: House,
  topaz: House,
  opal: House,
  jade: House,
  pearl: House,
  aquamarine: House,
  turquoise: House,
  onyx: House,
};

export function getIcon(type, id) {
  if (type === "menu") {
    return menuIcons[id] || Folder;
  }
  return null;
}
