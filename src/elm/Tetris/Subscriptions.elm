module Tetris.Subscriptions exposing (subscriptions)

import Time exposing (every, millisecond)
import Tetris.Models exposing (Model)
import Tetris.Messages exposing (Msg(..))

subscriptions : Model -> Sub Msg
subscriptions model =
  every (300 * millisecond) Tick