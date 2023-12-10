```swift
import CSVReader

let records = try! CSVReader.load(string: """
a,b
c,d
""")

assert(records == [["a", "b"], ["c", "d"]])
```
