COZY TOWN FREE - CHARACTERS
===========================

2 playable characters and 2 neighbors (the barista and the baker), 16x24 frames, top-down 3/4 view.
Same world as Cozy Farm: same palette, same 1 px brown outline, light from the top left.

Files
-----
characters/1x, 2x, 4x/
  player-1.png, player-2.png         playable characters (96 x 768 px at 1x)
  neighbor-1.png, neighbor-2.png     neighbors (96 x 192 px at 1x)
characters/characters.json            the same layout as data (rows, frames, fps, loop)

Frame
-----
Every frame is 16 x 24 px. The feet rest on pixel row 21 (counting from 0 at the top),
so a 16x16 tile grid lines up when the frame is drawn 21 px above the feet position.
Left is the mirror of right, with the shading redrawn so light still comes from the left.
Cast shadows are not baked in: draw a soft ellipse under the feet if your game uses them.

Row order (both sheets)
-----------------------
Each animation takes 4 rows, always in this order: down, left, right, up.
Frames run left to right; unused cells are transparent.

Players (32 rows x 6 columns):
  row  0- 3  idle    4 frames   4 fps  loop   (breathing; blinks on frame 2)
  row  4- 7  walk    6 frames  10 fps  loop
  row  8-11  run     6 frames  14 fps  loop
  row 12-15  carry   6 frames  10 fps  loop   (walking with a cardboard box in the arms)
  row 16-19  sit     4 frames   4 fps  loop   (seated, breathing and blinking; put the seat
                                                under pixel rows 19-20 of the frame)
  row 20-23  wave    6 frames   8 fps  once   (raise, wave x4, lower)
  row 24-27  eat     6 frames   6 fps  once   (apple to the mouth, bite, chew)
  row 28-31  water   6 frames   8 fps  loop   (watering can: tilt, pour 3 frames, back)

Neighbors (8 rows x 6 columns):
  row  0- 3  idle    4 frames   4 fps  loop
  row  4- 7  walk    6 frames  10 fps  loop

Pixel position of a frame: x = column * 16, y = row * 24 (at 1x).

Characters
----------
  player-1     short messy hair, teal jacket
  player-2     long hair, mustard sweater, skirt
  neighbor-1   barista
  neighbor-2   baker

License
-------
See LICENSE.txt in the pack.

Cozy Town Complete has all 14 characters (4 playable, 10 neighbors), Godot SpriteFrames
for every sheet and a commercial license: https://aquumgifts.itch.io/cozy-town
