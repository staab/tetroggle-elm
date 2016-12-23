port module Ports exposing (addScore, scores, setName)

import Models exposing (Score)


port addScore : Score -> Cmd msg


port scores : (List Score -> msg) -> Sub msg


port setName : String -> Cmd msg
