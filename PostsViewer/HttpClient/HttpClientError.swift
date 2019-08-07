enum HttpClientError: Error {
    case unknown(Error)
    case invalidPath
    case httpStatus(Int)
}
