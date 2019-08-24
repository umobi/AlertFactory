//
//  AlertFactoryError.swift
//  AlertFactory
//
//  Created by brennobemoura on 02/08/19.
//  Copyright © 2019 AlertFactory. All rights reserved.
//

import Foundation

public protocol AlertFactoryErrorType {
    var error: Swift.Error { get }
    init(_ error: Swift.Error)
    
    associatedtype Title
    associatedtype Text
    
    var title: Title? { get }
    var text: Text? { get }
}

open class AlertFactoryError: AlertFactoryErrorType {
    public var title: String? {
        return nil
    }
    
    public var text: String? {
        return error.localizedDescription
    }
    
    public let error: Swift.Error
    
    required public init(_ error: Swift.Error) {
        self.error = error
    }
}
