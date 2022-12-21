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
                    ForEach(apiModel.response.results){ movie in
                        
                        NavigationLink(destination: Detail_view(txt_string: movie.sinopsis)){
                            
                            VStack(alignment: .leading){
                                URLImageView(urlString: movie.image)
                                Text("\(movie.title)")
                                    .font(.caption)
                                HStack{
                                    Text(Date.getFormattedDate(string: movie.releaseDate))
                                        .font(.caption)
                                    Spacer()
                                    Image(systemName: "star.fill")
                                    Text("\(movie.vote, specifier: "%.1f")")
                                        .font(.caption)
                                }
                            }
                            .foregroundColor(Color("Verde"))
                                                        
                        }
                        
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
