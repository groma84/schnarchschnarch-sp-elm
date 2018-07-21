module Main exposing (..)

import Html exposing (Html, div, text, h1, h2, h3, button, section, p)
import Html.Events exposing (onClick)
import Msgs exposing (..)
import Types exposing (..)
import Funktionen exposing (..)
import AlleKarten exposing (alleKarten)
import Render exposing (spielbrett)


---- MODEL ----


type alias Model =
    { status : Status
    }


init : ( Model, Cmd Msg )
init =
    ( { status = Startmenue }
    , Cmd.none
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        NeuesSpielStarten ->
            let
                generateMixNumbersCmd =
                    List.length alleKarten |> createRandomValues MischeKartenAmAnfang
            in
                ( model, generateMixNumbersCmd )

        MischeKartenAmAnfang mixNumbers ->
            let
                spielername =
                    "Spieler" |> NonEmptyString |> Spielername

                gestartetesSpiel =
                    spielStarten spielername alleKarten mixNumbers
            in
                ( { model | status = SpielImGange gestartetesSpiel }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    case model.status of
        Startmenue ->
            div []
                [ h1 [] [ text "Schnarch Schnarch" ]
                , h2 [] [ text "Ein kleines Kartenspiel für aufgeweckte Spieler" ]
                , button [ onClick NeuesSpielStarten ] [ text "Neues Spiel starten" ]
                , section []
                    [ h3 [] [ text "Die Regeln" ]
                    , p [] [ text "..." ]
                    ]
                ]

        SpielImGange spiel ->
            spielbrett spiel

        Beendet ->
            div [] [ text "Beendet" ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
