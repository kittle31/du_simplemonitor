Simple Ore Monitor Setup

**You will need**
- 1 programming board
- 1 screen
- Up to 8 containers

Place the programming board and screen someplace on your construct
Link from the board to:  the screen, the construct's core and up to 8 containers.  Links can go in any order.

Copy the contents of the file **board.json** into your clipboard and load that into your programming board. 

Edit the LUA parameters and set the title for the top of the screen. and the threshold, when the container volume is below the threshold number, the text will turn red.

This script uses the container names to display on the screen -- so label your containers accordingly.

This script is intended to monitor Ore or Ingots, so it displays only the container volume, and the container name.  Thus it will not work well for items. 
