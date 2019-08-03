//
//  AlertFactoryButton.swift
//  AlertFactory
//
//  Created by brennobemoura on 02/08/19.
//  Copyright © 2019 AlertFactory. All rights reserved.
//

import Foundation

public final class AlertFactoryButton {
    public let title: String
    public let style: UIAlertAction.Style
    public let onTap: (() -> Void)?
    public let isPreferred: Bool
    
    public init(title: String, style: UIAlertAction.Style, onTap: (() -> Void)?, isPreferred: Bool = false) {
        self.title = title
        self.style = style
        self.onTap = onTap
        self.isPreferred = isPreferred
    }
    
    public func copy(onTap: (() -> Void)?) -> AlertFactoryButton {
        let oldTap = self.onTap
        return .init(title: self.title, style: self.style, onTap: {
            oldTap?()
            onTap?()
        })
    }
    
    public static func cancel(title: String) -> AlertFactoryButton {
        return .init(title: title, style: .cancel, onTap: nil)
    }
}
