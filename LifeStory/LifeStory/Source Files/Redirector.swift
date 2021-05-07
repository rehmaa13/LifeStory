//
//  Redirector.swift
//  LifeStory
//
//  Created by Adil Rehman on 18/04/2021.
//

import SwiftUI
import UIKit


struct VaultView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<VaultView>) -> UIViewController {
        UIStoryboard(name: "Vault", bundle: nil)
            .instantiateViewController(
              withIdentifier: "VaultViewController") as! UIViewController

    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<VaultView>) {
        
    }
}
