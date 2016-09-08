module Tetris.Update exposing (update, tick)

import Time
import Random.Pcg exposing (Seed)
import Matrix exposing (loc)
import Tetris.Messages exposing (Msg(..))
import Tetris.Models exposing (Model, Shape, newShape)

update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
  case message of
    AddShape ->
      ( { model | shape = newShape [] }, Cmd.none )

tick : Model -> Time.Time -> Seed -> ( Model, Cmd Msg )
tick model time seed =
  case model.shape of
    Nothing ->
      ( addShape seed model, Cmd.none )

    Just shape ->
      ( model, Cmd.none )

addShape : Seed -> Model -> Model
addShape seed model =
  { model | shape = newShape [ loc 0 0, loc 0 1 ] }
