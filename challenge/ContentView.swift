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
    @State var presentUIView = false
    
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
                
                Button("Show me a UIView") {
                    presentUIView = true
                }
                .sheet(isPresented: $presentUIView) {
                    theUIViewRepresentable(showSheet: $presentUIView)
                }
                .padding(.top)
                .foregroundColor(.white)
                
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
                            self.apiModel.get_data(with_url: URL(string: Constants.Api.popularurl + "\(1)")!)
                        
                        case 1:
                            self.apiModel.get_data(with_url: URL(string: Constants.Api.topratedurl + "\(1)")!)
                        
                        case 2:
                            self.apiModel.get_data(with_url: URL(string: Constants.Api.ontvurl + "\(1)")!)
                        
                        case 3:
                        self.apiModel.get_data(with_url: URL(string: Constants.Api.airingurl + "\(1)")!)
                        
                        default:
                            self.apiModel.get_data(with_url: URL(string: Constants.Api.popularurl + "\(1)")!)
                    }
                }
                
                LazyVGrid(columns: columns, spacing: 20){
                    ForEach(apiModel.response.results){ show in
                        
                        NavigationLink(destination: Detail_view(txt_string: show.sinopsis, title: show.title, showId: show.id, image: show.posterPath ?? show.image) ) {
                            
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
                            .onAppear{
                                if apiModel.shouldLoadNextPage(id: show.id) {
                                    
                                    switch filter{
                                        case 0:
                                            let page = apiModel.response.page + 1
                                            apiModel.get_next_page(with_url: URL(string: Constants.Api.popularurl + "\(page)")!)
                                        
                                        case 1:
                                            let page = apiModel.response.page + 1
                                            apiModel.get_next_page(with_url: URL(string: Constants.Api.topratedurl + "\(page)")!)
                                        
                                        case 2:
                                            let page = apiModel.response.page + 1
                                            apiModel.get_next_page(with_url: URL(string: Constants.Api.ontvurl + "\(page)")!)
                                        
                                        case 3:
                                            let page = apiModel.response.page + 1
                                            apiModel.get_next_page(with_url: URL(string: Constants.Api.ontvurl + "\(page)")!)
                                        
                                        default:
                                            let page = apiModel.response.page + 1
                                        apiModel.get_next_page(with_url: URL(string: Constants.Api.airingurl + "\(page)")!)
                                    }
                                    
                                    
                                }
                            }
                                                        
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
                    self.filter = 0
                    self.apiModel.get_data(with_url: URL(string: Constants.Api.popularurl + "\(1)")!)
                }
                .navigationTitle("TV Shows")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarColor(backgroundColor: UIColor(named: "Gris"), titleColor: .white)
        }//NavView
            .accentColor(.white)
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

struct theUIViewRepresentable: UIViewRepresentable {
    typealias UIViewType = theUIView
    @Binding var showSheet: Bool
    
    func makeUIView(context: Context) -> theUIView {
        let view = theUIView()
        return view
    }
    
    func updateUIView(_ uiView: theUIView, context: Context) {
       
    }
    
}

class theUIView: UIView {
    
    private var label: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is a UIView"
        label.textAlignment = .center
        label.textColor = UIColor(.white)
        
        return label
    }()
    
    private var boton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRectMake(100, 100, 100, 50)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("This button does nothing", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    
    var hide: Bool = false
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = UIColor(named: "Gris")
        
        addSubview(label)
        
        addSubview(boton)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            boton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            boton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            boton.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            boton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),

        ])
        
       
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
     }
}
