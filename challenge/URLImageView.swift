 //
//  URLImageView.swift
//  challenge
//
//  Created by JP Montoya on 20.12.22.
//

import SwiftUI

struct URLImageView: View {
    @ObservedObject var urlImageModel: URLImageModel
    
    init(urlString: String?) {
        urlImageModel = URLImageModel(urlString: urlString)
    }
    
    var body: some View {
        Image(uiImage: urlImageModel.image ?? URLImageView.placeholderImage!)
            .resizable()
            .scaledToFit()
            //.frame(width:50, height: 50)
    }
    
    static var placeholderImage = UIImage(named: "placeholder")
}

struct URLImageView_Previews: PreviewProvider {
    static var previews: some View {
        URLImageView(urlString: nil)
    }
}
