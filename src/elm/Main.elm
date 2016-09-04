import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
--import Html.Events exposing ( onClick )

-- component import example
import Tetris.Models exposing (Tetris)
import Tetris.Messages
import Tetris.Views exposing (tetris)

type alias Model =
  { tetris : Tetris }

type Msg
  = NoOp
  | TetrisMsg Tetris.Messages.Msg

init : (Model, Cmd Msg)
init =
  ({ tetris = Tetris.Models.initialModel}, Cmd.none)

view : Model -> Html Msg
view model =
  div [ class "container", style [("margin-top", "30px"), ( "text-align", "center" )] ]
      [ div [ class "row" ]
            [ div [ class "col-xs-12" ]
                  [ div [ class "jumbotron" ]
                        [ tetris model.tetris
                        , p [] [ text "This is tetriiiis!" ]
                        ]
                  ]
            ]
      ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp -> (model, Cmd.none)

    TetrisMsg a -> (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

main : Program Never
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

