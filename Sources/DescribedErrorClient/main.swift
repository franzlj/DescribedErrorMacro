import DescribedError

@DescribedError enum MyCustomError: Error {
    
    case invalidStatusCode
}

print("Description", MyCustomError.invalidStatusCode.description)
print("DebugDescription", MyCustomError.invalidStatusCode.debugDescription)
