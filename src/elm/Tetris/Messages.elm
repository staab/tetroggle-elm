module Tetris.Messages exposing (Msg(..))

import Time exposing (Time)
import Keyboard exposing (KeyCode)

type Msg
  = Tick Time
  | KeyPress KeyCode
  | WindowHeightFail
  | WindowHeightDone Int