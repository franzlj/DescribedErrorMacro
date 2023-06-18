// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(conformance)
@attached(member, names: named(`description`), named(`debugDescription`))
public macro DescribedError() = #externalMacro(module: "DescribedErrorMacros", type: "DescribedErrorMacro")
