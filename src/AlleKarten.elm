module AlleKarten exposing (alleKarten)

import Types exposing (Karte, Kartentyp(..), Kartennummer, Kissenanzahl(..))


alleKarten : List Karte
alleKarten =
    -- es gibt:
    -- 2 Gewitterkarten, 18 normale Störkarten, 5x 3 Kissen, 10x 2 Kissen, 10x 1 Kissen, 20 Einschlafkarten
    [ { typ = Gewitterkarte, nummer = 1 }
    , { typ = Gewitterkarte, nummer = 2 }
    , { typ = Stoerkarte, nummer = 3 }
    , { typ = Stoerkarte, nummer = 4 }
    , { typ = Stoerkarte, nummer = 5 }
    , { typ = Stoerkarte, nummer = 6 }
    , { typ = Stoerkarte, nummer = 7 }
    , { typ = Stoerkarte, nummer = 8 }
    , { typ = Stoerkarte, nummer = 9 }
    , { typ = Stoerkarte, nummer = 10 }
    , { typ = Stoerkarte, nummer = 11 }
    , { typ = Stoerkarte, nummer = 12 }
    , { typ = Stoerkarte, nummer = 13 }
    , { typ = Stoerkarte, nummer = 14 }
    , { typ = Stoerkarte, nummer = 15 }
    , { typ = Stoerkarte, nummer = 16 }
    , { typ = Stoerkarte, nummer = 17 }
    , { typ = Stoerkarte, nummer = 18 }
    , { typ = Stoerkarte, nummer = 19 }
    , { typ = Stoerkarte, nummer = 20 }
    , { typ = Ruhekissenkarte DreiKissen, nummer = 21 }
    , { typ = Ruhekissenkarte DreiKissen, nummer = 22 }
    , { typ = Ruhekissenkarte DreiKissen, nummer = 23 }
    , { typ = Ruhekissenkarte DreiKissen, nummer = 24 }
    , { typ = Ruhekissenkarte DreiKissen, nummer = 25 }
    , { typ = Ruhekissenkarte ZweiKissen, nummer = 26 }
    , { typ = Ruhekissenkarte ZweiKissen, nummer = 27 }
    , { typ = Ruhekissenkarte ZweiKissen, nummer = 28 }
    , { typ = Ruhekissenkarte ZweiKissen, nummer = 29 }
    , { typ = Ruhekissenkarte ZweiKissen, nummer = 30 }
    , { typ = Ruhekissenkarte ZweiKissen, nummer = 31 }
    , { typ = Ruhekissenkarte ZweiKissen, nummer = 32 }
    , { typ = Ruhekissenkarte ZweiKissen, nummer = 33 }
    , { typ = Ruhekissenkarte ZweiKissen, nummer = 34 }
    , { typ = Ruhekissenkarte ZweiKissen, nummer = 35 }
    , { typ = Ruhekissenkarte EinKissen, nummer = 36 }
    , { typ = Ruhekissenkarte EinKissen, nummer = 37 }
    , { typ = Ruhekissenkarte EinKissen, nummer = 38 }
    , { typ = Ruhekissenkarte EinKissen, nummer = 39 }
    , { typ = Ruhekissenkarte EinKissen, nummer = 40 }
    , { typ = Ruhekissenkarte EinKissen, nummer = 41 }
    , { typ = Ruhekissenkarte EinKissen, nummer = 42 }
    , { typ = Ruhekissenkarte EinKissen, nummer = 43 }
    , { typ = Ruhekissenkarte EinKissen, nummer = 44 }
    , { typ = Ruhekissenkarte EinKissen, nummer = 45 }
    , { typ = Schnarchkarte, nummer = 46 }
    , { typ = Schnarchkarte, nummer = 47 }
    , { typ = Schnarchkarte, nummer = 48 }
    , { typ = Schnarchkarte, nummer = 49 }
    , { typ = Schnarchkarte, nummer = 50 }
    , { typ = Schnarchkarte, nummer = 51 }
    , { typ = Schnarchkarte, nummer = 52 }
    , { typ = Schnarchkarte, nummer = 53 }
    , { typ = Schnarchkarte, nummer = 54 }
    , { typ = Schnarchkarte, nummer = 55 }
    , { typ = Schnarchkarte, nummer = 56 }
    , { typ = Schnarchkarte, nummer = 57 }
    , { typ = Schnarchkarte, nummer = 58 }
    , { typ = Schnarchkarte, nummer = 59 }
    , { typ = Schnarchkarte, nummer = 60 }
    , { typ = Schnarchkarte, nummer = 61 }
    , { typ = Schnarchkarte, nummer = 62 }
    , { typ = Schnarchkarte, nummer = 63 }
    , { typ = Schnarchkarte, nummer = 64 }
    , { typ = Schnarchkarte, nummer = 65 }
    ]
