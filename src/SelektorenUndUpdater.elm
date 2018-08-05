module SelektorenUndUpdater exposing (..)

import Types exposing (SpielerInSpielUpdater, SpielerSelektor)


selectSpieler1 : SpielerSelektor
selectSpieler1 spiel =
    spiel.spieler1


updateSpieler1 : SpielerInSpielUpdater
updateSpieler1 spiel spieler =
    { spiel | spieler1 = spieler }

selectSpieler2 : SpielerSelektor
selectSpieler2 spiel =
    spiel.spieler2


updateSpieler2 : SpielerInSpielUpdater
updateSpieler2 spiel spieler =
    { spiel | spieler2 = spieler }
