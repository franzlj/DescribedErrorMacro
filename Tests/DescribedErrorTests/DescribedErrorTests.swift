import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import DescribedErrorMacros

let testMacros: [String: Macro.Type] = [
    "DescribedError": DescribedErrorMacro.self
]

final class DescribedErrorTests: XCTestCase {
    func testDescribedErrorMacro() {
        assertMacroExpansion(
            """
            @DescribedError enum MyError: Error {
            
                /// My Error Case Description
                case myErrorCase
            }
            """,
            expandedSource: """
            enum MyError: Error {
            
                /// My Error Case Description
                case myErrorCase
                var description: String {
                    switch self {
                    case .myErrorCase:
                        return " My Error Case"
                    }
                }
                var debugDescription: String {
                    switch self {
                    case .myErrorCase:
                        return " My Error Case"
                    }
                }
            }
            extension MyError: CustomStringConvertible {}
            extension MyError: CustomDebugStringConvertible {}
            """,
            macros: testMacros)
    }
}
