module Boggle.Views exposing (leftSidebar, rightSidebar)

import String exposing (padLeft)
import Html exposing (Html, div, span, text, strong, i, a, button)
import Html.Attributes exposing (class, href, target, style)
import Html.Events exposing (onClick)
import Boggle.Messages exposing (Msg(TogglePaused))
import Boggle.Models exposing (Model)


leftSidebar : Model -> Html Msg
leftSidebar model =
    div
        [ class "left-sidebar" ]
        [ div
            [ style [ ( "display", "inline-block" ) ] ]
            [ div
                [ class "current-score" ]
                [ text (model.score |> toString |> padLeft 3 '0') ]
            , div
                [ style [ ( "display", "inline-block" ) ] ]
                [ div
                    [ style
                        [ ( "display", "flex" )
                        , ( "flex-direction", "column" )
                        , ( "align-items", "center" )
                        , ( "justify-content", "space-around" )
                        , ( "height", "100px" )
                        ]
                    ]
                    [ i
                        [ onClick TogglePaused, class "fa fa-btn fa-2x fa-pause" ]
                        []
                    , a
                        [ href "https://cash.me/$jstaab"
                        , target "_blank"
                        , onClick TogglePaused
                        ]
                        [ i [ class "fa fa-btn fa-2x fa-heart" ] [] ]
                    , i
                        [ onClick TogglePaused, class "fa fa-btn fa-2x fa-question-circle" ]
                        []
                    ]
                ]
            ]
        ]


rightSidebar : Model -> Html Msg
rightSidebar model =
    div
        [ class "right-sidebar" ]
        [ div [ class "current-selection" ] [ text model.input ]
        , div [ class "past-words" ]
            (List.map
                (\word -> div [] [ text word ])
                model.pastWords
            )
        ]
