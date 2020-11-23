

typealias XCInvocation = XCSourceEditorCommandInvocation

extension XCInvocation: XCInvocationP {}
public extension XCInvocation {
    
    var lastSelectedLineIdx: Int? {
        buffer.lastSelectedLineIdx
    }
    
    var tabWidth: Int {
        buffer.tabWidth
    }
    
    var contentUTI: Str {
        buffer.contentUTI
    }
    
    /// selects text in the given range
    @discardableResult
    func selectLines(startIndex: Int,
                     endIndex: Int) -> Bool {
        buffer.selectLines(startIndex: startIndex,
                           endIndex: endIndex)
    }
    
    /// inserts string at given index, can be line with breaks -> will immediately regenerate current buffer
    @discardableResult
    func insert(_ str: Str,
                after lineIndex: Int) -> Bool {
        buffer.insert(str, after: lineIndex)
    }

    /// insert text at the very bottom
    func addAtTheBottom(_ str: Str) {
        buffer.addAtTheBottom(str)
    }
}
