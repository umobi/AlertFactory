//
//  AlertFactory+UIAlertController.swift
//  AlertFactory
//
//  Created by brennobemoura on 02/08/19.
//  Copyright © 2019 AlertFactory. All rights reserved.
//

import Foundation

extension UIAlertController: AlertFactoryType {    
    
    public func with(title: String) -> Self {
        return .init(title: title, message: self.message, preferredStyle: self.preferredStyle)
    }
    
    public func with(text: String) -> Self {
        return .init(title: self.title, message: (self.message ?? "") + text, preferredStyle: self.preferredStyle)
    }
    
    public func with(preferredStyle: UIAlertController.Style) -> Self {
        return .init(title: self.title, message: self.message, preferredStyle: preferredStyle)
    }
    
    public func append(textField: AlertFactoryField) -> Self {
        self.addTextField(configurationHandler: {
            textField.onTextField($0)
        })
        
        return self
    }
    
    public func append(button: AlertFactoryButton) -> Self {
        let action = UIAlertAction(title: button.title, style: button.style, handler: { _ in
            button.onTap?()
        })
        
        self.addAction(action)
        
        if button.isPreferred {
            if #available(iOS 9.0, *) {
                self.preferredAction = action
            }
        }
        
        return self
    }
}
