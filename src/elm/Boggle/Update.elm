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
            -- letters
            if code >= 65 && code <= 90 then
                let
                    input =
                        code
                            |> Char.fromCode
                            |> String.fromChar
                            |> (++) model.input
                in
                    ( model, inputCmd input )
                -- enter
            else if code == 13 then
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
                -- backspace
            else if code == 8 then
                if String.isEmpty model.input then
                    ( model, Cmd.none )
                else
                    ( model, inputCmd (String.dropRight 1 model.input) )
            else
                ( model, Cmd.none )

        NewInput input ->
            ( { model | input = input }, Cmd.none )

        SubmitWord success ->
            ( { model
                | input = ""
                , pastWords = List.append [ model.input ] model.pastWords
              }
            , Cmd.none
            )

        TogglePaused ->
            ( { model | paused = not model.paused }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


inputCmd : String -> Cmd Msg
inputCmd input =
    Task.perform (always NoOp) NewInput (Task.succeed input)


submitCmd : Cmd Msg
submitCmd =
    Task.perform (always NoOp) SubmitWord (Task.succeed True)
