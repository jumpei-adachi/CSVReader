import Foundation

// RFC4180
// レコードごとにフィールド数が異なっていてもよい
public class CSVReader {
  public struct ParseError: Error {
  }
  
  public static func load(url: URL) throws -> [[String]] {
    return try load(string: try String(contentsOf: url))
  }
  
  public static func load(string: String) throws -> [[String]] {
    // 末尾に改行が置かれている形式に統一する。配列外参照を防ぐための番兵の役割も果たす。
    let s = Array(string.last != "\n" ? string + "\n" : string)
    
    var k = 0
    
    // 再帰下降構文解析を用いて解析する
    func file() throws -> [[String]] {
      var result: [[String]] = [try record()]
      while k < s.count - 1 {
        if s[k] != "\n" {
          throw ParseError()
        }
        k += 1
        result.append(try record())
      }
      return result
    }
    
    func record() throws -> [String] {
      var result: [String] = [try field()]
      while s[k] == "," {
        k += 1
        result.append(try field())
      }
      return result
    }
    
    func field() throws -> String {
      if s[k] == "\"" {
        return try escaped()
      } else {
        return try nonEscaped()
      }
    }
    
    func escaped() throws -> String {
      assert(s[k] == "\"")
      k += 1
      var result = [Character]()
      while k < s.count {
        if s[k] != "\"" {
          result.append(s[k])
          k += 1
        } else if s[k + 1] == "\"" {
          result.append("\"")
          k += 2
        } else {
          break
        }
      }
      if k == s.count {
        throw ParseError()
      }
      assert(s[k] == "\"")
      k += 1
      return String(result)
    }
    
    func nonEscaped() throws -> String {
      var result = [Character]()
      while s[k] != "," && s[k] != "\n" && s[k] != "\"" {
        result.append(s[k])
        k += 1
      }
      return String(result)
    }
    
    return try file()
  }
}
