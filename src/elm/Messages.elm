module Messages exposing (Msg(..))

import Time exposing (Time)
import Models exposing (ScoreBoardStatus, Score)
import Tetris.Messages
import Boggle.Messages


type Msg
    = NoOp
    | Tick Time
    | StartGame
    | SetName String
    | SetScores (List Score)
    | SetScoreBoardStatus ScoreBoardStatus
    | TetrisMsg Tetris.Messages.Msg
    | BoggleMsg Boggle.Messages.Msg
