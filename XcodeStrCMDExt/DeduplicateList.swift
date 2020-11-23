

@_exported import XcodeExtBase


//TODO: consider allowing comma separated and not
// first separate into words (comps by comma or space)
// then process

/// takes a list of Strings (comma separated) and removes all duplicates from it
class DeduplicateList: BaseCMD {
    
    override func exec(with invoc: XCInvocation) -> Void {
        
        let selections = invoc.buffer.selections
        let lines = invoc.buffer.lines
        
        let selection = selections.compactMap { $0 as? XCRange }.first
        
        if let startingLine = selection?.start.line,
           let endingLine = selection?.end.line {
            
            let linesRange = NSRange(location: startingLine, length: endingLine + 1 - startingLine)
            
            let sortedLines = lines
                .subarray(with: linesRange)
                .compactMap { $0 as? String }
                .sorted { $0.trimmed.caseInsensitiveCompare($1.trimmed) == .orderedAscending }
            
            //TODO:
//            invoc.buffer.lines
//                .replaceObjects(in: linesRange,
//                                withObjectsFrom: sortedLines)
        }
    }
}


