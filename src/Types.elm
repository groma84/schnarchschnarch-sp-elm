module Types exposing (..)

-- Kissenanzahl darf nur 1, 2 oder 3 sein


type Kissenanzahl
    = Kissenanzahl Int


type Karte
    = Schnarchkarte
    | Ruhekissenkarte Kissenanzahl
    | Störkarte
    | Gewitterkarte



-- Die Liste in Hand ist genau 3 oder 4 Karten lang


type Hand
    = Hand (List Karte)



-- Darf nicht leer sein


type Spielername
    = Spielername String



-- AnzahlKissen darf nicht kleiner 0 sein und wächst immer nur an


type AnzahlKissen
    = AnzahlKissen Int


type alias Ablegestapel =
    List Karte


type alias Ziehstapel =
    List Karte


type alias Spieler =
    { name : Spielername
    , hand : Hand
    , anzahlKissen : AnzahlKissen
    }
