//
//  ContentView.swift
//  challenge
//
//  Created by JP Montoya on 20.12.22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var apiModel = ApiServiceModel()
    @State var listLoaded: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                
                Text("PAGE: \(apiModel.response.page)")
                
                List(apiModel.response.results){ movie in
                    NavigationLink(destination: Detail_view(txt_string: movie.sinopsis)){
                        HStack{
                            URLImageView(urlString: movie.image)
                            Text("\(movie.title)")
                        }
                        
                        
                    }
                }
                
            }
            .onAppear{
                self.apiModel.get_data(with_url: URL(string: Constants.Api.popularurl)!)
            }
            .navigationTitle("MOVIES")
            .navigationBarTitleDisplayMode(.inline)
        }
        

    }
}

struct Detail_view: View{
    
    var txt_string: String
    
    var body: some View{
        VStack{
            Text(txt_string)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
