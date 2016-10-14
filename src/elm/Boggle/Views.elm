module Boggle.Views exposing (view)

import Html exposing (Html, div, input)
import Html.Attributes exposing (class)
import Html.Events exposing (onInput)
import Boggle.Models exposing (Model)
import Boggle.Messages exposing (Msg(NewInput))
import Boggle.Messages

view : Model -> Html Boggle.Messages.Msg
view model =
  div
    [ class "boggle-wrapper" ]
    [ input [ onInput NewInput ] [] ]