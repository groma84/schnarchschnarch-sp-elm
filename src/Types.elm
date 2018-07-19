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
    = Drei DreiKarten
    | Vier VierKarten



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
