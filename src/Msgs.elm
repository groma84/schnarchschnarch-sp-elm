module Msgs exposing (..)

import Types exposing (Karte, ZielSpieler)


type Msg
    = NoOp
    | NeuesSpielStarten
    | MischeKartenAmAnfang (List Int)
    | NaechstenSpielzugVorbereiten
    | HandkarteGeklickt (Maybe Karte)
    | AblagestapelGeklickt
    | EigenerKartenstapelGeklickt
    | FremderKartenstapelGeklickt ZielSpieler
