# DescribedError Swift Macro

Swift Macro which adds synthesized conformance of `CustomStringConvertible` and `CustomDebugStringConvertible` conformance to Error types. This is helpful when logging own defined error cases, which normally print out via their type plus the cases index, being little to no helpful. Swift Macros are a new thing currently in Beta, so how this one works might change in the future.

## Example Expansion

Original Code:
```
@DescribedError enum MyCustomError: Error {
    
    case invalidStatusCode
}
```

Expanded Macro:
```
@DescribedError enum MyCustomError: Error {
    
    case invalidStatusCode
    var description: String {
        switch self {
        case .invalidStatusCode:
            return " Invalid Status Code"
        }
    }

    var debugDescription: String {
        switch self {
        case .invalidStatusCode:
            return " Invalid Status Code"
        }
    }
}
extension MyCustomError : CustomStringConvertible  {}

extension MyCustomError : CustomDebugStringConvertible  {}
```

## Known Issues
* Currently there seem to be spaces within certain expanded Strings, not sure where this comes from
* The tests don't seem to expand the Conformance Macro correctly, making the test fail although we test against exactly the expansion we can see in the client

## Next steps
- [ ] Support enum cases with associated values
- [ ] Verify tests and erroneous space-char inlcusion in next betas
- [ ] Explore ways to use case code documentation to include in synthesized descriptions

## License
MIT