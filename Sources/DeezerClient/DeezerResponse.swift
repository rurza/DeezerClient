//
//  DeezerResponse.swift
//  Anesidora
//
//  Created by Adam Różyński on 20/10/2019.
//  Copyright © 2019 Adam Różyński. All rights reserved.
//

import Foundation

public class DeezerResponse<Resource: Codable>: Codable {
    public let data: [Resource]
    public let total: Int
    public let next: URL?
}
