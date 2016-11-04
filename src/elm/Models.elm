module Models exposing (..)

import String exposing (lines)
import Random.Pcg exposing (Seed)
import Tetris.Models
import Boggle.Models

type alias Flags =
  { seed : Int
  , dictionary : String }

type alias Model =
  { tetris : Tetris.Models.Model
  , boggle : Boggle.Models.Model
  , seed : Seed
  , dictionary : List String }

initialModel : Seed -> String -> Model
initialModel seed dictionary =
  { tetris = Tetris.Models.initialModel
  , boggle = Boggle.Models.initialModel
  , seed = seed
  , dictionary = lines dictionary
  }