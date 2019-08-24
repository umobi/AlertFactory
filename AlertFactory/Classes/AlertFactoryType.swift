//
//  AlertFactoryType.swift
//  AlertFactory
//
//  Created by brennobemoura on 02/08/19.
//  Copyright © 2019 AlertFactory. All rights reserved.
//

import Foundation
import UIKit

public protocol AlertFactoryType {
    associatedtype Title
    associatedtype Text
    
    func with(title: Title) -> Self
    func with(text: Text) -> Self
    func with(image: UIImage) -> Self
    func with(preferredStyle: UIAlertController.Style) -> Self
    
    func append(textField: AlertFactoryField) -> Self
    func append(button: AlertFactoryButton) -> Self
    
    func didConfiguredAlertView()
}

public extension AlertFactoryType {
    func with(image: UIImage) -> Self { return self }
    func append(textField: AlertFactoryField) -> Self { return self }
    
    func with(preferredStyle: UIAlertController.Style) -> Self { return self }
    
    func didConfiguredAlertView() {}
}
