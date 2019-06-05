/// A000-BFFF 8KB External RAM (in cartridge, switchable bank, if any)
public class ExternalRam: ContinuousMemoryRegion {

  public static let start: UInt16 = 0xa000
  public static let end:   UInt16 = 0xbfff

  public var data = [UInt8](repeating: 0, count: ExternalRam.size)
}
