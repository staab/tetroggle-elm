import Html.App as Html

import Time exposing (every, second)
import Random.Pcg exposing (initialSeed)
import Models exposing (Flags, Model, initialModel)
import Messages exposing (Msg(..))
import Views exposing (view)
import Tetris.Update
import Debug exposing (log)

init : Flags -> (Model, Cmd Msg)
init flags =
  let
    seed = initialSeed flags.seed
  in
    ( initialModel seed, Cmd.none )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp -> ( model, Cmd.none )

    Tick time ->
      let
        ( updatedTetris, cmd ) = Tetris.Update.tick model.tetris ( log "time" time)
      in
        ( { model | tetris = updatedTetris }, Cmd.map TetrisMsg cmd )

    TetrisMsg subMsg ->
      let
        ( updatedTetris, cmd ) = Tetris.Update.update subMsg model.tetris
      in
        ( { model | tetris = updatedTetris }, Cmd.map TetrisMsg cmd )

subscriptions : Model -> Sub Msg
subscriptions model =
  every second Tick

main : Program Flags
main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

