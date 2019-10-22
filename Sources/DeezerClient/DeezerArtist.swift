//
//  DeezerArtist.swift
//  DeezerClient
//
//  Created by Adam Różyński on 19/10/2019.
//  Copyright © 2019 Adam Różyński. All rights reserved.
//

import Foundation

/// [Docs](https://developers.deezer.com/api/artist)
public class DeezerArtist: Codable {
    
    /// The artist's Deezer id
    public let id: Int
    
    /// The artist's name
    public let name: String
    
    /// The url of the artist on Deezer
    public let link: URL?
    
    /// The share link of the artist on Deezer
    public let share: URL?
    
    /// The url of the artist picture. Add 'size' parameter to the url to change size. Can be 'small', 'medium', 'big', 'xl'
    public let picture: URL
    
    /// The url of the artist picture in size small.
    public let smallPicture: URL
    
    /// The url of the artist picture in size medium.
    public let mediumPicture: URL
    
    /// The url of the artist picture in size big.
    public let bigPicture: URL
    
    /// The url of the artist picture in size xl.
    public let xlPicture: URL
    
    /// The number of artist's albums
    public let numberOfAlbums: UInt?
    
    /// The number of artist's fans
    public let numberOfFans: UInt?
    
    /// true if the artist has a smartradio
    public let radio: Bool?
    
    /// API Link to the top of this artist
    public let tracklist: URL?
    
    public let type: DeezerResourceType
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case link
        case share
        case picture
        case smallPicture = "picture_small"
        case mediumPicture = "picture_medium"
        case bigPicture = "picture_big"
        case xlPicture = "picture_xl"
        case numberOfAlbums = "nb_album"
        case numberOfFans = "nb_fan"
        case radio
        case tracklist
        case type
    }
    
}

public class DeezerExtendedArtist: DeezerArtist {
    
    public let role: String?
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        role = try container.decode(String?.self, forKey: .role)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case role
    }
    
}
