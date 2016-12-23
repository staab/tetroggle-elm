module Tetris.Views exposing (view)

import Maybe
import Array
import Array exposing (Array)
import Utils exposing (divide)
import Html exposing (Html, Attribute, div, text, span)
import Html.Attributes exposing (class, style)
import Tetris.Models
    exposing
        ( Model
        , Block
        , gameSize
        , BlockType(FullBlock, SelectedBlock, EmptyBlock)
        )


view : Model -> Html a
view model =
    let
        rowWidth =
            (divide model.windowHeight gameSize.height) * (toFloat gameSize.width)
    in
        div
            [ class "tetris-wrapper", style [ ( "width", px rowWidth ) ] ]
            (Array.map (blockRow rowWidth) model.blocks |> Array.toList)


blockRow : Float -> Array Block -> Html a
blockRow rowWidth blocks =
    div
        [ class "tetris-row" ]
        (Array.map (blockDiv ((rowWidth / (toFloat gameSize.width)) - 2)) blocks |> Array.toList)


blockDiv : Float -> Block -> Html a
blockDiv width block =
    span
        [ class (blockClass block)
        , style
            [ ( "width", px width )
            , ( "height", px width )
            , ( "font-size", fontSize width block )
            , ( "line-height", px width )
            ]
        ]
        [ text (Maybe.withDefault "" block.letter) ]


blockClass : Block -> String
blockClass block =
    case block.blockType of
        FullBlock ->
            "tetris-block" ++ " full-block"

        SelectedBlock ->
            "tetris-block" ++ " selected-block"

        EmptyBlock ->
            "tetris-block"


fontSize : Float -> Block -> String
fontSize size block =
    if block.letter == Just "QU" then
        px (size * 0.65)
    else
        px (size * 0.85)


px : Float -> String
px value =
    (toString value) ++ "px"
