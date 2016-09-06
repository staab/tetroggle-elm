module Model exposing (..)

import Random.Pcg exposing (Seed)
import Tetris.Models

type alias Flags =
  { seed : Int }

type alias Model =
  { tetris : Tetris.Models.Model
  , seed : Seed }

initialModel : Seed -> Model
initialModel seed =
  { tetris = Tetris.Models.initialModel
  , seed = seed
  }