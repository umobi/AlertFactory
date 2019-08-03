//
//  AlertFactoryPayload.swift
//  AlertFactory
//
//  Created by brennobemoura on 02/08/19.
//  Copyright © 2019 AlertFactory. All rights reserved.
//

import Foundation

public final class AlertFactoryPayload {
    public var title: String?
    public var text: [(String, Int)] = []
    public var cancelButton: AlertFactoryButton?
    public var destructiveButton: AlertFactoryButton?
    public var otherButtons: [AlertFactoryButton] = []
    public var preferedStyle: UIAlertController.Style = .alert
    
    public var inputTitles: [AlertFactoryField] = []
    
    // MARK: TB Configuration
    public var image: UIImage?
}
