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
    
    private let columns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    var body: some View {
        
        NavigationView{
            
            ScrollView{
                
                LazyVGrid(columns: columns, spacing: 20){
                    ForEach(apiModel.response.results){ show in
                        
                        NavigationLink(destination: Detail_view(txt_string: show.sinopsis, title: show.title, showId: show.id, image: show.image)){
                            
                            VStack(alignment: .leading){
                                URLImageView(urlString: show.image)
                                Text("\(show.title)")
                                    .font(.caption)
                                HStack{
                                    Text(Date.getFormattedDate(string: show.releaseDate))
                                        .font(.caption)
                                    Spacer()
                                    Image(systemName: "star.fill")
                                        .font(.caption)
                                        .padding(0)
                                    Text("\(show.vote, specifier: "%.1f")")
                                        .font(.caption)
                                }
                                
                                Text("\(show.sinopsis)")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .lineLimit(4)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            .foregroundColor(Color("Verde"))
                                                        
                        }
                        .padding(10)
                        .background(Color("Gris"))
                        .cornerRadius(15)
                        
                    }
                }
                .padding(2)
                
            }//ScrollView
            .background(Color.black)
            .onAppear{
                self.apiModel.get_data(with_url: URL(string: Constants.Api.popularurl)!)
            }
            .navigationTitle("TV Shows")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(backgroundColor: UIColor(named: "Gris"), titleColor: .white)
        }//NavView
    }
}

struct Detail_view: View{
    
    var txt_string: String
    var title: String
    var showId: Int
    var image: String
    @ObservedObject var apiModel = ApiServiceModel()
    
    var body: some View{
        
        ScrollView{
            ZStack{
               
                URLImageView(urlString: "\(image)")
                
                VStack(alignment: .leading){
                    
                    Text("Summary")
                        .foregroundColor(Color("Verde"))
                        .padding(.leading)
                        .padding(.top)
                    
                    Text(title)
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading)
                    
                    Text(txt_string)
                        .padding()
                        .foregroundColor(.white)
                        .font(.caption)
                    
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
                    
                }//VStack
                .background(Color("Gris"))
                .padding(10)
                .cornerRadius(15)
                .offset(y:90)
                
                .onAppear{
                    
                    let url = URL(string: Constants.Api.casturl + "\(showId)/" + "credits?api_key=91b79e1c018c1a145c60282db74f86e7&language=en-US" )
                    
                    apiModel.get_cast_data(with_url: url!)
                }//OnAppear
                
            }//ZStack
        }
            .ignoresSafeArea()
            .background(Color.black)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Date {
    static func getFormattedDate(string: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        let date: Date? = dateFormatterGet.date(from: string)
        print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        return dateFormatterPrint.string(from: date!);
    }
}

struct NavigationBarModifier: ViewModifier {

    var backgroundColor: UIColor?
    var titleColor: UIColor?

    init(backgroundColor: UIColor?, titleColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .white]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }

    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {

    func navigationBarColor(backgroundColor: UIColor?, titleColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, titleColor: titleColor))
    }

}
