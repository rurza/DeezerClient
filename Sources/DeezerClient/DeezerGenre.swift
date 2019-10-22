//
//  DeezerGenre.swift
//  DeezerClient
//
//  Created by Adam Różyński on 19/10/2019.
//  Copyright © 2019 Adam Różyński. All rights reserved.
//

import Foundation

/// [Docs](https://developers.deezer.com/api/genre)
public class DeezerGenre: Codable {
    
    /// The editorial's Deezer id
    public let id: Int
    
    /// The editorial's name
    public let name: String
    
    /// The url of the genre picture. Add 'size' parameter to the url to change size. Can be 'small', 'medium', 'big', 'xl'
    public let picture: URL
    
    /// The url of the genre picture in size small.
    public let smallPicture: URL
    
    /// The url of the genre picture in size medium.
    public let mediumPicture: URL
    
    /// The url of the genre picture in size big.
    public let bigPicture: URL
    
    /// The url of the genre picture in size xl.
    public let xlPicture: URL
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case picture
        case smallPicture = "picture_small"
        case mediumPicture = "picture_medium"
        case bigPicture = "picture_big"
        case xlPicture = "picture_xl"
    }
    
}
