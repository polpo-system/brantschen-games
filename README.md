# brantschen-games

Small games for the Oberon desktop from 1996, written by students in Switzerland on the XY plane
of ETH Oberon, made to run on [polpo](https://github.com/polpo-system/polpo):

| command | game | author |
| --- | --- | --- |
| `Tetris.Start 1` (2: two players) | Tetris | Peter Brantschen, 1996 |
| `Minesweeper.Start 13546 10 18` (seed, size 3-40, bombs) | Minesweeper | Peter Brantschen |
| `Games.Tron 5` (speed 1-10) | Tron, for two players | Peter Brantschen, 1996 |
| `PacMan.Spielen` | PacMan | Roland Brand, Aarau, 1996 (with `Grafik`) |
| `Vier.HitMe 3` (games to win) | Vier gewinnt (Connect Four), for two players | Michael Klein (duke), 1996 (with `Ausgabe`) |

`Linie` and `Ziffer` (lines and digits on the XY plane) are Brantschen's; `Linie2.Mod` is his other
version of `Linie` (with a Bresenham line for its fractal demos), kept but not compiled.
`games-doc.txt` is the documentation that came with them.

A game takes over the desktop until it ends; the keys are written under each game. Ctrl+Alt+C or
Ctrl+Pause stops a game at once (polpo's desktop interrupt).

## The changes for polpo

The history of this repository starts with the sources as they were found, so every change can be
seen, each in its own commit:

- the Oberon texts converted to plain text (two of them first taken out of an archive wrapper);
- `XYtop`, a small module between the games and the XYplane of ETH Oberon, which stays as it is:
  the games drew near y = 0 for an 800 x 600 screen, where a viewer of XYplane shows nothing;
  XYtop moves each game into the rows a viewer shows and writes its keys under it;
- Tetris, Tron and PacMan timed by the clock (`Oberon.Time`) instead of by turns of a loop, which
  are far too fast today;
- Vier gewinnt opens the XY plane (it did not), and `Ausgabe` clips to the plane from 0, 0;
- the arrow keys in Tetris and PacMan.

## Building

With portia: `portia.Install brantschen-games`. By hand, in this directory (objects in `obj/x86`):

```
mkdir -p obj/x86
for m in XYtop Linie Ziffer Ausgabe Games Grafik Minesweeper PacMan Tetris Vier; do
  ../polpo/bin/x86/loksh compiler.Compile /s $m.Mod
done
../polpo/bin/x86/loksh System.Init      # then a command of the table, clicked in a viewer
```

The sources carry the names of their authors and no license; they are kept here as they were
distributed, with the changes above.
