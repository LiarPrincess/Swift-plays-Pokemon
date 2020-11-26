import AppKit
import GameBoyKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  // swiftlint:disable:next implicitly_unwrapped_optional
  private var window: NSWindow!

  // swiftlint:disable:next function_body_length
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let argumentsRaw = CommandLine.arguments
//    let argumentsRaw = ["GameBoyMac", ROMs.tetris]
    let arguments = Arguments(arguments: argumentsRaw)

    let bootrom: Bootrom?
    if let bootromPath = arguments.bootromPath {
      print("Boot-ROM:", bootromPath)
      bootrom = FileSystem.readBootrom(path: bootromPath)
    } else {
      print("Boot-ROM: not provided. Skipping…")
      bootrom = nil
    }

    guard let romPath = arguments.romPath else {
      let arg = Arguments.romArgument
      print("ROM not provided. Use '\(arg)' argument to specify ROM file.")
      exit(1)
    }

    print("ROM:", romPath)
    let cartridge = FileSystem.readRom(romPath: romPath, withSavedRam: true)
    print("ROM title:", cartridge.header.title)
    print("ROM type:", cartridge.header.type)

    let keyMap = KeyMap(
      up: .up,
      down: .down,
      left: .left,
      right: .right,
      a: .a,
      b: .s,
      start: .q,
      select: .w,
      save: .r
    )

    let window = GameBoyWindow(
      scale: 3,
      bootrom: bootrom,
      cartridge: cartridge,
      cartridgePath: romPath,
      keyMap: keyMap
    )

    self.window = window
    self.window.makeKeyAndOrderFront(nil)
    self.window.makeMain()
  }
}
