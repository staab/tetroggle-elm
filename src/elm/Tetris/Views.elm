module Tetris.Views exposing (view)

import Maybe
import Html exposing (Html, Attribute, div, text, span)
import Html.Attributes exposing (style, class)
import Matrix exposing (mapWithLocation, flatten, Location, row, col, colCount)
import Tetris.Models exposing (Model, Block)

blockPx : Int -> String
blockPx value =
  ( toString ( value * 15 ) ) ++ "px"

block : Location -> Block -> Html a
block location block =
  span [ class "block" ] [ text ( Maybe.withDefault "" block.letter ) ]

view : Model -> Html a
view model =
  div
    [ style [ ( "position", "relative" )
            , ( "width", blockPx ( colCount model.blocks ) ) ]
            ]
    ( flatten ( mapWithLocation block model.blocks ) )
