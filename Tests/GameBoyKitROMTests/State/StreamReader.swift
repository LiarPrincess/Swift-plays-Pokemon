// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// Source:
// https://stackoverflow.com/questions/24581517/read-a-file-url-line-by-line-in-swift

class StreamReader  {

  private var fileHandle: FileHandle?
  private let encoding:   String.Encoding
  private let delimiter:  Data

  private var buffer:     Data
  private let bufferSize: Int

  private var isEof = false

  init?(url:        URL,
        delimiter:  String = "\n",
        encoding:   String.Encoding = .utf8,
        bufferSize: Int = 4_096) {

    guard let fileHandle = FileHandle(forReadingAtPath: url.path),
          let delimiterData = delimiter.data(using: encoding) else {
        return nil
    }

    self.encoding   = encoding
    self.bufferSize = bufferSize
    self.fileHandle = fileHandle
    self.delimiter  = delimiterData
    self.buffer     = Data(capacity: bufferSize)
  }

  deinit {
    self.close()
  }

  /// Return next line, or nil on EOF.
  func nextLine() -> String? {
    if self.isEof {
      return nil
    }

    guard let fileHandle = self.fileHandle else {
      return nil
    }

    while !self.isEof {
      if let range = self.buffer.range(of: self.delimiter) {
        let line = String(data: buffer.subdata(in: 0..<range.lowerBound), encoding: encoding)
        buffer.removeSubrange(0..<range.upperBound)
        return line
      }

      let tmpData = fileHandle.readData(ofLength: self.bufferSize)
      if tmpData.isEmpty {
        self.isEof = true
        // Buffer contains last line in file (not terminated by delimiter)
        if !self.buffer.isEmpty {
          let line = String(data: buffer as Data, encoding: encoding)
          buffer.count = 0
          return line
        }
      } else {
        self.buffer.append(tmpData)
      }
    }

    return nil
  }

  /// Return next line, or nil on EOF.
  func nextLineData() -> Data? {
    if self.isEof {
      return nil
    }

    guard let fileHandle = self.fileHandle else {
      return nil
    }

    while !self.isEof {
      if let range = self.buffer.range(of: self.delimiter) {
        let data = buffer.subdata(in: 0..<range.lowerBound)
        buffer.removeSubrange(0..<range.upperBound)
        return data
      }

      let tmpData = fileHandle.readData(ofLength: self.bufferSize)
      if tmpData.isEmpty {
        self.isEof = true
        // Buffer contains last line in file (not terminated by delimiter)
        if !self.buffer.isEmpty {
          let data = buffer as Data
          buffer.count = 0
          return data
        }
      } else {
        self.buffer.append(tmpData)
      }
    }

    return nil
  }

  /// Start reading from the beginning of file.
  func rewind() {
    self.fileHandle?.seek(toFileOffset: 0)
    self.buffer.count = 0
    self.isEof = false
  }

  /// Close the underlying file. No reading must be done after calling this method.
  func close() {
    self.fileHandle?.closeFile()
    self.fileHandle = nil
  }
}

extension StreamReader : Sequence {
  func makeIterator() -> AnyIterator<String> {
    return AnyIterator { self.nextLine() }
  }
}
