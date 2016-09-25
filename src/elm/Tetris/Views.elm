module Tetris.Views exposing (view)

import Maybe
import Array
import Array exposing (Array)
import Html exposing (Html, Attribute, div, text, span)
import Html.Attributes exposing (class)
import Tetris.Models exposing (Model, Block, gameSize)

view : Model -> Html a
view model =
  div
    [ class "tetris-wrapper" ]
    ( Array.map blockRow model.blocks |> Array.toList )

blockRow : Array Block -> Html a
blockRow blocks =
  div
    [ class "tetris-row" ]
    ( Array.map blockDiv blocks |> Array.toList )

blockDiv : Block -> Html a
blockDiv block =
  span [ class "tetris-block" ] [ text ( Maybe.withDefault "" block.letter ) ]
