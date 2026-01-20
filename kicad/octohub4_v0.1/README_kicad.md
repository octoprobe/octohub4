# Plugins used

* https://github.com/bennymeg/JLC-Plugin-for-KiCad

  JLC PCB Plug-in for KiCad

  Fill Symbol Field `JLC Part`

* https://github.com/MitjaNemec/ReplicateLayout


## Production

### Increment version number

Update in all sheets (`*.kicad_*`)

`(date "2025-09-02")`

`(rev "0.5")`

### In schematics

Menu `Inspect -> Electrical Rule Chacker`, button `Run ERC`, No violatons

### In pcb - final check and final commit

Menu `Tools -> Update PCB from Schematic`, select all,  `Build Changes`, No violatons

Menu `Tools -> Cleanup Tracks & Vias`, Actions: select all, Empty output, `Close`

Menu `Inspect -> Design Rules Checker`, check `Refill all zones`, button `Run DRC . No errors, no warnings.

Delete all files in directory `production`.

Icon `Fabricaton Toolkit`, Options empty, check `Apply automatic translatons`, check `Exluce DNP components`. `Generate`.

Rename production folder and add version number

### Upload to JLCPCB

Tooling holes: `Added by Customer`

Accept this error:
```
The below parts won't be assembled due to data missing.
J203,J201,C216 designators don't exist in the BOM file.
```

BOM
 * Verify that the correct values, specially C and R, have been choosen.
 * J201, ...: Do not place.

Manual correction
 * Various chips: rotate

## Commit

### Print schematics

* Schematics, Menu `File -> Print`, check 'Print drawing sheet - Color`, `Print`, `All Pages`, `Print to File`.

* Rename folder `production` to `production_v0.x`.

* Move `~/Documents/output.pdf` to `.../production/schematics_octohub4_v0.x.pdf`

* Prepare file `.../production/readme_errors_v0.x.pdf`

