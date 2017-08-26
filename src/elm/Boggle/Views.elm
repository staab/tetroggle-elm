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
                [ i
                    [ onClick TogglePaused, class "fa fa-btn fa-2x fa-pause" ]
                    []
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
