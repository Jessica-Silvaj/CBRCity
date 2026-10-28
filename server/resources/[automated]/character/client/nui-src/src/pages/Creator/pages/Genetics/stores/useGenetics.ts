import { create } from "zustand";

type Data = {
  name: string;
  surname: string;
  age: string;
  gender: string;
  father: number;
  mother: number;
  father2: number;
  mother2: number;
  paternity: number;
  color: number;
  parentsReady: boolean;
};

interface NuiFrame {
  current: Data;

  setName: (name: string) => void;
  setSurname: (surname: string) => void;
  setAge: (age: string) => void;
  setGender: (gender: string) => void;
  setFather: (father: number) => void;
  setMother: (mother: number) => void;
  setFather2: (father2: number) => void;
  setMother2: (mother2: number) => void;
  setPaternity: (paternity: number) => void;
  setColor: (color: number) => void;
  setParentsReady: (parentsReady: boolean) => void;
}

export const useGenetics = create<NuiFrame>((set) => ({
  current: {
    name: "",
    surname: "",
    age: "",
    gender: "m",
    father: 0,
    mother: 0,
    father2: -1,
    mother2: -1,
    paternity: 50,
    color: 0,
    parentsReady: false
  },

  setName: (name) => set((state) => ({ current: { ...state.current, name } })),
  setSurname: (surname) =>
    set((state) => ({ current: { ...state.current, surname } })),
  setAge: (age) => set((state) => ({ current: { ...state.current, age } })),
  setGender: (gender) =>
    set((state) => ({ current: { ...state.current, gender } })),
  setFather: (father) =>
    set((state) => ({ current: { ...state.current, father } })),
  setMother: (mother) =>
    set((state) => ({ current: { ...state.current, mother } })),
  setFather2: (father2) =>
    set((state) => ({ current: { ...state.current, father2 } })),
  setMother2: (mother2) =>
    set((state) => ({ current: { ...state.current, mother2 } })),
  setPaternity: (paternity) =>
    set((state) => ({ current: { ...state.current, paternity } })),
  setColor: (color) =>
    set((state) => ({ current: { ...state.current, color } })),
  setParentsReady: (parentsReady) =>
    set((state) => ({ current: { ...state.current, parentsReady } })),
}));
