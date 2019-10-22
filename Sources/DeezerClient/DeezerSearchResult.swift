//
//  DeezerSearchResult.swift
//  DeezerClient
//
//  Created by Adam Różyński on 20/10/2019.
//  Copyright © 2019 Adam Różyński. All rights reserved.
//

import Foundation

/// [Documentation](https://developers.deezer.com/api/search)
public class DeezerSearchResult: Codable {
    
    /// The track's Deezer id
    public let id: Int
    
    /// true if the track is readable in the player for the current user
    public let readable: Bool
    
    /// The track's fulltitle
    public let title: String
    
    /// The track's short title
    public let shortTitle: String
    
    /// The track (?) version
    public let titleVersion: String
    
    /// The url of the track on Deezer
    public let link: URL
    
    /// The track's duration in seconds
    public let duration: TimeInterval
    
    /// The track's Deezer rank
    public let rank: Int
    
    /// Whether the track contains explicit lyrics
    public let containsExplicitLyrics: Bool
    
    /// The url of track's preview file. This file contains the first 30 seconds of the track
    public let preview: URL
    
    /// `artist` object containing : id, name, link, picture, picture_small, picture_medium, picture_big, picture_xl
    public let artist: DeezerArtist
    
    /// `album` object containing : id, title, cover, cover_small, cover_medium, cover_big, cover_xl
    public let album: DeezerAlbum
    
    public let type: DeezerResourceType
    
  
    private enum CodingKeys: String, CodingKey {
        case id
        case readable
        case title
        case shortTitle = "title_short"
        case titleVersion = "title_version"
        case link
        case duration
        case rank
        case containsExplicitLyrics = "explicit_lyrics"
        case preview
        case artist
        case album
        case type
    }
}
