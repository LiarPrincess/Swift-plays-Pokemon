// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable implicitly_unwrapped_optional

import AppKit
import MetalKit
import GameBoyKit

public class AppDelegate: NSObject, NSApplicationDelegate {

  private var gameBoy:  GameBoy!
  private var device:   MTLDevice!
  private var renderer: GameBoyRenderer!

  private let mtkView = MTKView()

  private let window: NSWindow = {
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
    let args = parseArguments()

    self.gameBoy  = GameBoy(bootrom: args.bootrom, cartridge: args.cartridge)
    self.device   = createDevice()
    self.renderer = GameBoyRenderer(gameBoy: self.gameBoy, device: self.device)

    self.initWindow()
    self.initView()

    self.window.makeKeyAndOrderFront(nil)
    self.window.makeMain()
  }

  private func initWindow() {
    self.window.title = "Gameboy"
    self.window.backgroundColor = .black
    self.window.setFrameAutosaveName("GameBoyWindow")
  }

  private func initView() {
    guard let contentView = self.window.contentView else {
      fatalError("Unable to find window content view.")
    }

    self.mtkView.device = self.device
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
  }
}
