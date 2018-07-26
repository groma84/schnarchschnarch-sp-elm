module Render exposing (spielbrett)

import Html exposing (div, text, span)
import Html.Attributes exposing (style, id)
import Html.Events exposing (onClick)
import Types exposing (..)
import Msgs exposing (..)


spielbrett : Spiel -> Html.Html Msg
spielbrett spiel =
    div
        [ style
            [ ( "width", be2px 64 )
            , ( "height", be2px 36 )
            , ( "background-color", "floralwhite" )
            , ( "display", "flex" )
            , ( "flex-direction", "column" )
            , ( "margin", "auto" )
            ]
        ]
        [ kartenInteraktionContainer AufAblagestapel Nothing
        , andererSpieler spiel.spieler4
        , andererSpieler spiel.spieler3
        , andererSpieler spiel.spieler2
        , eigenerSpieler spiel.spieler1
        ]


andererSpieler : Spieler -> Html.Html Msg
andererSpieler spieler =
    div [ style [ ( "display", "flex" ) ] ]
        [ spieler.name |> spielernameZuString |> text
        , kissenContainer spieler.anzahlKissen
        , letzteGespielteKarteOderPlatzhalter (FremderKartenstapel spieler) spieler.obersteKarte
        ]


eigenerSpieler : Spieler -> Html.Html Msg
eigenerSpieler spieler =
    div [ style [ ( "display", "flex" ), ( "font-weight", "bold" ) ] ]
        [ spieler.name |> spielernameZuString |> text
        , kissenContainer spieler.anzahlKissen
        , letzteGespielteKarteOderPlatzhalter EigenerKartenstapel spieler.obersteKarte
        , hand spieler.hand
        ]


hand : Hand -> Html.Html Msg
hand hand =
    let
        kartenContainer karte =
            kartenInteraktionContainer Handkarte (Just karte)
    in
        case hand of
            DreiAufDerHand (DreiKarten karten) ->
                div [ style [ ( "display", "flex" ) ] ]
                    (List.map kartenContainer karten)

            VierAufDerHand (VierKarten karten) ->
                div [ style [ ( "display", "flex" ) ] ]
                    (List.map kartenContainer karten)


letzteGespielteKarteOderPlatzhalter : KartenInteraktion -> Maybe Karte -> Html.Html Msg
letzteGespielteKarteOderPlatzhalter kartenInteraktion obersteKarte =
    kartenInteraktionContainer kartenInteraktion obersteKarte


spielernameZuString : Spielername -> String
spielernameZuString (Spielername (NonEmptyString name)) =
    name


kartenBreiteInBasiseinheiten : Int
kartenBreiteInBasiseinheiten =
    4


kartenHoeheInBasiseinheiten : Int
kartenHoeheInBasiseinheiten =
    6


kissenBreiteInBasiseinheiten : Int
kissenBreiteInBasiseinheiten =
    3


kissenHoeheInBasiseinheiten : Int
kissenHoeheInBasiseinheiten =
    2


kissen : Html.Html msg
kissen =
    div
        [ style
            [ ( "width", be2px kissenBreiteInBasiseinheiten )
            , ( "height", be2px kissenHoeheInBasiseinheiten )
            , ( "background-color", "azure" )
            , ( "border", "1px dotted white" )
            ]
        ]
        [ text "Kissen" ]


kissenContainer : AnzahlKissen -> Html.Html msg
kissenContainer (Types.AnzahlKissen (Types.PositiveZahl anzahl)) =
    div
        [ style
            [ ( "display", "flex" )
            , ( "flex-wrap", "wrap" )
            , ( "width", be2px (4 * kissenBreiteInBasiseinheiten) )
            , ( "height", be2px (3 * kissenHoeheInBasiseinheiten) )
            ]
        ]
        (List.repeat anzahl kissen)


kartenElement : Karte -> Html.Html msg
kartenElement karte =
    let
        kartentext =
            case karte.typ of
                Schnarchkarte ->
                    "Schnarchkarte"

                Ruhekissenkarte kissenanzahl ->
                    let
                        kissenAnzahlText =
                            case kissenanzahl of
                                EinKissen ->
                                    "1"

                                ZweiKissen ->
                                    "2"

                                DreiKissen ->
                                    "3"
                    in
                        "Ruhekissenkarte " ++ kissenAnzahlText

                Stoerkarte ->
                    "Stoerkarte"

                Gewitterkarte ->
                    "Gewitterkarte"

        rotatedText =
            div [ style [ ( "transform", "rotate(90deg) translateX(50%)" ) ] ] [ text kartentext ]
    in
        div
            [ style
                [ ( "width", be2px kartenBreiteInBasiseinheiten )
                , ( "height", be2px kartenHoeheInBasiseinheiten )
                , ( "border", "2px solid black" )
                , ( "margin", be2px 1 )
                ]
            ]
            [ rotatedText ]


kartenPlatzhalter : Html.Html msg
kartenPlatzhalter =
    let
        rotatedText =
            div [ style [ ( "transform", "rotate(90deg) translateX(50%)" ) ] ] [ text "Kartenstapel" ]
    in
        div
            [ style
                [ ( "width", be2px kartenBreiteInBasiseinheiten )
                , ( "height", be2px kartenHoeheInBasiseinheiten )
                , ( "border", "1px solid gray" )
                ]
            ]
            [ rotatedText ]


kartenInteraktionContainer : KartenInteraktion -> Maybe Karte -> Html.Html Msg
kartenInteraktionContainer kartenInteraktion karte =
    let
        kartenEle =
            case karte of
                Just k ->
                    kartenElement k

                Nothing ->
                    kartenPlatzhalter

        kartenMsg =
            case kartenInteraktion of
                Handkarte ->
                    HandkarteGeklickt karte

                AufAblagestapel ->
                    AblagestapelGeklickt

                EigenerKartenstapel ->
                    EigenerKartenstapelGeklickt

                FremderKartenstapel zielSpieler ->
                    FremderKartenstapelGeklickt zielSpieler
    in
        div [ onClick kartenMsg ] [ kartenEle ]


be2px : Int -> String
be2px basiseinheiten =
    let
        basiseinheitInPx =
            20
    in
        (basiseinheiten * basiseinheitInPx |> toString) ++ "px"
