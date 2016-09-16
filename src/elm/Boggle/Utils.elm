module Boggle.Utils exposing (randomLetter)

import Array
import Utils exposing (fromJust)
import Random.Pcg exposing (int, map, Generator, step, Seed)

chars : Array.Array String
chars = Array.fromList [
  "A", "A", "A", "A", "A", "A", "B", "B", "C", "C", "D", "D", "D", "E", "E",
  "E", "E", "E", "E", "E", "E", "E", "E", "E", "F", "F", "G", "G", "H", "H",
  "H", "H", "H", "I", "I", "I", "I", "I", "I", "J", "K", "L", "L", "L", "L",
  "M", "M", "N", "N", "N", "N", "N", "N", "O", "O", "O", "O", "O", "O", "O",
  "P", "P", "QU", "R", "R", "R", "R", "R", "S", "S", "S", "S", "S", "S", "T",
  "T", "T", "T", "T", "T", "T", "T", "T", "U", "U", "U", "V", "V", "W", "W",
  "W", "X", "Y", "Y", "Y", "Z"]

letterGenerator : Generator (Maybe String)
letterGenerator =
  map (\n -> Array.get n chars) ( int 0 ( Array.length chars ) )

randomLetter : Seed -> (String, Seed)
randomLetter seed =
  let
    ( letter, seed ) = step letterGenerator seed
  in
    ( fromJust letter, seed )