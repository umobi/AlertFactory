//
//  AlertFactoryPayload.swift
//  AlertFactory
//
//  Created by brennobemoura on 02/08/19.
//  Copyright © 2019 AlertFactory. All rights reserved.
//

import Foundation

public protocol AlertFactoryPayloadType {
    associatedtype TitleType
    associatedtype TextType
    
    var title: TitleType? { get set }
    var text: TextType { get set }
    var cancelButton: AlertFactoryButton? { get set }
    var destructiveButton: AlertFactoryButton? { get set }
    var otherButtons: [AlertFactoryButton] { get set }
    var preferedStyle: UIAlertController.Style { get set }
    
    var inputTitles: [AlertFactoryField] { get set }
    
    // MARK: TB Configuration
    var image: UIImage? { get set }
}

public final class AlertFactoryPayload<Title, Text>: AlertFactoryPayloadType {
    public var title: Title? = nil
    public var text: Text? = nil
    public var cancelButton: AlertFactoryButton?
    public var destructiveButton: AlertFactoryButton?
    public var otherButtons: [AlertFactoryButton] = []
    public var preferedStyle: UIAlertController.Style = .alert
    
    public var inputTitles: [AlertFactoryField] = []
    
    // MARK: TB Configuration
    public var image: UIImage?
}
