/// FF80-FFFE High RAM (HRAM)
public class HighRam: ContinuousMemoryRegion {
  public static let start: UInt16 = 0xff80
  public static let end:   UInt16 = 0xfffe

  public var data = [UInt8](repeating: 0, count: HighRam.size)
}
