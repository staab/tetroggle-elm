module Views exposing (view)

import Html exposing (Html, div, text, button)
import Html.App
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Tetris.Views
import Boggle.Views
import Models exposing (Model)
import Messages exposing (Msg(BoggleMsg, TetrisMsg, StartGame))


view : Model -> Html Msg
view model =
    div [ class "wrapper" ]
        [ overlay model
        , div [ class "input-sidebar" ]
            [ Html.App.map BoggleMsg (Boggle.Views.view model.boggle) ]
        , div [ class "container" ]
            [ Html.App.map TetrisMsg (Tetris.Views.view model.tetris) ]
        ]


overlay : Model -> Html Msg
overlay model =
    if not model.tetris.gameStarted then
        startOverlay model
    else if model.tetris.gameOver then
        endOverlay model
    else if model.boggle.paused then
        pausedOverlay model
    else
        div [] []


startOverlay : Model -> Html Msg
startOverlay model =
    let
        plusStyle =
            if model.elapsed > 0 then
                [ ( "opacity", "0" ) ]
            else
                []

        getPosStyle prop =
            if model.elapsed > 0 then
                [ ( prop, "52%" ), ( "opacity", "0" ) ]
            else
                []

        tetroggleStyle =
            if model.elapsed > 2500 then
                [ ( "opacity", "1" ) ]
            else
                []

        startStyle =
            if model.elapsed > 3500 then
                [ ( "opacity", "1" ) ]
            else
                []
    in
        div [ class "overlay" ]
            [ div [ class "overlay-animation" ]
                [ div
                    [ class "overlay-plus", style plusStyle ]
                    [ text "+" ]
                , div
                    [ class "overlay-boggle", style (getPosStyle "right") ]
                    [ text "Boggle" ]
                , div
                    [ class "overlay-tetroggle", style tetroggleStyle ]
                    [ text "Tetroggle" ]
                , div
                    [ class "overlay-tetris", style (getPosStyle "left") ]
                    [ text "Tetris" ]
                , div
                    [ class "overlay-start", style startStyle ]
                    [ button [ onClick StartGame ] [ text "Start" ] ]
                ]
            ]


endOverlay : Model -> Html Msg
endOverlay model =
    div [] []


pausedOverlay : Model -> Html Msg
pausedOverlay model =
    div [] []
