module Models exposing (..)

import String exposing (lines)
import Random.Pcg exposing (Seed)
import Tetris.Models
import Boggle.Models


type alias Flags =
    { seed : Int
    , dictionary : String
    , startTime : Float
    }


type alias Model =
    { tetris : Tetris.Models.Model
    , boggle : Boggle.Models.Model
    , seed : Seed
    , dictionary : List String
    , elapsed : Float
    , startTime : Float
    }


initialModel : Seed -> String -> Float -> Model
initialModel seed dictionary startTime =
    { tetris = Tetris.Models.initialModel
    , boggle = Boggle.Models.initialModel
    , seed = seed
    , dictionary = lines dictionary
    , elapsed = 0.0
    , startTime = startTime
    }
