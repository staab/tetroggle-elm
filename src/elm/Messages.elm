module Messages exposing (Msg(..))

import Time exposing (Time)
import Tetris.Messages

type Msg
  = NoOp
  | Tick Time
  | TetrisMsg Tetris.Messages.Msg
