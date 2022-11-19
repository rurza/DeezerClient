//
//  DeezerClient.swift
//  DeezerClient
//
//  Created by Adam Różyński on 17/10/2019.
//  Copyright © 2019 Adam Różyński. All rights reserved.
//

import Foundation
import Combine

public protocol DeezerClientCacheProvider: AnyObject {
    func cachedResponseForRequest<Resource: Codable>(_ request: URLRequest) -> DeezerResponse<Resource>?
    func saveResponse<Resource: Codable>(_ response: DeezerResponse<Resource>, forRequest req: URLRequest)
}

public class DeezerClient {
    
    let urlRquestsFactory = DeezerURLRequestsFactory()
    let session = URLSession.shared
    public weak var cacheProvider: DeezerClientCacheProvider?
    
    public init() {}
    
    public func searchForArtist(_ artistName: String) -> AnyPublisher<DeezerResponse<DeezerArtist>, Error> {
        let request = urlRquestsFactory.searchURLRequest(phrases: [artistName], kinds: [.artist], strictSearch: true)
        return makeRequestPublisher(request)
    }
    
    public func searchForAlbum(named albumName: String) -> AnyPublisher<DeezerResponse<DeezerAlbum>, Error> {
        let request = urlRquestsFactory.searchURLRequest(phrases: [albumName], kinds: [.album])
        return makeRequestPublisher(request)
    }
    
    public func searchForAlbum(named albumName: String, byArtist artist: String) -> AnyPublisher<DeezerResponse<DeezerTrack>, Error> {
        let request = urlRquestsFactory.searchURLRequest(phrases: [albumName, artist], kinds: [.album, .artist], strictSearch: false)
        return makeRequestPublisher(request)
    }
    
    public func searchForTrack(withTitle title: String, fromArtist artist: String) -> AnyPublisher<DeezerResponse<DeezerTrack>, Error> {
        let request = urlRquestsFactory.searchURLRequest(phrases: [artist, title], kinds: [.artist, .track])
        return makeRequestPublisher(request)
    }

    @available(*, deprecated, message: "Use the async version")
    public func getTopAlbumsChart() -> AnyPublisher<DeezerResponse<DeezerAlbum>, Error> {
        let r = urlRquestsFactory.getTopAlbumsRequest()
        return makeRequestPublisher(r, useCache: false)
    }

    public func getTopAlbumsChart() async throws -> DeezerResponse<DeezerAlbum> {
        let r = urlRquestsFactory.getTopAlbumsRequest()
        return try await executeRequest(r)
    }
    
    fileprivate func makeRequestPublisher<Item>(_ request: URLRequest, useCache: Bool = true) -> AnyPublisher<DeezerResponse<Item>, Error> where Item: Decodable {
        if let r = cacheProvider?.cachedResponseForRequest(request) as DeezerResponse<Item>?, useCache {
            return Future<DeezerResponse<Item>, Error> { future in
                future(.success(r))
            }.eraseToAnyPublisher()
        }
        return session
            .dataTaskPublisher(for: request)
            .tryMap {
                let decoder = JSONDecoder()
                if let serviceError = try? decoder.decode(DeezerWrappedError.self, from: $0.data) {
                    let error = serviceError.error
                    throw NSError(domain: error.type.rawValue,
                                  code: error.code.rawValue,
                                  userInfo: [NSLocalizedDescriptionKey: error.message])
                }
                return $0.data
        }
        .decode(type: DeezerResponse<Item>.self, decoder: JSONDecoder())
        .map {
            self.cacheProvider?.saveResponse($0, forRequest: request)
            return $0
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    private func executeRequest<Item: Codable>(_ request: URLRequest, useCache: Bool = false) async throws -> DeezerResponse<Item> {
        if let cached = cacheProvider?.cachedResponseForRequest(request) as DeezerResponse<Item>?, useCache {
            return cached
        }
        let (data, _) = try await session.data(for: request)
        let decoder = JSONDecoder()
        if let serviceError = try? decoder.decode(DeezerWrappedError.self, from: data) {
            let error = serviceError.error
            throw NSError(domain: error.type.rawValue,
                          code: error.code.rawValue,
                          userInfo: [NSLocalizedDescriptionKey: error.message])
        } else {
            let response = try decoder.decode(
                DeezerResponse<Item>.self,
                from: data
            )
            cacheProvider?.saveResponse(response, forRequest: request)
            return response
        }
    }
}

public class DeezerError: Codable {
    public enum Code: Int, Codable {
        case quote = 4
        case exceededItemsLimit = 100
        case permission = 200
        case invalidToken = 300
        case parameter = 500
        case missingParameter = 501
        case invalidQuery = 600
        case busyService = 700
        case dataNotFound = 800
    }
    
    public enum ErrorType: String, Codable {
        case exception = "Exception"
        case oAuthExcpetion = "OAuthException"
        case parameterException = "ParameterException"
        case missingParameterException = "MissingParameterException"
        case invalidQueryException = "InvalidQueryException"
        case dataException = "DataException"
    }
    
    let message: String
    let code: Code
    let type: ErrorType
    
}

fileprivate class DeezerWrappedError: Codable { let error: DeezerError }
