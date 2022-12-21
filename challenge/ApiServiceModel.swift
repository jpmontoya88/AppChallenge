//
//  ApiModel.swift
//  challenge
//
//  Created by JP Montoya on 20.12.22.
//

import Foundation
import Combine

struct movie_list_response: Decodable {
    var page: Int = 0
    var results: [Movie] = [Movie]()
}

struct Movie: Codable, Identifiable{
    
    let id: Int
    let title: String
    let popularity: Double
    let sinopsis: String
    let releaseDate: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case popularity
        case sinopsis = "overview"
        case releaseDate = "release_date"
        case image = "poster_path"
    }
    
}

class ApiServiceModel: ObservableObject{
    
    @Published var response = movie_list_response()
    @Published var error_message: String?
    
    private var publisher_request: Cancellable? {
        didSet{ oldValue?.cancel() }
    }
    deinit {
        publisher_request?.cancel()
    }
    
    func get_data( with_url: URL ){
        
        print("Iniciando request")
        
        publisher_request = api_request(with: with_url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                switch value{
                    
                case .finished:
                    break
                case .failure(let error):
                    self?.error_message = error.localizedDescription
                }
            }, receiveValue: { [weak self] data in
                self?.response = data
                
            })
        
    }
    
}
