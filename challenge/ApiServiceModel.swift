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

struct Show_detail_response: Decodable {
    var id = 0
    var name = ""
    var created_by: [Creator] = [Creator]()
    var in_production: Bool = false
    var vote_average: Float = 0.0
    var seasons: [Season] = [Season]()
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

struct Creator: Codable, Identifiable {
    
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
}

struct Season: Codable, Identifiable{
    let id: Int
    let name: String
    let season_number: Int
}

struct Season_response: Decodable{
    var air_date: String = ""
    var episodes: [Episode] = [Episode]()
    var name: String = ""
}

struct Episode: Codable, Identifiable{
    let id: Int
    let name: String
    let still_path: String
}

class ApiServiceModel: ObservableObject{
    
    @Published var response = Show_list_response()
    @Published var response2 = Show_list_response()
    @Published var error_message: String?
    
    @Published var showinfo = Show_detail_response()
    @Published var seasoninfo = Season_response()
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
        //print("Iniciando Show request")
        
        publisher_request = api_request(with: with_url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                switch value{
                    
                    case .finished:
                        
                        let lastSeasonNumber = self!.showinfo.seasons.last?.season_number
                    
                        let seasonurl = URL(string: Constants.Api.showurl + "\(self!.showinfo.id)/" + "season/\(lastSeasonNumber!)" + "?api_key=\(Constants.Api.apikey)&language=en-US" )
                    
                        self!.get_season_data(with_url: seasonurl!)
                        break
                    case .failure(let error):
                        self?.error_message = error.localizedDescription
                }
            }, receiveValue: { [weak self] data in
                self?.showinfo = data
                
            })
        //print("Termina Show request")
        
    }
    
    func get_season_data(with_url: URL){
        
        print("Iniciando Season request")
        
        publisher_request = api_request(with: with_url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                switch value{
                    
                    case .finished:
                        let casturl = URL(string: Constants.Api.showurl + "\(self!.showinfo.id)/" + "credits?api_key=\(Constants.Api.apikey)&language=en-US" )
                    self!.get_cast_data(with_url: casturl!)
                        break
                    case .failure(let error):
                        self?.error_message = error.localizedDescription
                }
            }, receiveValue: { [weak self] data in
                self?.seasoninfo = data
                
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
            
            let arraySlice = self.response.results.suffix(4)
            
            return id == arraySlice.first?.id
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
