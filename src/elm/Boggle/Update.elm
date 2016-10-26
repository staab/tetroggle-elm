module Boggle.Update exposing (update)

import Char
import String
import Task
import Boggle.Models exposing (Model)
import Boggle.Messages exposing (Msg(KeyPress, NewInput, NoOp))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    KeyPress code ->
      -- letters
      if code >= 65 && code <= 90 then
        let
          input = code
            |> Char.fromCode
            |> String.fromChar
            |> (++) model.input
        in
          ( model, inputCmd input )

      -- enter
      else if code == 13 then
        ( model, Cmd.none )

      -- backspace
      else if code == 8 then
        if String.isEmpty model.input then
          ( model, Cmd.none )
        else
          ( model, inputCmd ( String.dropRight 1 model.input ) )

      else
        ( model, Cmd.none )

    NewInput input ->
      ( { model | input = input }, Cmd.none )

    NoOp ->
      (model, Cmd.none)

inputCmd : String -> Cmd Msg
inputCmd input =
  Task.perform ( always NoOp ) NewInput ( Task.succeed input )