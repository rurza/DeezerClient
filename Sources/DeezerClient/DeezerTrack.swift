//
//  DeezerTrack.swift
//  DeezerClient
//
//  Created by Adam Różyński on 19/10/2019.
//  Copyright © 2019 Adam Różyński. All rights reserved.
//

import Foundation

/// [Docs](https://developers.deezer.com/api/track)
public class DeezerTrack: Codable {
    
    /// The track's Deezer id
    public let id: Int
    
    /// true if the track is readable in the player for the current user
    public let readable: Bool
    
    /// The track's fulltitle
    public let title: String
    
    /// The track's short title
    public let shortTitle: String
    
    /// The track version
    public let titleVersion: String
    
    /// The url of the track on Deezer
    public let link: URL
    
    /// the track's duration in seconds
    public let duration: TimeInterval
    
    /// The track's Deezer rank
    public let rank: Int
    
    /// Whether the track contains explicit lyrics
    public let containsExplicitLyrics: Bool
    
    /// The url of track's preview file. This file contains the first 30 seconds of the track
    public let preview: URL
    
    /// artist object containing : id, name, link, share, picture, picture_small, picture_medium, picture_big, picture_xl, nb_album, nb_fan, radio, tracklist, role
    public let artist: DeezerArtist
    
    /// album object containing : id, title, link, cover, cover_small, cover_medium, cover_big, cover_xl, release_date
    public let album: DeezerAlbum?
        
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
    }
    
}

public class DeezerExtendedTrack: DeezerTrack {
 
    /// The track unseen status
    public let unseen: Bool?
    
    /// The track isrc
    public let isrc: String?
    
    /// The position of the track in its album
    public let trackPosition: UInt?
    
    /// The track's album's disk number
    public let diskNumber: UInt?
    
    /// The track's release date
    public let releaseDate: Date?
    
    /// The explicit content lyrics values (0:Not Explicit; 1:Explicit; 2:Unknown; 3:Edited; 6:No Advice Available)
    public let explicitContentLyrics: ExplicitContent?
    
    /// The explicit cover value (0:Not Explicit; 1:Explicit; 2:Unknown; 3:Edited; 6:No Advice Available)
    public let explicitContentCover: ExplicitContent?
    
    /// Beats per minute
    public let bpm: Float?
    
    /// Signal strength
    public let gain: Float?
    
    /// List of countries where the track is available
    public let availableCountries: [String]?
    
    /// Return an alternative readable track if the current track is not readable
    public let alternative: DeezerTrack?
    
    /// Return a list of contributors on the track
    public let contributors: [DeezerArtist]?

    
    private enum CodingKeys: String, CodingKey {
           case unseen
           case isrc
           case trackPosition
           case diskNumber
           case releaseDate
           case explicitContentLyrics
           case explicitContentCover
           case bpm
           case gain
           case availableCountries
           case alternative
           case contributors
     }
     
     public enum ExplicitContent: UInt, Codable {
         case notExplicit = 0
         case explicit = 1
         case unknown = 2
         case edited = 3
         case noAdviceAvailable = 6
     }
     
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        unseen = try container.decode(Bool?.self, forKey: .unseen)
        isrc = try container.decode(String?.self, forKey: .isrc)
        trackPosition = try container.decode(UInt?.self, forKey: .trackPosition)
        diskNumber = try container.decode(UInt?.self, forKey: .diskNumber)
        releaseDate = try container.decode(Date?.self, forKey: .releaseDate)
        explicitContentLyrics = try container.decode(ExplicitContent?.self, forKey: .explicitContentLyrics)
        explicitContentCover = try container.decode(ExplicitContent?.self, forKey: .explicitContentCover)
        bpm = try container.decode(Float?.self, forKey: .bpm)
        gain = try container.decode(Float?.self, forKey: .gain)
        availableCountries = try container.decode([String]?.self, forKey: .availableCountries)
        alternative = try container.decode(DeezerTrack?.self, forKey: .alternative)
        contributors = try container.decode([DeezerArtist]?.self, forKey: .contributors)
        try super.init(from: decoder)
    }
    
}


