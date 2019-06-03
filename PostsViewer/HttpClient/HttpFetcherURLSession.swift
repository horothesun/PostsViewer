import Foundation

struct HttpFetcherURLSession: HttpFetcher {

    func fetch(path: String, completion: @escaping (Result<Data>) -> Void) {
        guard let url = URL(string: path) else {
            completion(.failure(HttpClientError.invalidPath))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? HttpClientError.unknown))
                return
            }
            if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode != 200 {
                completion(.failure(HttpClientError.httpStatus(httpResponse.statusCode)))
            }
            completion(.success(data))
        }
        task.resume()
    }
}
