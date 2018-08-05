module Funktionen exposing (spielStarten, createRandomValues, naechstenSpielzugVorbereiten, legeKarteAb, macheComputerZug)

import Random
import Types exposing (..)
import Msgs exposing (..)
import SelektorenUndUpdater exposing (selectSpieler2, updateSpieler2, selectSpieler3, updateSpieler3, selectSpieler4, updateSpieler4)


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


naechstenSpielzugVorbereiten : Spiel -> SpielerSelektor -> SpielerInSpielUpdater -> Spiel
naechstenSpielzugVorbereiten spiel spielerSelektor spielUpdater =
    let
        alterSpieler =
            spielerSelektor spiel

        ( spielbareHand, neuerZiehstapel ) =
            zieheKarte spiel.ziehstapel alterSpieler.hand

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


legeKarteAb : SpielerSelektor -> SpielerInSpielUpdater -> Spiel -> Karte -> Spiel
legeKarteAb spielerSelektor spielerUpdater spiel karte =
    let
        spieler =
            spielerSelektor spiel

        ( neueHand, neuerAblagestapel ) =
            case spieler.hand of
                VierAufDerHand vierKarten ->
                    let
                        ( dreiKarten, ablagestapel ) =
                            legeKarteAb_ vierKarten karte spiel.ablagestapel
                    in
                        ( DreiAufDerHand dreiKarten, ablagestapel )

                DreiAufDerHand _ ->
                    ( spieler.hand, spiel.ablagestapel )

        updatedSpieler =
            { spieler | hand = neueHand }

        updatedSpielMitGeaendertemSpieler =
            spielerUpdater spiel updatedSpieler

        updatedSpiel =
            { updatedSpielMitGeaendertemSpieler | ablagestapel = neuerAblagestapel }
    in
        updatedSpiel


legeKarteAb_ : VierKarten -> Karte -> Ablagestapel -> ( DreiKarten, Ablagestapel )
legeKarteAb_ (VierKarten handVorher) gespielteKarte ablagestapel =
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


macheEinenComputerZug : SpielerSelektor -> SpielerInSpielUpdater -> Spiel -> Spiel
macheEinenComputerZug spielerSelektor spielerInSpielUpdater spiel =
    let
        vorZug =
            naechstenSpielzugVorbereiten spiel spielerSelektor spielerInSpielUpdater

        naechsterZug =
            entscheideNaechstenZug spielerSelektor vorZug

        spielNachZug =
            case naechsterZug of
                KarteAblegen ->
                    let
                        spieler =
                            spielerSelektor vorZug

                        karte =
                            case spieler.hand of
                                VierAufDerHand vierKarten ->
                                    sucheAbzulegendeKarte vierKarten

                                DreiAufDerHand dreiKarten ->
                                    Debug.crash "bei drei Karten kann niemals eine abgelegt werden -- kommt nie vor"
                    in
                        legeKarteAb spielerSelektor spielerInSpielUpdater vorZug karte
    in
        spielNachZug


macheComputerZug : Spiel -> Spiel
macheComputerZug spiel =
    spiel
        |> macheEinenComputerZug selectSpieler2 updateSpieler2
        |> macheEinenComputerZug selectSpieler3 updateSpieler3
        |> macheEinenComputerZug selectSpieler4 updateSpieler4


entscheideNaechstenZug : SpielerSelektor -> Spiel -> ComputerAktion
entscheideNaechstenZug spielerSelektor spiel =
    let
        spieler =
            spielerSelektor spiel
    in
        KarteAblegen


sucheAbzulegendeKarte : VierKarten -> Karte
sucheAbzulegendeKarte (VierKarten vierKarten) =
    let
        pruefeKartenTyp gesuchterTyp karte =
            case karte.typ == gesuchterTyp of
                True ->
                    Just karte

                False ->
                    Nothing

        pruefeKarten karte schonGefunden =
            case schonGefunden of
                Just k ->
                    schonGefunden

                Nothing ->
                    let
                        nurWennNochNichtGefunden fn gefunden =
                            case gefunden of
                                Just x ->
                                    gefunden

                                Nothing ->
                                    fn karte
                    in
                        List.foldl nurWennNochNichtGefunden
                            schonGefunden
                            [ pruefeKartenTyp <| Stoerkarte
                            , pruefeKartenTyp <| Ruhekissenkarte EinKissen
                            , pruefeKartenTyp <| Ruhekissenkarte ZweiKissen
                            , pruefeKartenTyp <| Schnarchkarte
                            , pruefeKartenTyp <| Ruhekissenkarte DreiKissen
                            , pruefeKartenTyp <| Gewitterkarte
                            ]
    in
        case List.foldl pruefeKarten Nothing vierKarten of
            Just k ->
                k

            Nothing ->
                Debug.crash "keine ablegbare Karte auf der Hand -- kommt nie vor"



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
