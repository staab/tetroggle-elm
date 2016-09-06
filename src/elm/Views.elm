module Views exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Tetris.Views
import Models exposing (Model)
import Messages exposing (Msg(..))

view : Model -> Html Msg
view model =
  div [ class "container", style [("margin-top", "30px"), ( "text-align", "center" )] ]
      [ div [ class "row" ]
            [ div [ class "col-xs-12" ]
                  [ div [ class "jumbotron" ]
                        [ Tetris.Views.view model.tetris
                        , p [] [ text "This is tetriiiis!" ]
                        ]
                  ]
            ]
      ]
