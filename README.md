Simple Monitor setup

**You will need**
- 1 Programming board
- 1 Screen
- Up to 9 containers



Link the board to the screen, name the slot as 'screen'

Create an event for 'Start', copy the contents of start.lua

Create an event for 'Stop', copy the contents of stop.lua

Create an event for Tick, named "Monitor", copy the contents of unit.lua

Link the board to your containers, and name each of the slots.

Lastly, edit the Monitor code and update the labels, container names and ore weights based on your containers.  ex 
```
setReportLine(1,screen,"Iron", iron, 7.85)
setReportLine(2,screen,"Carbon", carbon, 2.27)
setReportLine(3,screen,"Silicon", silicon, 2.33)
setReportLine(4,screen,"Aluminum", aluminum, 2.70)
setReportLine(5,screen,"Calcium", calcium, 1.55)
setReportLine(6,screen,"Chromium", chromium, 7.19)
```
