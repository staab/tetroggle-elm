module Models exposing (..)

import Random.Pcg exposing (Seed)
import Tetris.Models
import Boggle.Models


type alias Score =
    { elapsed : Int
    , score : Int
    , name : String
    }


type ScoreBoardStatus
    = Prompt
    | Unsubmitted
    | Submitting
    | Submitted


type alias Flags =
    { seed : Int
    , dictionary : String
    , startTime : Float
    , name : String
    }


type alias Model =
    { tetris : Tetris.Models.Model
    , boggle : Boggle.Models.Model
    , seed : Seed
    , dictionary : List String
    , elapsed : Float
    , startTime : Float
    , scoreBoardStatus : ScoreBoardStatus
    , name : String
    , scores : List Score
    , windowSize : { height : Int, width : Int }
    }


initialModel : Seed -> List String -> Float -> String -> Model
initialModel seed dictionary startTime name =
    { tetris = Tetris.Models.initialModel
    , boggle = Boggle.Models.initialModel
    , seed = seed
    , dictionary = dictionary
    , elapsed = 0.0
    , startTime = startTime
    , scoreBoardStatus = Prompt
    , name = name
    , scores = []
    , windowSize = { height = 0, width = 0 }
    }
