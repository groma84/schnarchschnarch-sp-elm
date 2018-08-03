module SelektorenUndUpdater exposing (..)

import Types exposing (SpielerInSpielUpdater, SpielerSelektor)


selectSpieler1 : SpielerSelektor
selectSpieler1 spiel =
    spiel.spieler1


updateSpieler1 : SpielerInSpielUpdater
updateSpieler1 spiel spieler =
    { spiel | spieler1 = spieler }
