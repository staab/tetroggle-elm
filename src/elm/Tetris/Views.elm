module Tetris.Views exposing (view)

import Maybe
import Array
import Array exposing (Array)
import Utils exposing (divide)
import Html exposing (Html, Attribute, div, text, span)
import Html.Attributes exposing (class, style)
import Tetris.Models exposing (
  Model,
  Block,
  gameSize,
  BlockType(FullBlock, SelectedBlock, EmptyBlock))

view : Model -> Html a
view model =
  div
    [ class "tetris-wrapper" ]
    ( Array.map ( blockRow model.windowHeight ) model.blocks |> Array.toList )

blockRow : Int -> Array Block -> Html a
blockRow height blocks =
  div
    [ class "tetris-row" ]
    ( Array.map ( blockDiv height ) blocks |> Array.toList )

blockDiv : Int -> Block -> Html a
blockDiv height block =
  let
    size = ( divide height gameSize.height ) - 2
  in
    span [ class ( blockClass block )
         , style [ ( "width", px size )
                 , ( "height", px size )
                 , ( "font-size", px ( size * 0.85 ) )
                 ]
         ]
         [ text ( Maybe.withDefault "" block.letter ) ]

blockClass : Block -> String
blockClass block =
  case block.blockType of
    FullBlock ->
      "tetris-block" ++ " full-block"

    SelectedBlock ->
      "tetris-block" ++ " selected-block"

    EmptyBlock ->
      "tetris-block"

px : Float -> String
px value =
  ( toString value ) ++ "px"