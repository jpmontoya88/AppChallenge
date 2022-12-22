//
//  ApiModel.swift
//  challenge
//
//  Created by JP Montoya on 20.12.22.
//

import Foundation
import Combine

struct Show_list_response: Decodable {
    var page: Int = 0
    var results: [Show] = [Show]()
}

struct Cast_response: Decodable {
    var cast: [Cast] = [Cast]()
}

struct Show: Codable, Identifiable{
    
    let id: Int
    let title: String
    let vote: Float
    let sinopsis: String
    let releaseDate: String
    let image: String
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case vote = "vote_average"
        case sinopsis = "overview"
        case releaseDate = "first_air_date"
        case image = "poster_path"
        case posterPath = "backdrop_path"
    }
    
}

struct Cast: Codable, Identifiable{
    let id: Int
    let name: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image = "profile_path"
    }

}

struct Show_detail_response: Decodable{
    var created_by: [Creator]?
    var homepage: String?
    //var status: String = "name(s)"
    
    /*
    enum CodingKeys: String, CodingKey {
        case creators = "created_by"
    }
     */
}


struct Creator: Codable, Identifiable {
    
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
}


class ApiServiceModel: ObservableObject{
    
    @Published var response = Show_list_response()
    @Published var response2 = Show_list_response()
    @Published var error_message: String?
    
    @Published var showinfo = Show_detail_response()
    @Published var cast = Cast_response()
    
    private var publisher_request: Cancellable? {
        didSet{ oldValue?.cancel() }
    }
    deinit {
        publisher_request?.cancel()
    }
    
    func get_data( with_url: URL ){
        
        //print("Iniciando request")
        
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
    
    func get_show_data( with_url: URL){
        print("Iniciando Show request")
        
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
                
                self?.showinfo = data
                
            })
    }
    
    func get_cast_data( with_url: URL ){
        
        //print("Iniciando Cast request")
        
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
                self?.cast = data
                
            })
        
    }
    
    func shouldLoadNextPage(id: Int) -> Bool {
        if self.response.results.count > 0 {
            return id == self.response.results.last?.id
        }else{
            return false
        }
    }
    
    func get_next_page( with_url: URL ){
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
                self?.response2 = data
                
            })
        
        self.response.results.append(contentsOf: self.response2.results)
        self.response.page = self.response2.page
    }
    
}
