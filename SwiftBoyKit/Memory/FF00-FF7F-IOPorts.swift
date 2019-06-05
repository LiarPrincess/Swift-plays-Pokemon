// TODO: catch them all for ther IO addresses

/// FF00-FF7F I/O Ports
public class IOPorts: ContinuousMemoryRegion {

  public static let start: UInt16 = 0xff00
  public static let end:   UInt16 = 0xff7f

  public var data = [UInt8](repeating: 0, count: IOPorts.size)

}
