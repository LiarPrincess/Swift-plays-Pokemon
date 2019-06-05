/// C000-CFFF 4KB Work RAM Bank 0 (WRAM)
/// D000-DFFF 4KB Work RAM Bank 1 (WRAM) (switchable bank 1-7 in CGB Mode)
public class WorkRam: ContinuousMemoryRegion {

  public static let start: UInt16 = 0xc000
  public static let end:   UInt16 = 0xdfff

  public var data = [UInt8](repeating: 0, count: WorkRam.size)
}
