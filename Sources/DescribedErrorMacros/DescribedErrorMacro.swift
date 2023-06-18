import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import RegexBuilder

enum DescribedErrorError: Error {
    case notInAnEnum
    case notAnErrorType
}

public struct DescribedErrorMacro: ConformanceMacro, MemberMacro {
    
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingConformancesOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [(SwiftSyntax.TypeSyntax, SwiftSyntax.GenericWhereClauseSyntax?)] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw DescribedErrorError.notInAnEnum
        }

        return [
            (TypeSyntax("CustomStringConvertible"), nil),
            (TypeSyntax("CustomDebugStringConvertible"), nil)
        ]
    }
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw DescribedErrorError.notInAnEnum
        }
        
        if let inheritenceClause = enumDecl.inheritanceClause,
            inheritenceClause.inheritedTypeCollection.first?.typeName
            .as(SimpleTypeIdentifierSyntax.self)?.name.text == "Error "
        {
            throw DescribedErrorError.notAnErrorType
        }
        
        let descriptionDecl = try VariableDeclSyntax("var description: String") {
            try stringSwitchExprSyntax(for: enumDecl)
        }
        
        let debugDescriptionDecl = try VariableDeclSyntax("var debugDescription: String") {
            try stringSwitchExprSyntax(for: enumDecl)
        }
        
        return [
            DeclSyntax(descriptionDecl),
            DeclSyntax(debugDescriptionDecl)
        ]
    }
    
    private static func stringSwitchExprSyntax(for enumDecl: EnumDeclSyntax) throws -> SwitchExprSyntax {
        try SwitchExprSyntax("switch self") {
            for caseDecl in enumDecl.memberBlock.members.compactMap({ $0.decl.as(EnumCaseDeclSyntax.self) }) {
                if let caseName = caseDecl.elements.first?.identifier {
                    SwitchCaseSyntax("case .\(caseName):") {
                        DeclSyntax(stringLiteral: "return \"\(camelCaseToDescription(caseName.text))\"")
                    }
                }
            }
        }
    }
    
    private static func camelCaseToDescription(_ camelCase: String) -> String {
        camelCase
            .replacing(Regex { ("A"..."Z") }) { match in " \(match.0)"}
            .replacing(Regex {
                Anchor.startOfLine
                Capture {
                    ("a"..."z")
                }
                OneOrMore(.any)
            }) { "\($0.1.uppercased())\($0.0.dropFirst())" }
    }
}

@main
struct DescribedErrorPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DescribedErrorMacro.self
    ]
}
