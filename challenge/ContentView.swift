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
    
    @State private var filter = 0
    
    private let columns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "Gris")
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some View {
        
        NavigationView{
            
            ScrollView{
                
                Picker("What is your favorite color?", selection: $filter) {
                   Text("Popular").tag(0)
                   Text("Top Rated").tag(1)
                   Text("On TV").tag(2)
                   Text("Airing Today").tag(3)
               }
                .pickerStyle(.segmented)
                .foregroundColor(.white)
                .padding()
                .onChange(of: filter){ value in
                    switch value {
                        case 0:
                            self.apiModel.get_data(with_url: URL(string: Constants.Api.popularurl)!)
                        
                        case 1:
                            self.apiModel.get_data(with_url: URL(string: Constants.Api.topratedurl)!)
                        
                        case 2:
                            self.apiModel.get_data(with_url: URL(string: Constants.Api.ontvurl)!)
                        
                        case 3:
                        self.apiModel.get_data(with_url: URL(string: Constants.Api.airingurl)!)
                        
                        default:
                            self.apiModel.get_data(with_url: URL(string: Constants.Api.popularurl)!)
                    }
                }
                
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
               
                //CAMBIAR POR backdrop_path
               URLImageView(urlString: image)
                
                VStack(alignment: .leading){
                    
                    HStack{
                        
                        VStack(alignment: .leading){
                            Text("Summary")
                                .foregroundColor(Color("Verde"))
                            Text(title)
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                        
                        Spacer()
                        
                        ZStack{
                            Circle()
                                .foregroundColor(Color("Verde"))
                                .frame(width:50, height: 50)
                            
                            Text("5.5")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                            .padding()
                            .offset(y:-40)
                    }
                    
                    
                        .padding(.leading)
                        .padding(.top)
                    
                                        
                    Text(txt_string)
                        .padding()
                        .foregroundColor(.white)
                        .font(.caption)
                    
                    HStack{
                        Text("Created by: \(apiModel.showinfo.status)")
                       /* ForEach(apiModel.showinfo.created_by){ creator in
                            
                            Text(creator.name)
                        }
                        */
                        
                        
                    }
                        .foregroundColor(.white)
                        .padding(.leading)
                        .font(.caption)
                    
                    Text("Cast")
                        .foregroundColor(Color("Verde"))
                        .padding(.leading)
                        .padding(.top)
                    
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
                    
                    let showurl = URL(string: Constants.Api.showurl + "\(showId)" + "?api_key=\(Constants.Api.apikey)&language=en-US")
                    
                    self.apiModel.get_show_data(with_url: showurl!)
                    
                    let casturl = URL(string: Constants.Api.showurl + "\(showId)/" + "credits?api_key=\(Constants.Api.apikey)&language=en-US" )
                    
                    self.apiModel.get_cast_data(with_url: casturl!)
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
        //print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
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
