//
//  movie.swift
//  lab4
//
//  Created by Brad Hodkinson on 10/16/18.
//  Copyright © 2018 Brad Hodkinson. All rights reserved.
//

import Foundation


struct Movie: Codable {
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String
    let vote_average: Double
    let overview: String
    let vote_count:Int!
}

