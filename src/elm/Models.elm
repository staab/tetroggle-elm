module Models exposing (..)

import Random.Pcg exposing (Seed)
import Tetris.Models
import Boggle.Models

type alias Flags =
  { seed : Int }

type alias Model =
  { tetris : Tetris.Models.Model
  , boggle : Boggle.Models.Model
  , seed : Seed }

initialModel : Seed -> Model
initialModel seed =
  { tetris = Tetris.Models.initialModel
  , boggle = Boggle.Models.initialModel
  , seed = seed
  }