module Subscriptions exposing (subscriptions)

import Time exposing (every, millisecond)
import Models exposing (Model)
import Ports exposing (scores)
import Messages exposing (Msg(Tick, TetrisMsg, BoggleMsg, SetScores))
import Tetris.Subscriptions
import Boggle.Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ every (100 * millisecond) Tick
        , Tetris.Subscriptions.subscriptions model.tetris |> Sub.map TetrisMsg
        , Boggle.Subscriptions.subscriptions model.boggle |> Sub.map BoggleMsg
        , scores SetScores
        ]
