```swift
import CSVReader

let records = try! CSVReader.read(string: """
a,b
c,d
""")

assert(records == [["a", "b"], ["c", "d"]])
```
