// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import AppKit

public class AppDelegate: NSObject, NSApplicationDelegate {

  private lazy var window = Window()

  public func applicationDidFinishLaunching(_ aNotification: Notification) {
    self.window.makeKeyAndOrderFront(nil)
    self.window.makeMain()
  }
}
