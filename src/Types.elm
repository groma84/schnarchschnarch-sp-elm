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
    | Störkarte
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
    , stapel : List Karte
    }


type alias Spiel =
    { gewinner : Maybe Spieler
    , spieler : SelectList Spieler
    , ziehstapel : Ziehstapel
    , ablegestapel : Ablegestapel
    }



-- FUNKTIONEN


nimmKarteAufHand : DreiKarten -> Karte -> VierKarten
nimmKarteAufHand (DreiKarten vorherigeKarten) neu =
    neu
        :: vorherigeKarten
        |> VierKarten
