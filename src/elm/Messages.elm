module Messages exposing (Msg(..))

import Time exposing (Time)
import Tetris.Messages
import Boggle.Messages


type Msg
    = NoOp
    | Tick Time
    | StartGame
    | TetrisMsg Tetris.Messages.Msg
    | BoggleMsg Boggle.Messages.Msg
