module Views exposing (view)

import Html exposing (Html, div, i, ul, li, h1, h2, text, table, tr, td, button, input)
import Html.App
import Html.Attributes exposing (disabled, class, style, type', value, placeholder)
import Html.Events exposing (onClick, onInput)
import Utils exposing (divide)
import Tetris.Views
import Tetris.Messages
import Boggle.Views
import Boggle.Messages
import Models
    exposing
        ( Model
        , Score
        , ScoreBoardStatus
            ( Unsubmitted
            , Submitting
            , Submitted
            , Prompt
            )
        )
import Messages
    exposing
        ( Msg
            ( BoggleMsg
            , TetrisMsg
            , StartGame
            , SetScoreBoardStatus
            , SetName
            )
        )


helpText : List String
helpText =
    [ "It's kinda like tetris - use the arrow keys to position, rotate, and drop shapes into place."
    , "It's kinda like boggle - type words to select blocks on the screen."
    , "Hit escape to clear your selection; hit enter to submit it."
    , "The longer the words, the more points you get!"
    ]


view : Model -> Html Msg
view model =
    let
        isWide =
            divide model.windowSize.width model.windowSize.height > 1.1

        innerWrapperClass =
            if isWide then
                "inner-wrapper-wide"
            else
                "inner-wrapper-narrow"

        touchControls =
            if isWide then
                div [] []
            else
                div
                    [ class "touch-controls btn-group" ]
                    [ div
                        [ class "btn-group" ]
                        [ Html.App.map BoggleMsg
                            (i
                                [ class "fa fa-2x fa-btn fa-times"
                                , onClick (Boggle.Messages.KeyPress 27)
                                ]
                                []
                            )
                        ]
                    , div
                        [ class "btn-group" ]
                        [ Html.App.map BoggleMsg
                            (i
                                [ class "fa fa-2x fa-btn fa-check"
                                , onClick (Boggle.Messages.KeyPress 13)
                                ]
                                []
                            )
                        ]
                    , div
                        [ class "btn-group" ]
                        [ Html.App.map TetrisMsg
                            (i
                                [ class "fa fa-2x fa-btn fa-rotate-left"
                                , onClick (Tetris.Messages.KeyPress 38)
                                ]
                                []
                            )
                        ]
                    , div
                        [ class "btn-group" ]
                        [ Html.App.map TetrisMsg
                            (i
                                [ class "fa fa-2x fa-btn fa-arrow-circle-left"
                                , onClick (Tetris.Messages.KeyPress 37)
                                ]
                                []
                            )
                        ]
                    , div
                        [ class "btn-group" ]
                        [ Html.App.map TetrisMsg
                            (i
                                [ class "fa fa-2x fa-btn fa-arrow-circle-right"
                                , onClick (Tetris.Messages.KeyPress 39)
                                ]
                                []
                            )
                        ]
                    ]
    in
        div [ class "wrapper" ]
            [ overlay model
            , div [ class ("inner-wrapper " ++ innerWrapperClass) ]
                [ Html.App.map BoggleMsg (Boggle.Views.leftSidebar model.boggle)
                , Html.App.map BoggleMsg (Tetris.Views.view model.boggle.input model.tetris)
                , Html.App.map BoggleMsg (Boggle.Views.rightSidebar model.boggle)
                ]
            , touchControls
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
                    [ button
                        [ onClick StartGame ]
                        [ i [ class "fa fa-btn fa-bolt" ] []
                        , text " Get Started!"
                        ]
                    ]
                ]
            ]



-- End overlay


getNameInput : Model -> Html Msg
getNameInput model =
    let
        getElement isDisabled =
            div
                [ class "btn-group" ]
                [ input
                    [ disabled isDisabled
                    , type' "text"
                    , placeholder "Your name"
                    , value model.name
                    , onInput SetName
                    ]
                    []
                , button
                    [ onClick (SetScoreBoardStatus Submitting) ]
                    [ i [ class "fa fa-btn fa-bomb" ] []
                    , text " Save"
                    ]
                ]
    in
        case model.scoreBoardStatus of
            Unsubmitted ->
                getElement False

            Submitting ->
                getElement True

            _ ->
                div [] []


getSubmitButton : Model -> Html Msg
getSubmitButton model =
    case model.scoreBoardStatus of
        Prompt ->
            button
                [ onClick (SetScoreBoardStatus Unsubmitted) ]
                [ i [ class "fa fa-btn fa-bomb" ] []
                , text " Submit Score"
                ]

        _ ->
            div [] []


getScoreDisplay : Score -> Html Msg
getScoreDisplay score =
    tr
        []
        [ td [ style [ ( "text-align", "left" ) ] ] [ text score.name ]
        , td [ style [ ( "text-align", "right" ) ] ] [ text (toString score.score) ]
        ]


getEndOverlayDisplay : Model -> List (Html Msg)
getEndOverlayDisplay model =
    let
        restartButton =
            button
                [ onClick StartGame ]
                [ i [ class "fa fa-btn fa-rotate-left" ] []
                , text " Play Again"
                ]
    in
        case model.scoreBoardStatus of
            Submitted ->
                [ h1 [] [ text "Top 10 High Scores" ]
                , div
                    [ style [ ( "max-height", "300px" ), ( "overflow", "auto" ) ] ]
                    [ table
                        [ style [ ( "margin", "0 auto" ), ( "min-width", "200px" ) ] ]
                        (List.map getScoreDisplay model.scores)
                    ]
                , div [ class "v-divider" ] []
                , restartButton
                ]

            _ ->
                [ h1 [] [ text "Game Over" ]
                , h2 [] [ text ("Score: " ++ (toString model.boggle.score)) ]
                , getNameInput model
                , div [ class "v-divider" ] []
                , div
                    [ class "btn-group" ]
                    [ getSubmitButton model
                    , restartButton
                    ]
                ]


endOverlay : Model -> Html Msg
endOverlay model =
    div [ class "overlay" ]
        [ div
            [ style [ ( "text-align", "center" ) ] ]
            (getEndOverlayDisplay model)
        ]



-- Paused overlay


pausedOverlay : Model -> Html Msg
pausedOverlay model =
    div [ class "overlay" ]
        [ div [ style [ ( "text-align", "center" ) ] ]
            [ h1 [] [ text "Paused" ]
            , div
                [ style [ ( "text-align", "left" ), ( "max-width", "300px" ) ] ]
                [ h2 [] [ text "How to play" ]
                , ul [] (List.map (\help -> li [] [ text help ]) helpText)
                ]
            , Html.App.map BoggleMsg
                (button
                    [ onClick Boggle.Messages.TogglePaused ]
                    [ i [ class "fa fa-btn fa-paper-plane" ] []
                    , text " Resume"
                    ]
                )
            ]
        ]
