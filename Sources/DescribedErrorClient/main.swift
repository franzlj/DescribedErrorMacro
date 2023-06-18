import DescribedError

@DescribedError enum MyCustomError: Error {
    
    /// Invalid status code
    case invalidStatusCode
}

print("Description", MyCustomError.invalidStatusCode.description)
print("DebugDescription", MyCustomError.invalidStatusCode.debugDescription)
