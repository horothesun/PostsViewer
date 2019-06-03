enum HttpClientError: Error {
    case unknown
    case invalidPath
    case httpStatus(Int)
}