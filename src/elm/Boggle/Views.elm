module Boggle.Views exposing (leftSidebar, rightSidebar)

import Html exposing (Html, div, text, i, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Boggle.Messages exposing (Msg(TogglePaused))
import Boggle.Models exposing (Model)


leftSidebar : Model -> Html Msg
leftSidebar model =
    div
        [ class "left-sidebar" ]
        [ div
            []
            [ i
                [ onClick TogglePaused, class "fa fa-btn fa-2x fa-pause" ]
                []
            ]
        ]


rightSidebar : Model -> Html Msg
rightSidebar model =
    div
        [ class "right-sidebar" ]
        [ div [] [ text model.input ]
        ]
