/// FE00-FE9F Sprite Attribute Table (OAM)
public class Oam: ContinuousMemoryRegion {

  public static let start: UInt16 = 0xfe00
  public static let end:   UInt16 = 0xfe9f

  public var data = [UInt8](repeating: 0, count: Oam.size)
}
