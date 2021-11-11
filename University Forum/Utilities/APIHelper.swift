//
//  APIHelper.swift
//  University Forum
//
//  Created by Ian Talisic on 06/10/2021.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]?
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "YOUR_HOST"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}

class APIHelper {
    fileprivate let defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        configuration.timeoutIntervalForResource = 10.0
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    }()

    public init() { }
    
    
    public func uploadPost(_ feed: Feed, completionBlock: @escaping (_ success: Bool, _ message: String?) -> Void) {
            guard let url = Endpoint(path: "/user/upload", queryItems: nil).url else {
                completionBlock(false, "There an issue with api endpoint.")
                return
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
            do {
                let jsonData = try JSONEncoder().encode(feed)
                urlRequest.httpBody = jsonData
            } catch {
                completionBlock(false, error.localizedDescription)
                return
            }
        
        
            let task = defaultSession.dataTask(with: urlRequest) { data, urlResponse, error in
                if let error = error {
                    completionBlock(false, error.localizedDescription)
                    return
                }
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    return
                }
                if httpResponse.statusCode == 200 {
                    guard let data = data else {
                        return
                    }
//                    do {
//                        let userResponse = try JSONDecoder().decode(Response.self, from: data)
//                        completionBlock(userResponse, nil)
//                    } catch let error {
//                        completionBlock(false, error.localizedDescription)
//                    }
                } else {
                    completionBlock(false, error?.localizedDescription)
                }
            }
            task.resume()
        }

}
