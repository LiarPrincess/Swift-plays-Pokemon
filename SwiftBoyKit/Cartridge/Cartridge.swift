// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public class Cartridge {

  internal let rom0 = Rom0()
  internal let rom1 = Rom1()
  internal let ram = ExternalRam()
}
