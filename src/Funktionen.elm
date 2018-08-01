module Funktionen exposing (spielStarten, createRandomValues, naechstenSpielzugVorbereiten, legeKarteAb, macheComputerZug)

import Random
import Types exposing (..)
import Msgs exposing (..)


spielStarten : Spielername -> List Karte -> List Int -> Spiel
spielStarten spielername karten mixNumbers =
    let
        createSpieler name handkarten =
            { name = name
            , hand = handkarten |> DreiKarten |> DreiAufDerHand
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
        , spieler1 = spieler
        , spieler2 = computer1
        , spieler3 = computer2
        , spieler4 = computer3
        , ziehstapel = List.drop 12 gemischteKarten
        , ablagestapel = []
        }


naechstenSpielzugVorbereiten : Spiel -> (Spiel -> Spieler) -> (Spiel -> Spieler -> Spiel) -> Spiel
naechstenSpielzugVorbereiten spiel spielerSelektor spielUpdater =
    let
        ( spielbareHand, neuerZiehstapel ) =
            zieheKarte spiel.ziehstapel spiel.spieler1.hand

        alterSpieler =
            spielerSelektor spiel

        neuerSpieler =
            { alterSpieler | hand = spielbareHand }

        geaendertesSpielMitGeandertemSpieler =
            spielUpdater spiel neuerSpieler
    in
        { geaendertesSpielMitGeandertemSpieler | ziehstapel = neuerZiehstapel }


zieheKarte : Ziehstapel -> Hand -> ( Hand, Ziehstapel )
zieheKarte ziehstapel hand =
    let
        ( spielbareHand, neuerZiehstapel ) =
            case hand of
                DreiAufDerHand alteDreiKarten ->
                    let
                        ( neueKarte, neuerZiehstapel ) =
                            zieheKarteVomZiehStapel ziehstapel

                        neueHand =
                            nimmKarteAufHand alteDreiKarten neueKarte
                    in
                        ( neueHand |> VierAufDerHand, neuerZiehstapel )

                VierAufDerHand _ ->
                    ( hand, ziehstapel )
    in
        ( spielbareHand, neuerZiehstapel )


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


legeKarteAb : VierKarten -> Karte -> Ablagestapel -> ( DreiKarten, Ablagestapel )
legeKarteAb (VierKarten handVorher) gespielteKarte ablagestapel =
    let
        neuerAblagestapel =
            gespielteKarte :: ablagestapel

        neueHand =
            List.filter (\k -> k.nummer /= gespielteKarte.nummer) handVorher
    in
        ( DreiKarten neueHand, neuerAblagestapel )


zieheKarteVomZiehStapel : Ziehstapel -> ( Karte, Ziehstapel )
zieheKarteVomZiehStapel ziehstapel =
    let
        karte =
            List.head ziehstapel

        restlicherStapel =
            List.tail ziehstapel

        ( gezogeneKarte, neuerZiehstapel ) =
            case ( karte, restlicherStapel ) of
                ( Just k, Just s ) ->
                    ( k, s )

                _ ->
                    Debug.crash ("impossible state in zieheKarteVomZiehStapel")
    in
        ( gezogeneKarte, neuerZiehstapel )


macheComputerZug : Spiel -> Spiel
macheComputerZug spiel =
    -- TODO
    let
        vorSpieler2Zug =
            naechstenSpielzugVorbereiten spiel (\sp -> sp.spieler2) (\sp s -> { sp | spieler2 = s })
        
        
    in
        -- TODO
        spiel



--gegnerStoeren : AusfuehrenderSpieler -> ( Kartennummer, Stoerkarte ) -> ZielSpieler -> SpielerNachZug
--einschlafen : AusfuehrenderSpieler -> ( Kartennummer, Schnarchkarte ) -> AusfuehrenderSpieler
--kissenSammeln : AusfuehrenderSpieler -> ( Kartennummer, Ruhekissenkarte ) -> AusfuehrenderSpieler
--gewittern : AusfuehrenderSpieler -> ( Kartennummer, Gewitterkarte ) -> ZielSpieler -> SpielerNachZug
--kannKarteSpielen : Kartentyp -> Spieler -> List Spieler -> Bool
--findeLinkenSpieler : AusfuehrenderSpieler -> List Spieler -> Spieler
--hatSpielerGewonnen : AnzahlKissen -> Bool
--sammleKartenAusSpielerstapeln : List (List Karte) -> List Karte


createRandomValues : (List Int -> Msg) -> Int -> Cmd Msg
createRandomValues msg anzahl =
    Random.list anzahl (Random.int 1 anzahl)
        |> Random.generate msg
