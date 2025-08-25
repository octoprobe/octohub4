# Octoprobe Tentacle v0.5

![tentacle](production_v0.5/pcb_top_3D.png)

[schematics](production_v0.5/schematics_tentacle_v0.5.pdf)

## History v0.4 -> v0.5

* Remove silkscreen: R301, U302, R1401, R1505


TODO

* Only one ground line

* LEDS less brigth

* Opening for big boards

* Bigger capacitor on HUB+5V

* Voltage observer on HUB+5V

* GPIO Pads equal to Tentacle v3


* Power DUT via PICO-Infra?
  * + DUT is not powerered when Tentacle is plugged in.

* Power PICO-Probe via PICO-Infra?
  * + PICO-Probe is by default off.
  * + PICO-Probe Boot pin would be controlled by PICO-Infra.

* Manually Power/Unpower PICO-Probe. Using jumper/button/solder bridge
  * + Less load and confusion when powering Tentacles.
