module Views exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Tetris.Views
import Models exposing (Model)
import Messages exposing (Msg(..))

view : Model -> Html Msg
view model =
  div [ class "wrapper" ]
      [ div [ class "container" ]
            [ Tetris.Views.view model.tetris ]
      ]
