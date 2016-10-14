import Html.App as Html

import Random.Pcg exposing (initialSeed)
import Models exposing (Flags, Model, initialModel)
import Messages exposing (Msg(..))
import Views exposing (view)
import Tetris.Commands exposing (getWindowHeight)
import Tetris.Update
import Tetris.Subscriptions

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
      let
        ( updatedTetris, seed, cmd ) = Tetris.Update.update subMsg model.tetris model.seed
      in
        ( { model |
            tetris = updatedTetris,
            seed = seed
          }, Cmd.map TetrisMsg cmd )

    BoggleMsg subMsg ->
      ( model, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [ Tetris.Subscriptions.subscriptions model.tetris |> Sub.map TetrisMsg ]

main : Program Flags
main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

