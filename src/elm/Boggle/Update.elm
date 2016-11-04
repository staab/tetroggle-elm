module Boggle.Update exposing (update)

import Char
import String
import Task
import List exposing (member)
import Boggle.Models exposing (Model)
import Boggle.Messages exposing (Msg(KeyPress, NewInput, NoOp))

update : Msg -> Model -> List String -> (Model, Cmd Msg)
update msg model dictionary =
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
        let
          success =
            String.length model.input > 2
            && member (String.toLower model.input) dictionary
        in
          if success then
            ( model, Cmd.none )
          else
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