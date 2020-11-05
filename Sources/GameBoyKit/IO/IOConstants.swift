// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal enum IOConstants {

  /// Frequency at which div register should be incremented.
  internal static let divFrequency: Int = 16_384

  /// Number of div tick to increment
  internal static let divMax = Cpu.clockSpeed / IOConstants.divFrequency // 256
}