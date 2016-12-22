module Boggle.Models exposing (Model, initialModel)


type alias Model =
    { input : String
    , paused : Bool
    }


initialModel : Model
initialModel =
    { input = ""
    , paused = True
    }
