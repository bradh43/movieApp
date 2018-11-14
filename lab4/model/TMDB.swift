//
//  DMDB.swift
//  lab4
//
//  Created by Brad Hodkinson on 10/21/18.
//  Copyright © 2018 Brad Hodkinson. All rights reserved.
//
// Data for movie info was found from TMDB website using there API
// https://www.themoviedb.org/
//

import Foundation


class TMDB {
    var apiResults: APIResults?
    
    init() {
        apiResults = nil
    }

    func getSearchResults(searchText: String) {
        
        if(searchText != ""){
            let searchString = formatSearchString(searchText: searchText)
            let apiKey = "41f35783cee862ac5b7aefdac89fcfff"
            let jsonRequest = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchString)"
            apiCall(urlRequest: jsonRequest)
        }
        return
   
    }
    
    func apiCall(urlRequest: String) {
        guard let url = URL(string: urlRequest) else {
            print("Error in creating URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                print(error!)
                return
            }
            guard let movieJson = data else {
                print("Error getting data")
                return
            }
   
            guard let movieData = try?
                JSONDecoder().decode(APIResults?.self, from: Data(movieJson))
                else {
                    print("Error decoding json data")
                    return
                }
            
            self.apiResults = movieData
        }
        task.resume()
    }
    
    func formatSearchString(searchText: String) -> String {
        let reformattedText = searchText.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        return reformattedText
    }
    
    func getImagePath(path: String) -> String {
        return "https://image.tmdb.org/t/p/w200/\(path)"
    }
    
}
