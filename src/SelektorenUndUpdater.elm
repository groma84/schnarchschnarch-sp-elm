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


selectSpieler3 : SpielerSelektor
selectSpieler3 spiel =
    spiel.spieler3


updateSpieler3 : SpielerInSpielUpdater
updateSpieler3 spiel spieler =
    { spiel | spieler3 = spieler }


selectSpieler4 : SpielerSelektor
selectSpieler4 spiel =
    spiel.spieler4


updateSpieler4 : SpielerInSpielUpdater
updateSpieler4 spiel spieler =
    { spiel | spieler4 = spieler }
