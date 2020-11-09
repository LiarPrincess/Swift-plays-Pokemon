import AppKit
import GameBoyKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  // swiftlint:disable:next implicitly_unwrapped_optional
  private var window: NSWindow!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let argumentsRaw = CommandLine.arguments
//    let argumentsRaw = ["GameBoyMac", ROMs.tetris]
    let arguments = Arguments(arguments: argumentsRaw)

    let keyMap = KeyMap(
      up: .up,
      down: .down,
      left: .left,
      right: .right,
      a: .a,
      b: .s,
      start: .q,
      select: .w
    )

    let window = GameBoyWindow(
      scale: 3,
      bootrom: arguments.bootrom,
      cartridge: arguments.rom,
      keyMap: keyMap
    )

    self.window = window
    self.window.makeKeyAndOrderFront(nil)
    self.window.makeMain()
  }
}
