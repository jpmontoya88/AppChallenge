//
//  Constants.swift
//  challenge
//
//  Created by JP Montoya on 20.12.22.
//

import Foundation


struct Constants {
    
    struct Api {
        static let popularurl = String("https://api.themoviedb.org/3/tv/popular?api_key=91b79e1c018c1a145c60282db74f86e7&language=en-US&page=1")
        static let apikey = String("91b79e1c018c1a145c60282db74f86e7")
        static let apireadaccesstoken = String("eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MWI3OWUxYzAxOGMxYTE0NWM2MDI4MmRiNzRmODZlNyIsInN1YiI6IjYzYTI0Y2ZkOGRkYzM0MTRlOWMwYWVhOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lmOcM06T3LVEkYR7T7OTufK3EaxjBYMOlKJf5zyUwzA")
        static let imagebaseurl = String("https://image.tmdb.org/t/p/w500")
    }
    
}
