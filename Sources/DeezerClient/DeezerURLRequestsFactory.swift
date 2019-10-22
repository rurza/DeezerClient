//
//  DeezerURLRequestsFactory.swift
//  DeezerClient
//
//  Created by Adam Różyński on 20/10/2019.
//  Copyright © 2019 Adam Różyński. All rights reserved.
//

import Foundation


class DeezerURLRequestsFactory {
    
    enum SearchKind: String {
        case artist
        case track
        case album
        case label
    }
    
    enum SearchResultsOrder: String {
       case ranking = "RANKING"
       case trackAscending = "TRACK_ASC"
       case trackDescending = "TRACK_DESC"
       case artistAscending = "ARTIST_ASC"
       case artistDescending = "ARTIST_DESC"
       case albumAscending = "ALBUM_ASC"
       case albumDescending = "ALBUM_DESC"
       case ratingAscending = "RATING_ASC"
       case ratingDescending = "RATING_DESC"
       case durationAscending = "DURATION_ASC"
       case durationDescending = "DURATION_DESC"
    }
    
    let scheme = "https"
    let host = "api.deezer.com"
    let searchEndpoint = "/search/"
    
    func searchURLRequest(phrases: [String],
                          kinds: [SearchKind]? = nil,
                          resultsOrder: SearchResultsOrder? = nil,
                          strictSearch: Bool? = nil) -> URLRequest {
        precondition(phrases.count == (kinds?.count ?? 1))
        
        var components = urlComponents()
        components.path = searchEndpoint
        
        var queryItems = [URLQueryItem]()
        if let k = kinds {
            if k.count > 1 {
                let searchPhrase = k.enumerated().map { "\($1.rawValue):\"\(phrases[$0])\"" }.joined(separator: " ")
                queryItems.append(URLQueryItem(name: "q", value: searchPhrase))
            } else {
                components.path += k.first!.rawValue
                queryItems.append(URLQueryItem(name: "q", value: phrases.first!))
            }
        } else {
            queryItems.append(URLQueryItem(name: "q", value: phrases.first!))
        }

        if let o = resultsOrder {
            queryItems.append(URLQueryItem(name: "order", value: o.rawValue))
        }
        if let s = strictSearch {
            queryItems.append(URLQueryItem(name: "strict", value: "\(s ? "on" : "off")"))
        }
        components.queryItems = queryItems
        guard let url = components.url else { fatalError() }
        return URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 12)
    }
    
    private func urlComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.scheme = scheme
        return urlComponents
    }
    
    
}
