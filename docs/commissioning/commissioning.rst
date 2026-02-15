Commissioning
===========================

Power LEDs
-----------------

* Stimuli: Plug in in USB-C upstream
  * Expected: LED `+5V UPSTREAM`

* Stimuli: Plug in 5V barrel jack
  * Expected: LED `+5V PROTECTED`

Voltage slew rate
--------------------

* Rationale: Verify slew rate
* Setup: Connect scope on `GND` and `5V PROTECTED`
* Stimuli: Plug in 5V barrel jack

  * Expected linear slew rate from 0 to 5V
  * 2ms calculated
  * 200ms measured...

Overvoltage protection
--------------------

* Precondition:  5V barrel jack connected
* Setup: Connect scope on `GND` and `5V PROTECTED`
* Stimuli: Shorten `GND` and `5V PROTECTED`

  * Expected:

    * LED `+5V PROTECTED` goes off
    * Voltage `+5V PROTECTED` stays on 0V

* Stimuly:  5V barrel jack unplug and plug

  * Expected:

    * LED `+5V PROTECTED` goes back on again
    * Voltage `+5V PROTECTED` goes back to 5V
