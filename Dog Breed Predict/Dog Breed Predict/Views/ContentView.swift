//
//  ContentView.swift
//  Dog Breed Predict
//
//  Created by Pedro Lopes on 19/04/20.
//  Copyright © 2020 Pedro Lopes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showAlertSheet : Bool = false
    @State private var showImagePicker : Bool = false
    @State private var image : UIImage? = nil
    @State private var sourceType : UIImagePickerController.SourceType = .photoLibrary
        
    var body: some View {
       MainView()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
