import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    var cpu = Cpu()
    cpu.run()
  }

  func applicationWillTerminate(_ aNotification: Notification) {
  }
}
