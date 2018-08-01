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
    , cursor : Cursor
    }


init : ( Model, Cmd Msg )
init =
    ( { status = Startmenue, cursor = Leer }
    , Cmd.none
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        todo =
            ( model, Cmd.none )
    in
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
                    { model | status = SpielImGange gestartetesSpiel }
                        |> update NaechstenSpielzugVorbereiten

            NaechstenSpielzugVorbereiten ->
                let
                    newModel =
                        case model.status of
                            Startmenue ->
                                model

                            SpielImGange spiel ->
                                let
                                    spielBereitFuerInput =
                                        naechstenSpielzugVorbereiten spiel (\sp -> sp.spieler1) (\sp s -> { sp | spieler1 = s })
                                in
                                    { model | status = SpielImGange spielBereitFuerInput }

                            Beendet ->
                                model
                in
                    ( newModel, Cmd.none )

            HandkarteGeklickt karte ->
                case karte of
                    Nothing ->
                        ( model, Cmd.none )

                    Just k ->
                        ( { model | cursor = KarteAktiv k }, Cmd.none )

            AblagestapelGeklickt ->
                let
                    geaendertesModel =
                        case model.cursor of
                            Leer ->
                                model

                            KarteAktiv karte ->
                                case model.status of
                                    Startmenue ->
                                        model

                                    Beendet ->
                                        model

                                    SpielImGange spiel ->
                                        let
                                            spieler1 =
                                                spiel.spieler1

                                            -- TODO: Das hier ist die FUnktion legeKarteAb mit ien paar cleveren
                                            -- spieler selektoren und update funktionen - dann koennen wir die auch fuer den computer verwenden
                                            ( neueHand, neuerAblagestapel ) =
                                                case spieler1.hand of
                                                    VierAufDerHand vierKarten ->
                                                        let
                                                            ( dreiKarten, ablagestapel ) =
                                                                Funktionen.legeKarteAb vierKarten karte spiel.ablagestapel
                                                        in
                                                            ( DreiAufDerHand dreiKarten, ablagestapel )

                                                    DreiAufDerHand _ ->
                                                        ( spieler1.hand, spiel.ablagestapel )

                                            updatedSpieler1 =
                                                { spieler1 | hand = neueHand }

                                            updatedSpiel =
                                                { spiel | ablagestapel = neuerAblagestapel, spieler1 = updatedSpieler1 }

                                            computerZuegeGespielt =
                                                macheComputerZug updatedSpiel

                                            spielerHatNeueKarteGezogen =
                                                naechstenSpielzugVorbereiten computerZuegeGespielt (\sp -> sp.spieler1) (\sp s -> { sp | spieler1 = s })
                                        in
                                            { model | status = SpielImGange spielerHatNeueKarteGezogen, cursor = Leer }
                in
                    ( geaendertesModel, Cmd.none )

            EigenerKartenstapelGeklickt ->
                todo

            FremderKartenstapelGeklickt zielSpieler ->
                todo



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
