//
//  apiResults.swift
//  lab4
//
//  Created by Brad Hodkinson on 10/16/18.
//  Copyright © 2018 Brad Hodkinson. All rights reserved.
//

import Foundation


struct APIResults:Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}
