module Tetris.Views exposing (view)

import Maybe
import Array
import Array exposing (Array)
import Html exposing (Html, Attribute, div, text, span)
import Html.Attributes exposing (style, class)
import Tetris.Models exposing (Model, Block, gameSize)

view : Model -> Html a
view model =
  div
    [ style [ ( "position", "relative" )
            , ( "width", blockPx ( gameSize.width ) ) ]
            ]
    ( Array.map blockRow model.blocks |> Array.toList )

blockRow : Array Block -> Html a
blockRow blocks =
  span
    [ style [ ( "width", blockPx 1 ) ] ]
    ( Array.map blockDiv blocks |> Array.toList )

blockDiv : Block -> Html a
blockDiv block =
  span [ class "block" ] [ text ( Maybe.withDefault "" block.letter ) ]

blockPx : Int -> String
blockPx value =
  ( toString ( value * 15 ) ) ++ "px"
