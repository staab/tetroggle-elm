module Tetris.Views exposing (view)

import Maybe
import Array
import Array exposing (Array)
import Json.Decode as Json
import Utils exposing (divide)
import Html exposing (Html, Attribute, div, text, span)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onWithOptions)
import Boggle.Messages
import Tetris.Models
    exposing
        ( Model
        , Block
        , gameSize
        , BlockType(FullBlock, SelectedBlock, EmptyBlock)
        )


view : String -> Model -> Html Boggle.Messages.Msg
view input model =
    let
        rowWidth =
            (divide model.windowHeight gameSize.height) * (toFloat gameSize.width)
    in
        div
            [ class "tetris-wrapper", style [ ( "width", px rowWidth ) ] ]
            (Array.map (blockRow input rowWidth) model.blocks |> Array.toList)


blockRow : String -> Float -> Array Block -> Html Boggle.Messages.Msg
blockRow input rowWidth blocks =
    div
        [ class "tetris-row" ]
        (Array.map (blockDiv input ((rowWidth / (toFloat gameSize.width)) - 2)) blocks |> Array.toList)


blockDiv : String -> Float -> Block -> Html Boggle.Messages.Msg
blockDiv input width block =
    span
        [ class (blockClass block)
        , style
            [ ( "width", px width )
            , ( "height", px width )
            , ( "font-size", fontSize width block )
            , ( "line-height", px width )
            ]
        , onWithOptions
            "click"
            { stopPropagation = True, preventDefault = True }
            (Json.succeed
                (if block.blockType == FullBlock then
                    Boggle.Messages.NewInput (input ++ (Maybe.withDefault "" block.letter))
                 else
                    Boggle.Messages.NoOp
                )
            )
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
