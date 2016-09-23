module Tetris.Subscriptions exposing (subscriptions)

import Time exposing (every, millisecond)
import Keyboard
import Tetris.Models exposing (Model)
import Tetris.Messages exposing (Msg(Tick, KeyPress))

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ every (300 * millisecond) Tick
    , Keyboard.downs KeyPress
    ]