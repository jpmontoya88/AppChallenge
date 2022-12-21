//
//  ApiModel.swift
//  challenge
//
//  Created by JP Montoya on 20.12.22.
//

import Foundation
import Combine

struct movie_list_response: Decodable, Identifiable{
    let id: Int
    let userId: Int
    let body: String
    let title: String
}

class ApiServiceModel: ObservableObject{
    @Published var response = [movie_list_response]()
    @Published var error_message: String?
    
    private var publisher_request: Cancellable? {
        didSet{ oldValue?.cancel() }
    }
    deinit {
        publisher_request?.cancel()
    }
    
    func get_data( with_url: URL ){
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
