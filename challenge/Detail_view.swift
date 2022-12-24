//
//  Detail_view.swift
//  challenge
//
//  Created by Melo Montoya on 23/12/22.
//

import SwiftUI

struct Detail_view: View{
    
    var txt_string: String
    var title: String
    var showId: Int
    var image: String
    @ObservedObject var apiModel = ApiServiceModel()
    
    var body: some View{
        
        
            
        ZStack{
           
           URLImageView(urlString: image)
                .offset(y:-200)
            
        
            ScrollView{
                
                VStack(alignment: .leading){
                    
                    HStack{
                        
                        VStack(alignment: .leading){
                            Text("Summary")
                                .foregroundColor(Color("Verde"))
                            Text(title)
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                        }
                        
                        Spacer()
                        
                        ZStack{
                            Circle()
                                .foregroundColor(Color("Verde"))
                                .frame(width:50, height: 50)
                            
                            Text("\(apiModel.showinfo.vote_average, specifier: "%.1f")")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                            .padding()
                            .offset(y:-15)
                        
                    }//HSTACK
                        .padding(.leading)
                        .padding(.top)
                    
                                        
                    Text(txt_string)
                        .padding()
                        .foregroundColor(.white)
                        .font(.caption)
                    
                    
                    HStack{
                        
                        if let creators = apiModel.showinfo.created_by, apiModel.showinfo.created_by.count > 0{
                            Text("Created by: ")
                            
                            ForEach(creators){ creator in
                                
                                if (creator.name != apiModel.showinfo.created_by.last?.name){
                                    Text(creator.name + ",")
                                        .bold()
                                        .padding(0)
                
                                }else{
                                    Text(creator.name)
                                        .bold()
                                        .padding(0)
                                }
                                
                                 
                             }
                            
                        }
                        
                    }
                        .foregroundColor(.white)
                        .padding(.leading)
                        .font(.caption)
                    
                    if apiModel.showinfo.seasons.count > 0{
                        
                        if apiModel.showinfo.in_production, apiModel.seasoninfo.name != ""{
                            Text("Current Season:")
                                .font(.subheadline)
                                .foregroundColor(Color("Verde"))
                                .padding(.leading)
                                .padding(.top)
                        }else if apiModel.seasoninfo.name != "" {
                            Text("Last Season:")
                                .font(.subheadline)
                                .foregroundColor(Color("Verde"))
                                .padding(.leading)
                                .padding(.top)
                        }
                        
                        Text(apiModel.seasoninfo.name)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.leading)
                        
                        if apiModel.seasoninfo.air_date != ""{
                            Text(Date.getFormattedDate(string:apiModel.seasoninfo.air_date))
                                .font(.caption2)
                                .foregroundColor(Color("Verde"))
                                .padding(.leading)
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(){
                                
                                ForEach(apiModel.seasoninfo.episodes){
                                    episode in
                                    
                                    VStack{
                                        URLImageView(urlString: "\(episode.still_path)")
                                            .frame(width: 150)
                                            .padding(0)
                                        
                                        Text(episode.name)
                                            .font(.caption)
                                            //.offset(y:-25)
                                            .foregroundColor(.white)
                                    }
                                        .padding(5)
                                }
                                
                            }//HStack
                                
                            
                        }//Scroll
                        
                    }// IF SEASONS
                    
                    if apiModel.cast.cast.count > 0{
                        
                        Text("Cast")
                            .foregroundColor(Color("Verde"))
                            .padding(.leading)
                            //.padding(.top)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(){
                                
                                ForEach(apiModel.cast.cast){ castmember in
                                    VStack(spacing: 0){
                                        
                                        URLImageView(urlString: "\(castmember.image)")
                                            .mask(Circle())
                                            .frame(width: 180, height: 180)
                                            .padding(0)
                                        
                                        Text(castmember.name)
                                            .font(.caption)
                                            .offset(y:-25)
                                            .foregroundColor(.white)
                                        
                                    }//VStack
                                    .frame(width:130, height: 150)
                                    
                                }//ForEach
                                
                            }//HStack
                            .padding(.bottom)
                            
                        }//ScrollView
                        
                    }//IF
                    
                    
                    
                }//VStack
                    .background(Color("Gris"))
                    .cornerRadius(15)
                    .padding(10)
                    .padding(.bottom, 200)
                    .offset(y:120)
                    .onAppear{
                    
                        let showurl = URL(string: Constants.Api.showurl + "\(showId)" + "?api_key=\(Constants.Api.apikey)&language=en-US")
                                        
                        self.apiModel.get_show_data(with_url: showurl!)
                    
                    }//OnAppear
                
               
                
            }//Scroll

        }//ZStack
        
       // .ignoresSafeArea()
        .background(Color.black)
            
        
    }
}

struct Detail_view_Previews: PreviewProvider {
    static var previews: some View {
        Detail_view(txt_string: "", title: "", showId: 0, image: "")
    }
}
