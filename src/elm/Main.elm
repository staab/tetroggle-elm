import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
--import Html.Events exposing ( onClick )

import Random.Pcg exposing (initialSeed, Seed)
import Tetris.Models
import Tetris.Messages
import Tetris.Views

type alias Flags =
  { seed : Int }

type alias Model =
  { tetris : Tetris.Models.Model
  , seed : Seed }

type Msg
  = NoOp
  | TetrisMsg Tetris.Messages.Msg

initialModel : Seed -> Model
initialModel seed =
  { tetris = Tetris.Models.initialModel
  , seed = seed
  }

init : Flags -> (Model, Cmd Msg)
init flags =
  let
    seed = initialSeed flags.seed
  in
    ( initialModel seed, Cmd.none)

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

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp -> (model, Cmd.none)

    TetrisMsg a -> (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

main : Program Flags
main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

