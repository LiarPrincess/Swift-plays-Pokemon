import Cocoa
import SwiftBoyKit

@NSApplicationMain
public class AppDelegate: NSObject, NSApplicationDelegate {

  public func applicationDidFinishLaunching(_ aNotification: Notification) {
//    let cpu = loadEmptyCpu()
//    let cpu = loadState(from: "bootrom_0_skipToAudio2.json.json")
//    let cpu = loadState(from: "bootrom_1_skipToNintendoLogo2.json")
    let cpu = loadState(from: "bootrom_2_skipToTileMap2.json")

    print("---------------------")
    cpu.run(maxCycles: .max, lastPC: 0x0051)

//    saveState(cpu: cpu, to: "file.json")
  }
}
