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


type alias Karte =
    { typ : Kartentyp
    , nummer : Kartennummer
    }


type DreiKarten
    = DreiKarten (List Karte)


type VierKarten
    = VierKarten (List Karte)


type Hand
    = DreiAufDerHand DreiKarten
    | VierAufDerHand VierKarten



-- Nicht-leer


type Spielername
    = Spielername NonEmptyString



-- AnzahlKissen darf nicht kleiner 0 sein und wächst immer nur an


type AnzahlKissen
    = AnzahlKissen PositiveZahl


type alias Ablegestapel =
    List Karte


type alias Ziehstapel =
    List Karte


type alias Kartennummer =
    Int


type alias Spieler =
    { name : Spielername
    , hand : Hand
    , anzahlKissen : AnzahlKissen
    , obersteKarte : Maybe Karte
    , restlicherStapel : List Karte
    }


type SpielerNummer
    = SpielerEins
    | SpielerZwei
    | SpielerDrei
    | SpielerVier


type alias Spiel =
    { gewinner : Maybe Spieler
    , spieler1 : Spieler
    , spieler2 : Spieler
    , spieler3 : Spieler
    , spieler4 : Spieler
    , aktiverSpieler : SpielerNummer
    , ziehstapel : Ziehstapel
    , ablegestapel : Ablegestapel
    }


type alias AusfuehrenderSpieler =
    Spieler


type alias ZielSpieler =
    Spieler


type alias SpielerNachZug =
    ( AusfuehrenderSpieler, ZielSpieler )


type Status
    = Startmenue
    | SpielImGange Spiel
    | Beendet


type KartenInteraktion
    = Handkarte
    | Ablagestapel
    | EigenerKartenstapel
    | FremderKartenstapel ZielSpieler


type Cursor
    = Leer
    | KarteAktiv Karte
