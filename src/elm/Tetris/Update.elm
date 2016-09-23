module Tetris.Update exposing (update)

import Random.Pcg exposing (Seed)
import Tetris.Messages exposing (Msg(Tick, KeyPress))
import Tetris.Models exposing (Model)
import Tetris.ShapeUtils

update : Msg -> Model -> Seed -> ( Model, Seed, Cmd Msg )
update message model seed =
  case message of
    Tick time ->
      case model.shape of
        Nothing ->
          let
            ( newModel, newSeed ) = Tetris.ShapeUtils.addShape model seed
          in
            ( newModel, newSeed, Cmd.none )

        Just shape ->
          ( Tetris.ShapeUtils.moveShape model 1 0, seed, Cmd.none )

    KeyPress code ->
      case model.shape of
        Nothing ->
          ( model, seed, Cmd.none )

        Just shape ->
          case code of
            37 -> ( Tetris.ShapeUtils.moveShape model 0 -1, seed, Cmd.none )
            38 -> ( Tetris.ShapeUtils.rotateShape model, seed, Cmd.none )
            39 -> ( Tetris.ShapeUtils.moveShape model 0 1, seed, Cmd.none )
            40 -> ( Tetris.ShapeUtils.stompShape model, seed, Cmd.none )
            _ -> ( model, seed, Cmd.none )