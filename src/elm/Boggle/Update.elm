module Boggle.Update exposing (update)

import Char
import String
import Task
import List exposing (member)
import Boggle.Models exposing (Model)
import Boggle.Messages
    exposing
        ( Msg
            ( KeyPress
            , NewInput
            , SubmitWord
            , TogglePaused
            , NoOp
            )
        )


update : Msg -> Model -> List String -> ( Model, Cmd Msg )
update msg model dictionary =
    case msg of
        KeyPress code ->
            if code >= 65 && code <= 90 then
                -- letters
                let
                    input =
                        code
                            |> Char.fromCode
                            |> String.fromChar
                            |> (++) model.input
                in
                    ( model, inputCmd input )
            else if code == 13 then
                -- enter
                let
                    success =
                        String.length model.input
                            > 2
                            && member (String.toLower model.input) dictionary

                    cmd =
                        if success then
                            submitCmd
                        else
                            Cmd.none
                in
                    ( model, cmd )
            else if code == 8 then
                -- backspace
                if String.isEmpty model.input then
                    ( model, Cmd.none )
                else
                    ( model, inputCmd (String.dropRight 1 model.input) )
            else if code == 27 then
                -- escape
                ( model, inputCmd "" )
            else
                ( model, Cmd.none )

        NewInput input ->
            ( { model | input = input }, Cmd.none )

        SubmitWord success ->
            ( { model
                | input = ""
                , pastWords = List.append [ model.input ] model.pastWords |> List.take 50
                , score = model.score + (getScore model.input)
              }
            , Cmd.none
            )

        TogglePaused ->
            ( { model | paused = not model.paused }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


getScore : String -> Int
getScore input =
    let
        len =
            String.length input
    in
        case len of
            3 ->
                1

            4 ->
                1

            5 ->
                2

            6 ->
                3

            7 ->
                5

            _ ->
                11


inputCmd : String -> Cmd Msg
inputCmd input =
    Task.perform (always NoOp) NewInput (Task.succeed input)


submitCmd : Cmd Msg
submitCmd =
    Task.perform (always NoOp) SubmitWord (Task.succeed True)
