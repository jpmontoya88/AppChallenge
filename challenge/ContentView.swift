//
//  ContentView.swift
//  challenge
//
//  Created by JP Montoya on 20.12.22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var apiModel = ApiServiceModel()
    
    var body: some View {
        NavigationView{
            VStack{
                List(apiModel.response){ user in
                    NavigationLink(destination: Detail_view(txt_string: user.title)){
                        Text("\(user.id)")
                        
                    }
                }
            }
            .onAppear{
                self.apiModel.get_data(with_url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
            }
        }
        .navigationBarTitle("MOVIES")
    }
}

struct Detail_view: View{
    
    var txt_string: String
    
    var body: some View{
        VStack{
            Text(txt_string)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
