//
//  DeezerAlbum.swift
//  DeezerClient
//
//  Created by Adam Różyński on 19/10/2019.
//  Copyright © 2019 Adam Różyński. All rights reserved.
//

import Foundation

public class DeezerAlbum: Codable {
    
    /// The Deezer album id
    public let id: Int
    
    /// The album title
    public let title: String
    
    /// The url of the album on Deezer
    public let link: URL?
    
    /// The url of the album's cover. Add 'size' parameter to the url to change size. Can be 'small', 'medium', 'big', 'xl'
    public let cover: URL
    
    /// The url of the album's cover in size small.
    public let smallCover: URL
    
    /// The url of the album's cover in size medium.
    public let mediumCover: URL
    
    /// The url of the album's cover in size big.
    public let bigCover: URL
    
    /// The url of the album's cover in size xl.
    public let xlCover: URL
    
    /// The album's release date
    public let releaseDate: Date?
    
    /// API Link to the tracklist of this album
    public let tracklist: URL?
    
    public let type: DeezerResourceType
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case link
        case cover
        case smallCover = "cover_small"
        case mediumCover = "cover_medium"
        case bigCover = "cover_big"
        case xlCover = "cover_xl"
        case releaseDate = "release_date"
        case tracklist
        case type
    }
    
}

public class DeezerExtendedAlbum: DeezerAlbum
{
    /// The album UPC
    public let upc: String
    
    /// The share link of the album on Deezer
    public let share: URL
    
    /// The album's first genre id (You should use the genre list instead). NB : -1 for not found
    public let genreId: Int
    
    /// List of genre object
    public let genres: [DeezerGenre]
    
    /// The album's label name
    public let label: String
    
    /// number of tracks in album
    public let numberOfTracks: UInt
    
    /// The album's duration (seconds)
    public let duration: TimeInterval
    
    /// The number of album's Fans
    public let fans: UInt
    
    /// The album's rate
    public let rating: Int
    
    /// The record type of the album (EP / ALBUM / etc..)
    public let recordType: String
    
    public let available: Bool
    
    /// Return an alternative album object if the current album is not availabl
    public let alternative: DeezerAlbum?

    
    /// Whether the album contains explicit lyrics
    public let containsExplicitLyrics: Bool
    
    /// The explicit content lyrics values (0:Not Explicit; 1:Explicit; 2:Unknown; 3:Edited; 4:Partially Explicit (Album "lyrics" only); 5:Partially Unknown (Album "lyrics" only); 6:No Advice Available; 7:Partially No Advice Available (Album "lyrics" only))
    public let explicitContentLyrics: ExplicitContent
    
    /// The explicit cover values (0:Not Explicit; 1:Explicit; 2:Unknown; 3:Edited; 4:Partially Explicit (Album "lyrics" only); 5:Partially Unknown (Album "lyrics" only); 6:No Advice Available; 7:Partially No Advice Available (Album "lyrics" only))
    public let explicitContentCover: ExplicitContent
    
    /// Return a list of contributors on the album
    public let contributors: [DeezerExtendedArtist]
    
    /// `DeezerArtist` object containing : id, name, picture, picture_small, picture_medium, picture_big, picture_xl
    public let artist: DeezerArtist
    
    /// list of `DeezerTrack`
    public let tracks: [DeezerTrack]
        
    public enum ExplicitContent: UInt, Codable {
         case notExplicit = 0
         case explicit = 1
         case unknown = 2
         case edited = 3
         case partiallyExplicit = 4
         case partiallyUnknown = 5
         case noAdviceAvailable = 6
         case partiallyNoAdviceAvailable = 7
     }
     
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        upc = try container.decode(String.self, forKey: .upc)
        share = try container.decode(URL.self, forKey: .share)
        genreId = try container.decode(Int.self, forKey: .genreId)
        genres = try container.decode([DeezerGenre].self, forKey: .genres)
        label = try container.decode(String.self, forKey: .label)
        numberOfTracks = try container.decode(UInt.self, forKey: .numberOfTracks)
        duration = try container.decode(TimeInterval.self, forKey: .duration)
        fans = try container.decode(UInt.self, forKey: .fans)
        rating = try container.decode(Int.self, forKey: .rating)
        recordType = try container.decode(String.self, forKey: .recordType)
        available = try container.decode(Bool.self, forKey: .available)
        alternative = try container.decode(DeezerAlbum?.self, forKey: .alternative)
        containsExplicitLyrics = try container.decode(Bool.self, forKey: .containsExplicitLyrics)
        explicitContentLyrics = try container.decode(ExplicitContent.self, forKey: .explicitContentLyrics)
        explicitContentCover = try container.decode(ExplicitContent.self, forKey: .explicitContentCover)
        contributors = try container.decode([DeezerExtendedArtist].self, forKey: .contributors)
        artist = try container.decode(DeezerArtist.self, forKey: .artist)
        tracks = try container.decode([DeezerTrack].self, forKey: .tracks)
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case upc
        case share
        case genreId = "genre_id"
        case genres
        case label
        case numberOfTracks = "nb_tracks"
        case duration
        case fans
        case rating
        case recordType = "record_type"
        case available
        case alternative
        case containsExplicitLyrics = "explicit_lyrics"
        case explicitContentLyrics = "explicit_content_lyrics"
        case explicitContentCover = "explicit_content_cover"
        case contributors
        case artist
        case tracks
    }
    
    
}
