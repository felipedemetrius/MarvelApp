//
//  View+Extension.swift
//  MarvelTargettvOS
//
//  Created by Felipe Demetrius Martins da Silva on 16/09/25.
//

import SwiftUI
import UIKit

extension View {
    public var viewController: UIViewController {
        UIHostingController(rootView: self)
    }
}
