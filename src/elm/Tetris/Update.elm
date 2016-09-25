module Tetris.Update exposing (update)

import Random.Pcg exposing (Seed)
import Tetris.Messages exposing (Msg(Tick, KeyPress, WindowHeightFail, WindowHeightDone))
import Tetris.Models exposing (Model)
import Tetris.ShapeUtils exposing (addShape, moveShape, rotateShape, stompShape)

update : Msg -> Model -> Seed -> ( Model, Seed, Cmd Msg )
update message model seed =
  case message of
    WindowHeightFail ->
      ( model, seed, Cmd.none )

    WindowHeightDone height ->
      ( { model | windowHeight = height }, seed, Cmd.none )

    Tick time ->
      case model.shape of
        Nothing ->
          let
            ( newModel, newSeed ) = addShape model seed
          in
            ( newModel, newSeed, Cmd.none )

        Just shape ->
          ( moveShape model 1 0 ( always Nothing ), seed, Cmd.none )

    KeyPress code ->
      case model.shape of
        Nothing ->
          ( model, seed, Cmd.none )

        Just shape ->
          case code of
            37 -> ( moveShape model 0 -1 identity, seed, Cmd.none )
            38 -> ( rotateShape model, seed, Cmd.none )
            39 -> ( moveShape model 0 1 identity, seed, Cmd.none )
            40 -> ( stompShape model, seed, Cmd.none )
            _ -> ( model, seed, Cmd.none )