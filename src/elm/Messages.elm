module Messages exposing (Msg(..))

import Time exposing (Time)
import Models exposing (ScoreBoardStatus, Score)
import Tetris.Messages
import Boggle.Messages


type Msg
    = NoOp
    | Tick Time
    | StartGame
    | WindowSizeFail
    | WindowSizeDone { height : Int, width : Int }
    | SetName String
    | SetScores (List Score)
    | SetScoreBoardStatus ScoreBoardStatus
    | TetrisMsg Tetris.Messages.Msg
    | BoggleMsg Boggle.Messages.Msg
