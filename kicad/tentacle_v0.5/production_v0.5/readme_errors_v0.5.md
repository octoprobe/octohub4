# Errors on v0.5

* Pin for scope ground
* Labels level shifter are currently below the pins and covered by the soldered cables: They should be on top of the pins!
* Levelshifter limitation: VCCA should not exceed VCCB

## Level

* Option `None`:

  Do not support level shifting

* Option `Both`: Level Shifters, only one assembled

  Depending on the usecase, solder one or the other

* Option `Unwired`: On level shifter but both sides are unwired.

* Option `External`: Allow to mount a external board like
  
  * [Adafruit ada-395](https://www.adafruit.com/product/395) 13mm * 18mm
  
    * https://github.com/adafruit/Fritzing-Library

  * [Sparkfun](https://github.com/sparkfun/8_channel_level_shifter_TXS0108E) 12.7mm x 27.94mm

Add to documentation: https://cdn-shop.adafruit.com/datasheets/txb0108appnote.pdf
