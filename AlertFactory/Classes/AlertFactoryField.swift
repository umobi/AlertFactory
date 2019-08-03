//
//  AlertFactoryField.swift
//  AlertFactory
//
//  Created by brennobemoura on 02/08/19.
//  Copyright © 2019 AlertFactory. All rights reserved.
//

import Foundation
import UIKit

final public class AlertFactoryField {
    public let onTextField: (UITextField) -> Void
    
    public init(onTextField: @escaping (UITextField) -> Void) {
        self.onTextField = onTextField
    }
}
