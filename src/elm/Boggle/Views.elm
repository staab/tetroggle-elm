module Boggle.Views exposing (view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Boggle.Models exposing (Model)

view : Model -> Html a
view model =
  div
    [ class "boggle-wrapper" ]
    [ text model.input ]