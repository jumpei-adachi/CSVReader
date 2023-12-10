import XCTest
@testable import CSVReader

final class CSVReaderTests: XCTestCase {
  func testNonEscaped() throws {
    let records = try CSVReader.read(string:
"""
a,b
c,d
""")
    XCTAssertEqual(records, [["a", "b"], ["c", "d"]])
  }
  
  func testEscaped() throws {
    let records = try CSVReader.read(string:
"""
"あいう","えお"
"かきく","けこ"
""")
    XCTAssertEqual(records, [["あいう", "えお"], ["かきく", "けこ"]])
  }
  
  func testEscapedIncludingQuotes() throws {
    let records = try CSVReader.read(string:
"""
"\"\"\"\"","\"\""
"",
""")
    XCTAssertEqual(records, [["\"\"", "\""], ["", ""]])
  }
  
  func testEmptyFields() throws {
    let records = try CSVReader.read(string:
"""
a,,
,b,
,,c
,,
""")
    XCTAssertEqual(records, [["a", "", ""], ["", "b", ""], ["", "", "c"], ["", "", ""]])
  }
  
  func testSingleEmptyFields() throws {
    let records = try CSVReader.read(string:
"""



""")
    XCTAssertEqual(records, [[""], [""]]) // 最後の改行は無視されるので[["", "", ""]]ではない
  }
  
  func testNewline() throws {
    let records = try CSVReader.read(string:
"""
a,"あいう
えお
かきく",c
"
","かきく
","
けこ"
"""
    )
    XCTAssertEqual(records, [["a", "あいう\nえお\nかきく", "c"], ["\n", "かきく\n", "\nけこ"]])
  }
  
  func testEmpty() throws {
    let records = try CSVReader.read(string:
"""
""")
    XCTAssertEqual(records, [[""]])
  }
  
  func testSingleEmptyLine() throws {
    let records = try CSVReader.read(string:
"""

""")
    XCTAssertEqual(records, [[""]])
  }
}
