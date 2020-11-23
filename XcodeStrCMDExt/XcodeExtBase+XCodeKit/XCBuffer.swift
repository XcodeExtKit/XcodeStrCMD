
typealias XCPosition = XCSourceTextPosition
typealias XCRange = XCSourceTextRange
extension XCRange: XCRangeP {}


typealias XCBuffer = XCSourceTextBuffer
extension XCBuffer: XCBufferP {}

public extension XCBuffer {
    
    @discardableResult
    func selectLines(startIndex: Int,
                     endIndex: Int) -> Bool {
        let start = XCPosition(line: startIndex, column: 0)
        let end = XCPosition(line: endIndex, column: 0)
        return select( XCRange(start: start, end: end) )
    }
    
    //TODO: test
    //    func setInsertionPoint(at idx: Int) {
    //        selections.setArray([XCRange(start: idx, end: idx)])
    ////        selectRange(startIndex: idx,endIndex: idx)
    //    }
    
    
    //MARK: - convs
    
    
    /// returns last selected line indexe, if any is selected
    var lastSelectedLineIdx: Int? {
        (selections.lastObject as? XCRange)?.end.line
    }
    
    var selectedLineIndexes: [Int]? {
        
        var r: [Int] = []
        selections.forEach { rng in
            
            guard let rng = rng as? XCRange else {
                preconditionFailure()
            }
            (rng.start.line...rng.end.line).forEach { lineNumber in
                r.append(lineNumber)
            }
        }
        return r.sth
    }
    
    /// returns selected lines (if any), trimmed from newLines and spaces, in line order
    var selectedLines: [Str]? {
        guard let rng = selectedRange else {
            return nil
        }
        return lines(in: rng).map{$0.trimmingNewlinesAndSpaces}
    }
    
    var selectedRange: NSRange? {
        guard let xcrng = _selectedXCRange else {
            return nil
        }
        let start = xcrng.start.line
        let end = xcrng.end.line
        return NSRange(location: start,
                       length: end + 1 - start)
    }
    
    /// getSelection() != nil
    var hasSelection: Bool {
        selectedRange != nil
    }
    
    
    var _lines: [Str] {
        lines.compactMap { $0 as? Str }
    }
    
    func lines(in rng: NSRange) -> [Str] {
        lines.subarray(with: rng)
            .compactMap { $0 as? Str }
    }
    
    
    //MARK: - insert
    
    //TODO: add some validation ?
    @discardableResult
    func insert(_ str: Str,
                after index: Int) -> Bool  {
        // trying to replace whole array
        var oldArray = lines as! [Str]
        oldArray.insert(str, at: index)
        lines.setArray(oldArray)
        return true
    }
    
    @discardableResult
    func insertAfterSelection(_ str: Str) -> Bool {
        guard let idx = lastSelectedLineIdx else {
            return false
        }
        return insert(str, after: idx) // +1 ?
    }
    
    
    //MARK: - replace
    
    //TODO: test this
    
    @discardableResult
    func removeSelectedLines() -> Bool {
        guard hasSelection else {
            return false
        }
        selections.forEach { rng in
            guard let rng = rng as? XCRange else {
                preconditionFailure()
            }
            (rng.start.line...rng.end.line).forEach { lineNum in
                lines[lineNum] = ""
            }
        }
        return true
    }
    
    //    @discardableResult
    //    func replaceSelectedLines(with str: Str) -> Bool {
    //        removeSelectedLines()
    //        insertAfterSelection(str)
    //    }
    
    @discardableResult
    func replaceSelectedLines(with str: Str) -> Bool {
        guard hasSelection else {
            return false
        }
        removeSelectedLines()
        return insertAfterSelection(str)
    }
    
    //TODO: ?
    //func replaceLines(inRange rng: NSRange, with str: Str
    
    //TODO: ?
    /// if nothing is selected - no action
    //    func replaceSelectedLines(with lines: [Str]) {
    //        guard let rng = selectedRange else {
    //            return
    //        }
    //        return replaceLines(inRange: rng, with: lines)
    //    }
    
    
    /// insert text at the very bottom
    func addAtTheBottom(_ str: Str) {
        lines.add(str)
    }
    
    
    //MARK: -
    
    internal var _selectedXCRange: XCRange? {
        selections.compactMap { $0 as? XCRange }.first
    }
    
    var selectedXCRange: XCRangeP? {
        _selectedXCRange
    }
    //    private func selectRange(startIndex: Int,
    //                             endIndex: Int) {
    //        selections.setArray([XCRange(start: startIndex,
    //                                     end: endIndex)])
    //    }
    
    //TODO: check range exists
    @discardableResult
    func select(_ rng: XCRangeP) -> Bool {
        // guard hasRange(rng)
        selections.setArray([rng])
        return true
    }
    
    
    /// The complete buffer's string representation, as a convenience. Changes to `lines` are immediately reflected in this property, and vice versa
    var finalText: Str {
        completeBuffer
    }
    
    //func hasRange
}

//MARK: -


/** The lines of text in the buffer, including line endings. Line breaks within a single buffer are expected to be consistent. Adding a "line" that itself contains line breaks will actually modify the array as well, changing its count, such that each line added is a separate element. */
//@property (readonly, strong) NSMutableArray <NSString *> *lines
//    var _lines: [Str] {
//        get {
//            lines as NSArray as [Str]
//        }
//        set {
//            lines = newValue
//        }
//    }

/** The text selections in the buffer; an empty range represents an insertion point. Modifying the lines of text in the buffer will automatically update the selections to match. */
//@property (readonly, strong) NSMutableArray <XCSourceTextRange *> *selections
//    var _selections: [XCRange] {
//        get {
//            selections as NSArray
//        }
//        set {
//            selections = newValue
//        }
//    }




