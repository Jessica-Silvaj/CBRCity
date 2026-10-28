<script setup>
import { useSettingsStore } from "@stores/settings";
import { themeState } from "@stores/theme";
import Key from "./Key.vue";
import ArrowUp from "@icons/ArrowUp.vue";
import ArrowDown from "@icons/ArrowDown.vue";
import ArrowLeft from "@icons/ArrowLeft.vue";
import ArrowRight from "@icons/ArrowRight.vue";
import Windows from "@icons/Windows.vue";

// ==================== PAINEL DE ATALHOS ====================
// Teclado completo. As teclas com atalho configurado (Shortcuts no
// shared-side/shared.lua) ganham o anel na cor do tema e o tooltip com o
// texto do atalho no hover.
</script>

<template>
    <div
        :class="[
            'flex items-stretch p-4 rounded-lg backdrop-blur-[0.5rem] w-[70rem]',
            themeState.loading?.mode === 'light' ? 'bg-white/10' : 'bg-from/40',
        ]"
    >
        <div class="flex-1 grid grid-cols-[repeat(36,minmax(0,1fr))] auto-rows-min">
            <!-- Linha de função -->
            <Key top identifier="ESC">Esc</Key>
            <Key top transparent />
            <Key top identifier="F1">F1</Key>
            <Key top identifier="F2">F2</Key>
            <Key top identifier="F3">F3</Key>
            <Key top identifier="F4">F4</Key>
            <Key top transparent :col-span="1" />
            <Key top identifier="F5">F5</Key>
            <Key top identifier="F6">F6</Key>
            <Key top identifier="F7">F7</Key>
            <Key top identifier="F8">F8</Key>
            <Key top transparent :col-span="1" />
            <Key top identifier="F9">F9</Key>
            <Key top identifier="F10">F10</Key>
            <Key top identifier="F11">F11</Key>
            <Key top identifier="F12">F12</Key>
            <Key top identifier="PRINTSCREEN" xsmall>Print<br />Screen</Key>
            <Key top identifier="SCROLLLOCK" small>Scroll<br />Lock</Key>
            <Key top identifier="PAUSEBREAK" small>Pause<br />Break</Key>

            <!-- Números -->
            <Key identifier="&quot;">&quot;</Key>
            <Key identifier="1">1</Key>
            <Key identifier="2">2</Key>
            <Key identifier="3">3</Key>
            <Key identifier="4">4</Key>
            <Key identifier="5">5</Key>
            <Key identifier="6">6</Key>
            <Key identifier="7">7</Key>
            <Key identifier="8">8</Key>
            <Key identifier="9">9</Key>
            <Key identifier="0">0</Key>
            <Key identifier="-">-</Key>
            <Key identifier="=">=</Key>
            <Key identifier="BACKSPACE" :col-span="4">Backspace</Key>
            <Key identifier="INSERT" small>Insert</Key>
            <Key identifier="HOME" small>Home</Key>
            <Key identifier="PAGEUP" small>PgUp</Key>

            <!-- Letras -->
            <Key identifier="TAB" :col-span="3">Tab</Key>
            <Key identifier="Q">Q</Key>
            <Key identifier="W">W</Key>
            <Key identifier="E">E</Key>
            <Key identifier="R">R</Key>
            <Key identifier="T">T</Key>
            <Key identifier="Y">Y</Key>
            <Key identifier="U">U</Key>
            <Key identifier="I">I</Key>
            <Key identifier="O">O</Key>
            <Key identifier="P">P</Key>
            <Key identifier="´">´</Key>
            <Key identifier="[">[</Key>
            <Key enter :col-span="3">Enter</Key>
            <Key identifier="DELETE" small>Del</Key>
            <Key identifier="END" small>End</Key>
            <Key identifier="PAGEDOWN" small>PgDn</Key>

            <!-- Linha do meio -->
            <Key identifier="CAPSLOCK" :col-span="4">Caps Lock</Key>
            <Key identifier="A">A</Key>
            <Key identifier="S">S</Key>
            <Key identifier="D">D</Key>
            <Key identifier="F">F</Key>
            <Key identifier="G">G</Key>
            <Key identifier="H">H</Key>
            <Key identifier="J">J</Key>
            <Key identifier="K">K</Key>
            <Key identifier="L">L</Key>
            <Key identifier="Ç">Ç</Key>
            <Key identifier="~">~</Key>
            <Key identifier="]">]</Key>
            <Key bottom-enter />
            <Key transparent :col-span="6" />

            <!-- Shift -->
            <Key identifier="LSHIFT" :col-span="3">Shift</Key>
            <Key identifier="\">\</Key>
            <Key identifier="Z">Z</Key>
            <Key identifier="X">X</Key>
            <Key identifier="C">C</Key>
            <Key identifier="V">V</Key>
            <Key identifier="B">B</Key>
            <Key identifier="N">N</Key>
            <Key identifier="M">M</Key>
            <Key identifier=",">,</Key>
            <Key identifier=".">.</Key>
            <Key identifier=";">;</Key>
            <Key identifier="/">/</Key>
            <Key identifier="RSHIFT" :col-span="3">Shift</Key>
            <Key transparent />
            <Key identifier="UP"><ArrowUp class="w-4 h-4" /></Key>
            <Key transparent />

            <!-- Linha inferior -->
            <Key identifier="LCTRL" :col-span="3">Ctrl</Key>
            <Key><Windows class="w-4 h-4" /></Key>
            <Key identifier="LALT">Alt</Key>
            <Key identifier="SPACEBAR" :col-span="16">Spacebar</Key>
            <Key identifier="RALT">Alt</Key>
            <Key>Fn</Key>
            <Key identifier="RCTRL" :col-span="3">Ctrl</Key>
            <Key identifier="LEFT"><ArrowLeft class="w-4 h-4" /></Key>
            <Key identifier="DOWN"><ArrowDown class="w-4 h-4" /></Key>
            <Key identifier="RIGHT"><ArrowRight class="w-4 h-4" /></Key>
        </div>
    </div>
</template>
