// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import AppKit

let isRunningTest = NSClassFromString("XCTestCase") != nil

let app = NSApplication.shared
let delegate = TestAppDelegate()
app.delegate = isRunningTest ? TestAppDelegate() : AppDelegate()
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)