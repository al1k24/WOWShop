//
//  UIViewController+Preview.swift
//  WOWShop
//
//  Created by Alik on 03.04.2021.
//

#if DEBUG
import SwiftUI

@available(iOS 13, *)
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIViewController {
            let controller = viewController
            return UINavigationController(rootViewController: controller)
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<Self>) {}
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif
