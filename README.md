# Swift plays Pokemon

Game Boy emulator written in Swift.

## Features

* Instruction accurate - while it is not *per-cycle* accurate, it will run most of the games without any problems.
* Supports following cartridge types (MBC stands for [memory bank controller](http://bgb.bircd.org/pandocs.htm#memorybankcontrollers)):
  - no MBC - for example: *Tetris*
  - MBC1 - for example: *Legend of Zelda - The Links Awakening* and *Kirby's Dream Land*
  - MBC3 - for example: *Pokemon Red*
* blargg tests:
  * ✅ cpu\_instrs
  * ✅  instr\_timing
* Save/load emulator state to file
* Safe from *Meltdown* and *Spectre*

Not supported:

* Audio
* `stop` instruction (`0x10` from unprefixed instruction set) - not really used

## Source map

- `Swift plays Pokemon.xcodeproj` - XCode project file. Use this instead of Swift Package Manager (SPM does not support Metal shaders that we use inside `GameBoyMac`). Although, if your code depends only on `GameBoyKit` framework, then SPM is *ok*.

- [Sources](Sources)

  - [GameBoyMac](Sources/GameBoyMac) - Mac app that runs the emulator. You can use `--rom` argument to specify ROM (or just give it as a last argument). It uses `GameBoyKit` framework.

  - [GameBoyKit](Sources/GameBoyKit) - Main implementation of GameBoy logic. It contains `GameBoy` class alongside many other useful things like: `Cpu`, `Lcd` and `Debugger`.

  - [Code generation](Sources/Code%20generation) - Code generation executable, based on [lmmendes/game-boy-opcodes](https://github.com/lmmendes/game-boy-opcodes).

- [Tests](Tests)

  - [GameBoyKitTests](Tests/GameBoyKitTests) - Unit tests. Most notably it includes basic tests for every `CPU` instruction.

  - [GameBoyKitROMTests](Tests/GameBoyKitROMTests) - Tiny app that will run ROM based tests, for example [Blargg test ROMs](https://gbdev.gg8.se/files/roms/blargg-gb-tests/). Please note that this an app, not an XCode test target!

- [ROMs](ROMs) - directory that holds games/test ROMs.

  - [Tests - Blargg](ROMs/Tests%20-%20Blargg) - directory to store [Blargg test ROMs](https://gbdev.gg8.se/files/roms/blargg-gb-tests/).

## Screenshots

![Tetris](/Images/Tetris.png)
![Pokemon Red](/Images/Pokemon%20Red.png)
![Legend of Zelda - The Links Awakening](/Images/Legend%20of%20Zelda.png)
![Super Mario Land](/Images/Super%20Mario%20Land.png)
![Bomberman](/Images/Bomberman.png)
![Kirby's Dream Land](/Images/Kirbys%20Dream%20Land.png)

## Keys

For the `GameBoyMac` target (emulator executable) following key map is used:

| Action | Key |
| --- | --- |
| DPAD-UP | <kbd>↑</kbd> |
| DPAD-DOWN | <kbd>↓</kbd> |
| DPAD-LEFT | <kbd>←</kbd> |
| DPAD-RIGHT | <kbd>→</kbd> |
| B | <kbd>S</kbd> |
| A | <kbd>A</kbd> |
| START | <kbd>Q</kbd> |
| SELECT | <kbd>W</kbd> |
| Save state | <kbd>R</kbd> |

## Tests

[Blargg's tests](http://gbdev.gg8.se/wiki/articles/Test_ROMs):

| Test | Result | Note |
| --- | --- | --- |
| cpu\_instrs | ✅ | Essential |
| instr\_timing | ✅ | Essential |
| cgb\_sound | ❌ | Audio is not implemented |
| dmg\_sound | ❌ | Audio is not implemented |
| interrupt\_time | ⚠️ | Not tested |
| mem\_timing | ⚠️ | Not tested |
| halt\_bug | ❌ | No game requires it |
| oam\_bug | ❌ | Game Boy bug that we do not implement, see [The Ultimate Game Boy Talk - 46m 30s](https://youtu.be/HyzD8pNlpwI?t=2791) |

## Links

- Game Boy internals:
  - [The Ultimate Game Boy Talk (33c3)
](https://www.youtube.com/watch?v=HyzD8pNlpwI) by Michael Steil - you have to watch it!
  - [bgb.bircd.org/pandocs](http://bgb.bircd.org/pandocs.htm) - most of the things are here
  - [gbdev.gg8.se](https://gbdev.gg8.se/wiki/articles/Main_Page) - pandocs alternative
  - [pastraiser.com/gameboy_opcodes](https://www.pastraiser.com/cpu/gameboy/gameboy_opcodes.html) - instruction set
  - [reddit.com/Game Boy (vblank) interrupt confusion](https://www.reddit.com/r/EmuDev/comments/7rm8l2/game_boy_vblank_interrupt_confusion/) - interrupts are disabled until the instruction after EI
  - Audio - we do not have audio (yet), but this can be useful:
    - [gbdev.gg8.se/Gameboy sound hardware](https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware)
    - [github.com/PumpMagic/ostrich](https://github.com/PumpMagic/ostrich) - Ostrich is a macOS media player app for playback of Game Boy Sound System files
    - [aselker.github.io/gameboy-sound-chip](https://aselker.github.io/gameboy-sound-chip/)
    - [reddit.com/GB Emulator - SDL2 Audio Queue weird behavior](https://www.reddit.com/r/EmuDev/comments/bnprrf/gb_emulator_sdl2_audio_queue_weird_behavior/)

- Other emulators (github links):
  - [Gekkio/mooneye-gb](https://github.com/Gekkio/mooneye-gb)
  - [mgba-emu/mgba](https://github.com/mgba-emu/mgba)
  - [binji/binjgb](https://github.com/binji/binjgb)
  - [torch2424/wasmboy](https://github.com/torch2424/wasmboy)
  - [Baekalfen/PyBoy](https://github.com/Baekalfen/PyBoy)
  - [simias/gb-rs](https://github.com/simias/gb-rs)

- Other:
  - [WebAssembly Is Fast: A Real-World Benchmark of WebAssembly vs. ES6 by Aaron Turner](https://medium.com/@torch2424/webassembly-is-fast-a-real-world-benchmark-of-webassembly-vs-es6-d85a23f8e193)

## License

“Swift plays Pokemon” is licensed under the Mozilla Public License 2.0 license.
See [LICENSE](LICENSE) for more information.
