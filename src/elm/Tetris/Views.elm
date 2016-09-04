module Tetris.Views exposing (tetris)

import Html exposing (Html, Attribute, div, text, span)
import Html.Attributes exposing (style, class)
import Matrix exposing (mapWithLocation, flatten, Location, row, col, colCount)
import String exposing (fromChar)
import Tetris.Models exposing (Tetris)

blockPx : Int -> String
blockPx value =
  ( toString ( value * 15 ) ) ++ "px"

tetris : Tetris -> Html a
tetris model =
  div
    [ style [ ( "position", "relative" )
            , ( "width", blockPx ( colCount model.blocks ) ) ]
            ]
    ( flatten
      ( mapWithLocation
        (\location element ->
          span [ class "block" ]
              [ ( text (fromChar element.letter) ) ]
        )
        model.blocks
      )
    )
