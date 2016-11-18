module Boggle.Views exposing (view)

import Html exposing (Html, div, text, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Boggle.Messages exposing (Msg(TogglePaused))
import Boggle.Models exposing (Model)

view : Model -> Html Msg
view model =
  div
    [ class "boggle-wrapper" ]
    [ div [] [ text model.input ]
    , div [] [ button [ onClick TogglePaused ] [ text "Pause" ] ] ]