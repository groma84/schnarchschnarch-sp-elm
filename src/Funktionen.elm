module Funktionen exposing (spielStarten)

import Random
import SelectList exposing (SelectList)
import Types exposing (..)
import Msgs exposing (..)


spielStarten : Spielername -> List Karte -> List Int -> Spiel
spielStarten spielername karten mixNumbers =
    let
        createSpieler name handkarten =
            { name = name
            , hand = handkarten |> DreiKarten |> Drei
            , anzahlKissen = 0 |> PositiveZahl |> AnzahlKissen
            , obersteKarte = Nothing
            , restlicherStapel = []
            }

        gemischteKarten =
            mischeStapel karten mixNumbers

        spieler =
            createSpieler spielername (List.take 3 gemischteKarten)

        computer1 =
            createSpieler ("Computer1" |> NonEmptyString |> Spielername) (gemischteKarten |> List.drop 3 |> List.take 3)

        computer2 =
            createSpieler ("Computer2" |> NonEmptyString |> Spielername) (gemischteKarten |> List.drop 6 |> List.take 3)

        computer3 =
            createSpieler ("Computer3" |> NonEmptyString |> Spielername) (gemischteKarten |> List.drop 9 |> List.take 3)
    in
        { gewinner = Nothing
        , spieler = SelectList.fromLists [] spieler [ computer1, computer2, computer3 ]
        , ziehstapel = List.drop 12 gemischteKarten
        , ablegestapel = []
        }


nimmKarteAufHand : DreiKarten -> Karte -> VierKarten
nimmKarteAufHand (DreiKarten vorherigeKarten) neueKarte =
    neueKarte
        :: vorherigeKarten
        |> VierKarten


mischeStapel : List Karte -> List Int -> List Karte
mischeStapel stapel mixNumbers =
    List.map2 (\a b -> ( a, b )) stapel mixNumbers
        |> List.sortBy (\( _, b ) -> b)
        |> List.map Tuple.first



--legeKarteAb : VierKarten -> Karte -> Ablagestapel -> ( DreiKarten, Ablegestapel )
--zieheKarte : Ziehstapel -> ( Karte, Ziehstapel )
--gegnerStoeren : AusfuehrenderSpieler -> ( Kartennummer, Stoerkarte ) -> ZielSpieler -> SpielerNachZug
--einschlafen : AusfuehrenderSpieler -> ( Kartennummer, Schnarchkarte ) -> AusfuehrenderSpieler
--kissenSammeln : AusfuehrenderSpieler -> ( Kartennummer, Ruhekissenkarte ) -> AusfuehrenderSpieler
--gewittern : AusfuehrenderSpieler -> ( Kartennummer, Gewitterkarte ) -> ZielSpieler -> SpielerNachZug
--kannKarteSpielen : Kartentyp -> Spieler -> List Spieler -> Bool
--findeLinkenSpieler : AusfuehrenderSpieler -> List Spieler -> Spieler
--hatSpielerGewonnen : AnzahlKissen -> Bool
--sammleKartenAusSpielerstapeln : List (List Karte) -> List Karte


createRandomValues : Int -> (List Int -> Msg) -> Cmd Msg
createRandomValues anzahl msg =
    Random.list anzahl (Random.int 1 anzahl)
        |> Random.generate msg
