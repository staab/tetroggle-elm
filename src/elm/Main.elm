import Html.App as Html

import Random.Pcg exposing (initialSeed)
import Models exposing (Flags, Model, initialModel)
import Messages exposing (Msg(..))
import Views exposing (view)
import Tetris.Commands exposing (getWindowHeight)
import Tetris.Update
import Tetris.Highlight
import Tetris.Subscriptions
import Tetris.Messages
import Boggle.Update
import Boggle.Messages
import Boggle.Subscriptions

init : Flags -> (Model, Cmd Msg)
init flags =
  let
    seed = initialSeed flags.seed
  in
    ( initialModel seed, Cmd.map TetrisMsg getWindowHeight )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      ( model, Cmd.none )

    TetrisMsg subMsg ->
      updateTetris subMsg model

    BoggleMsg subMsg ->
      updateBoggle subMsg model

updateTetris : Tetris.Messages.Msg -> Model -> (Model, Cmd Msg)
updateTetris msg model =
  let
    ( updatedTetris, seed, cmd ) =
      Tetris.Update.update msg model.tetris model.seed
  in
    ( { model |
        tetris = updatedTetris,
        seed = seed
      }, Cmd.map TetrisMsg cmd )

updateBoggle : Boggle.Messages.Msg -> Model -> (Model, Cmd Msg)
updateBoggle msg model =
  let
    ( updatedBoggle, cmd ) = Boggle.Update.update msg model.boggle
    updatedModel = { model | boggle = updatedBoggle }
    updateCmd = Cmd.map BoggleMsg cmd
  in
    case msg of
      Boggle.Messages.NewInput input ->
        ( { updatedModel |
            tetris = Tetris.Highlight.updateHighlight updatedModel.tetris input
          }, updateCmd )

      _ ->
        ( updatedModel, updateCmd )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Tetris.Subscriptions.subscriptions model.tetris |> Sub.map TetrisMsg
    , Boggle.Subscriptions.subscriptions model.boggle |> Sub.map BoggleMsg
    ]

main : Program Flags
main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

