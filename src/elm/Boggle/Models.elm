module Boggle.Models exposing (Model, initialModel)


type alias Model =
    { input : String
    , pastWords : List String
    , paused : Bool
    , score : Int
    }


initialModel : Model
initialModel =
    { input = ""
    , pastWords = []
    , paused = True
    , score = 0
    }
