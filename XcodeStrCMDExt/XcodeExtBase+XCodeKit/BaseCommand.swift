

@_exported import Base
@_exported import XcodeExtBase
@_exported import XcodeKit


/// base for all commands
class BaseCMD: NSObject, XCSourceEditorCommand, XCCMDP {
    
    func perform(with invoc: XCInvocation,
                 completionHandler: @escaping (Swift.Error?) -> Void) {
        
        let contentUTIs = ["public.swift-source",
                           "com.apple.dt.playground"]
        do {
            guard contentUTIs.contains(invoc.contentUTI) else {
                throw SIGError.notSwiftLanguage
            }
            exec(with: invoc)
            completionHandler(nil)
        } catch {
            completionHandler(error)
        }
    }
    
    /// override in children
    func exec(with invoc: XCInvocation) {
        fatalError()
    }
}


enum SIGError: Swift.Error {
    
    case notSwiftLanguage
    case noSelection
    case invalidSelection
    case parseError
}
class SourceEditorExtension: NSObject, XCSourceEditorExtension {}
