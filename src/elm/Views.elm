module Views exposing (view)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Tetris.Views
import Boggle.Views
import Models exposing (Model)
import Messages exposing (Msg(..))

view : Model -> Html Msg
view model =
  div [ class "wrapper" ]
      [ div [ class "input-sidebar" ]
            [ Html.App.map BoggleMsg ( Boggle.Views.view model.boggle ) ]
      , div [ class "container" ]
            [ Html.App.map TetrisMsg ( Tetris.Views.view model.tetris ) ]
      ]
