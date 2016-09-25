module Tetris.Subscriptions exposing (subscriptions)

import Time exposing (every, millisecond)
import Keyboard
import Window
import Tetris.Models exposing (Model)
import Tetris.Messages exposing (Msg(Tick, KeyPress, WindowHeightDone))

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ every (300 * millisecond) Tick
    , Keyboard.downs KeyPress
    , Window.resizes (\{height} -> WindowHeightDone height)
    ]