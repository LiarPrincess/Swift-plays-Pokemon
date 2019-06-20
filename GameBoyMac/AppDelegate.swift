// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import AppKit
import MetalKit
import GameBoyKit

public class AppDelegate: NSObject, NSApplicationDelegate {

  private let mtkView = MTKView()
  private let renderer = GameBoyRenderer()

  private lazy var window: NSWindow = {
    let scale = 3
    let width  = Int(Lcd.width) * scale
    let height = Int(Lcd.height) * scale

    return NSWindow(contentRect: NSRect(x: 0, y: 0, width: width, height: height),
                    styleMask: [.titled, .closable, .miniaturizable, .resizable],
                    backing: .buffered,
                    defer: false,
                    screen: nil)
  }()

  public func applicationDidFinishLaunching(_ aNotification: Notification) {
    self.window.title = "Gameboy"
    self.window.backgroundColor = .black
    self.window.setFrameAutosaveName("GameBoyWindow")

    guard let contentView = self.window.contentView else {
      fatalError("Unable to find window content view.")
    }

    self.mtkView.device = self.renderer.device
    self.mtkView.delegate = self.renderer
    self.mtkView.colorPixelFormat = .bgra8Unorm
    self.mtkView.framebufferOnly = true
    self.mtkView.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(self.mtkView)
    NSLayoutConstraint.activate([
      self.mtkView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      self.mtkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      self.mtkView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      self.mtkView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
    ])

    self.window.makeKeyAndOrderFront(nil)
    self.window.makeMain()
  }

  private func old() {
    //    pyTestAll()

    let emulator = GameBoy()
    emulator.run(maxCycles: .max, lastPC: 0x0068)
  }

  // swiftlint:disable:next function_body_length
  private func pyTestAll() {
//    pyTest(pyLoad("pyboy_bootrom_pc_0x3.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x4.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x7.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x8.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xa.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xc.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xf.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x11.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x13.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x14.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x15.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x16.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x18.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x19.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x1a.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x1c.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x1d.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x1f.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x21.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x24.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x27.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x28.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x95.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x96.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x98.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x99.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x9b.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x9c.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x9d.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x9f.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xa0.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xa1.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xa3.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xa4.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xa5.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xa6.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xa7.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x2b.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x2e.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x2f.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x30.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x32.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x34.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x37.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x39.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x3a.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x3b.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x3c.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x3d.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x3e.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x40.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x42.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x45.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x48.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x4a.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x4b.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x4d.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x4e.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x4f.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x51.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x53.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x55.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x56.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x58.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x59.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x5b.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x5d.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x5f.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x60.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x62.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x64.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x66.txt"))
    pyTest(pyLoad("pyboy_bootrom_pc_0x68.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x6a.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x6b.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x6d.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x6e.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x70.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x72.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x73.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x74.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x76.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x78.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x7a.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x7c.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x7e.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x86.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x88.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x89.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x8b.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x8c.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x80.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x81.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x82.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x83.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x85.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x8e.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x8f.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x91.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x93.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xe0.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xe3.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xe6.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xe7.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xe8.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xe9.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xeb.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xec.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xed.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xef.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xf1.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xf3.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xf4.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xf5.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xf6.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xf7.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xf9.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xfa.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xfc.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0xfe.txt"))
//    pyTest(pyLoad("pyboy_bootrom_pc_0x100.txt"))
    print("Finished!")
  }
}
