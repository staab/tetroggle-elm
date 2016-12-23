module Main exposing (..)

import Html.App as Html
import String exposing (lines)
import Random.Pcg exposing (initialSeed)
import Models
    exposing
        ( Flags
        , Model
        , initialModel
        , ScoreBoardStatus
            ( Prompt
            , Submitted
            , Submitting
            )
        )
import Views exposing (view)
import Ports exposing (addScore, setName)
import Messages
    exposing
        ( Msg
            ( NoOp
            , TetrisMsg
            , BoggleMsg
            , Tick
            , SetName
            , SetScores
            , StartGame
            , SetScoreBoardStatus
            )
        )
import Subscriptions exposing (subscriptions)
import Tetris.Commands exposing (getWindowHeight)
import Tetris.Update
import Tetris.Select
import Tetris.Messages
import Boggle.Update
import Boggle.Messages


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        seed =
            initialSeed flags.seed
    in
        ( initialModel seed (lines flags.dictionary) flags.startTime flags.name
        , Cmd.map TetrisMsg getWindowHeight
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Tick time ->
            ( { model | elapsed = time - model.startTime }, Cmd.none )

        SetName name ->
            ( { model | name = name }, setName name )

        StartGame ->
            let
                newModel =
                    initialModel model.seed model.dictionary model.startTime model.name

                boggle =
                    newModel.boggle

                tetris =
                    newModel.tetris
            in
                ( { model
                    | boggle = { boggle | paused = False }
                    , tetris = { tetris | gameStarted = True }
                    , scoreBoardStatus = Prompt
                  }
                , Cmd.map TetrisMsg getWindowHeight
                )

        SetScoreBoardStatus status ->
            let
                cmd =
                    case status of
                        Submitting ->
                            addScore
                                { elapsed = truncate model.elapsed
                                , score = model.boggle.score
                                , name = model.name
                                }

                        _ ->
                            Cmd.none
            in
                ( { model | scoreBoardStatus = status }, cmd )

        SetScores scores ->
            ( { model
                | scores = scores
                , scoreBoardStatus = Submitted
              }
            , Cmd.none
            )

        TetrisMsg subMsg ->
            if model.boggle.paused then
                ( model, Cmd.none )
            else
                updateTetris subMsg model

        BoggleMsg subMsg ->
            if model.boggle.paused && subMsg /= Boggle.Messages.TogglePaused then
                ( model, Cmd.none )
            else
                updateBoggle subMsg model


updateTetris : Tetris.Messages.Msg -> Model -> ( Model, Cmd Msg )
updateTetris msg model =
    let
        ( updatedTetris, seed, cmd ) =
            Tetris.Update.update msg model.tetris model.seed
    in
        ( { model
            | tetris = updatedTetris
            , seed = seed
          }
        , Cmd.map TetrisMsg cmd
        )


updateBoggle : Boggle.Messages.Msg -> Model -> ( Model, Cmd Msg )
updateBoggle msg model =
    let
        ( updatedBoggle, cmd ) =
            Boggle.Update.update msg model.boggle model.dictionary

        newModel =
            { model | boggle = updatedBoggle }

        updateCmd =
            Cmd.map BoggleMsg cmd
    in
        case msg of
            Boggle.Messages.NewInput input ->
                ( { newModel
                    | tetris = Tetris.Select.updateSelect newModel.tetris input
                  }
                , updateCmd
                )

            Boggle.Messages.SubmitWord success ->
                ( { newModel
                    | tetris = Tetris.Select.removeSelected newModel.tetris
                  }
                , updateCmd
                )

            _ ->
                ( newModel, updateCmd )


main : Program Flags
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
