module Types exposing (..)

import SelectList exposing (SelectList)


-- DATENMODELL


type NonEmptyString
    = NonEmptyString String


type PositiveZahl
    = PositiveZahl Int


type Kissenanzahl
    = EinKissen
    | ZweiKissen
    | DreiKissen


type Kartentyp
    = Schnarchkarte
    | Ruhekissenkarte Kissenanzahl
    | Stoerkarte
    | Gewitterkarte


type Kartennummer
    = Kartennummer Int


type alias Karte =
    { typ : Kartentyp
    , nummer : Kartennummer
    }


type DreiKarten
    = DreiKarten (List Karte)


type VierKarten
    = VierKarten (List Karte)


type Hand
    = Drei DreiKarten (List Karte)
    | Vier VierKarten (List Karte)



-- Nicht-leer und eindeutig


type Spielername
    = Spielername NonEmptyString



-- AnzahlKissen darf nicht kleiner 0 sein und wächst immer nur an


type AnzahlKissen
    = AnzahlKissen PositiveZahl


type alias Ablegestapel =
    List Karte


type alias Ziehstapel =
    List Karte


type alias Spieler =
    { name : Spielername
    , hand : Hand
    , anzahlKissen : AnzahlKissen
    , obersteKarte : Karte
    , restlicherStapel : List Karte
    }


type alias Spiel =
    { gewinner : Maybe Spieler
    , spieler : SelectList Spieler
    , ziehstapel : Ziehstapel
    , ablegestapel : Ablegestapel
    }


type alias AusfuehrenderSpieler =
    Spieler


type alias ZielSpieler =
    Spieler


type alias SpielerNachZug =
    ( AusfuehrenderSpieler, ZielSpieler )



-- FUNKTIONEN


nimmKarteAufHand : DreiKarten -> Karte -> VierKarten
nimmKarteAufHand (DreiKarten vorherigeKarten) neueKarte =
    neueKarte
        :: vorherigeKarten
        |> VierKarten


legeKarteAb : VierKarten -> Karte -> Ablagestapel -> ( DreiKarten, Ablegestapel )


zieheKarte : Ziehstapel -> ( Karte, Ziehstapel )


spielStarten : Spielername -> Spiel


gegnerStoeren : AusfuehrenderSpieler -> ( Kartennummer, Stoerkarte ) -> ZielSpieler -> SpielerNachZug


einschlafen : AusfuehrenderSpieler -> ( Kartennummer, Schnarchkarte ) -> AusfuehrenderSpieler


kissenSammeln : AusfuehrenderSpieler -> ( Kartennummer, Ruhekissenkarte ) -> AusfuehrenderSpieler


gewittern : AusfuehrenderSpieler -> ( Kartennummer, Gewitterkarte ) -> ZielSpieler -> SpielerNachZug


kannKarteSpielen : Kartentyp -> Spieler -> List Spieler -> Bool


findeLinkenSpieler : AusfuehrenderSpieler -> List Spieler -> Spieler


hatSpielerGewonnen : AnzahlKissen -> Bool


mischeStapel : List Karte -> List Karte


sammleKartenAusSpielerstapeln : List (List Karte) -> List Karte
