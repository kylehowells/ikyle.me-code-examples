//
//  SwiftUIView.swift
//  ObjC Live Preview
//
//  Created by Kyle Howells on 01/07/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

import SwiftUI

struct VCRepresentable<VCClass:UIViewController>: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // leave this empty
    }
    
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController {
        return VCClass()
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
       VCRepresentable<ViewController>()
    }
}
