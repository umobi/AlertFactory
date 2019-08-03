//
//  AlertFactoryError.swift
//  AlertFactory
//
//  Created by brennobemoura on 02/08/19.
//  Copyright © 2019 AlertFactory. All rights reserved.
//

import Foundation

open class AlertFactoryError {
    open var title: String? {
        return nil
    }
    
    open var message: String? {
        return error.localizedDescription
    }
    
    public let error: Swift.Error
    
    public init(_ error: Swift.Error) {
        self.error = error
    }
}
