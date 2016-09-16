module Tetris.Subscriptions exposing (subscriptions)

import Time exposing (every, second)
import Tetris.Models exposing (Model)
import Tetris.Messages exposing (Msg(..))

subscriptions : Model -> Sub Msg
subscriptions model =
  every second Tick