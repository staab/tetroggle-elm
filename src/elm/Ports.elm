port module Ports exposing (addScore, scores)

import Models exposing (Score)


port addScore : Score -> Cmd msg


port scores : (List Score -> msg) -> Sub msg
