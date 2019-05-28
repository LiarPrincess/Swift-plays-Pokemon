import Cocoa
import SwiftBoyKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  private let debug = Debug()

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let memory = Memory(delegate: nil)
    memory.loadBootrom()

    let cpu = Cpu(memory: memory, delegate: self.debug)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
  }
}
