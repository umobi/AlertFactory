//
//  AlertFactory.swift
//  AlertFactory
//
//  Created by brennobemoura on 02/08/19.
//  Copyright © 2019 AlertFactory. All rights reserved.
//

import Foundation
import UIKit

open class AlertFactory<T: UIViewController & AlertFactoryType> {
    public typealias Title = T.Title
    public typealias Text = T.Text
    
    private weak var mainView: UIViewController?
    private var alertView: T?
    
    private var payload = AlertFactoryPayload<Title, Text>()
    
    open var defaultCancelTitle: String {
        return "Cancel"
    }
    
    open var defaultForceCancelTitle: String {
        return "Ok"
    }
    
    public init() {}
    public init(viewController: UIViewController?) {
        self.mainView = viewController
    }
    
    public final func append() {}
    
    public final func with(title: Title) -> Self {
        self.payload.title = title
        return self
    }
    
    public final func cancelButton(title: String?=nil, onTap: (() -> Void)? = nil) -> Self {
        guard let title = title else {
            self.payload.cancelButton = AlertFactoryButton.cancel(title: self.defaultCancelTitle).copy(onTap: onTap)
            return self
        }
        
        self.payload.cancelButton = AlertFactoryButton(title: title, style: .cancel, onTap: onTap)
        return self
    }
    
    public final func with(text: Text) -> Self {
        self.payload.text = text
        return self
    }
    
    public final func append<E>(text: E) -> Self where Text == Array<E> {
        self.payload.text = (self.payload.text ?? []) + [text]
        return self
    }
    
    public final func destructiveButton(title: String, onTap: (() -> Void)? = nil) -> Self {
        self.payload.destructiveButton = AlertFactoryButton(title: title, style: .destructive, onTap: onTap)
        return self
    }
    
    public final func preferredButton(title: String, onTap: (() -> Void)? = nil) -> Self {
        self.payload.destructiveButton = AlertFactoryButton(title: title, style: .default, onTap: onTap, isPreferred: true)
        return self
    }
    
    open func forError<Error: AlertFactoryErrorType>(_ error: Error) -> Self {
        if let title = error.title as? T.Title {
            self.with(title: title)
                .append()
        }
        
        if let message = error.text as? T.Text {
            self.with(text: message)
                .append()
        }
        
        return self.forceCancel(title: self.defaultForceCancelTitle)
    }
    
    public final func otherButton(title: String, onTap: (() -> Void)?=nil) -> Self {
        self.payload.otherButtons.append(.init(title: title, style: .default, onTap: onTap))
        return self
    }
    
    private func forceCancel(title: String? = nil, onTap: (() -> Void)? = nil) -> Self {
        if self.payload.cancelButton?.title == nil && self.payload.destructiveButton?.title == nil {
            return self.cancelButton(title: title, onTap: onTap)
        }
        
        return self
    }
    
    public final func with(preferredStyle: UIAlertController.Style) -> Self {
        self.payload.preferedStyle = preferredStyle
        return self
    }
    
    public final func with(image: UIImage) -> Self {
        self.payload.image = image
        return self
    }
    
    public final func inputField(onTextField: @escaping (UITextField) -> Void) -> Self {
        self.payload.inputTitles.append(.init(onTextField: onTextField))
        return self
    }
    
    public final var hasButton: Bool {
        if self.payload.otherButtons.count > 0 {
            return true
        }
        
        if self.payload.cancelButton != nil {
            return true
        }
        
        if self.payload.destructiveButton != nil {
            return true
        }
        
        return false
    }
    
    public final func onDismiss(_ completion: (() -> Void)?) -> Self {
        guard let completion = completion else {
            return self
        }
        
        if let cancel = self.payload.cancelButton {
            self.payload.cancelButton = cancel.copy(onTap: completion)
        }
        
        if let destructiveButton = self.payload.destructiveButton {
            self.payload.destructiveButton = destructiveButton.copy(onTap: completion)
        }
        
        self.payload.otherButtons = self.payload.otherButtons.compactMap {
            $0.copy(onTap: completion)
        }
        
        return self
    }
    
    private func present(at vc: UIViewController, completion: ((Bool) -> Void)? = nil) {
        guard let alertView = self.alertView else {
            completion?(false)
            return
        }
        
        if let presented = vc.presentedViewController {
            print("ViewController is presenting \(presented.description)")
        }
        
        vc.present(alertView, animated: true, completion: {
            completion?(true)
        })
    }
    
    public final func present(completion: ((Bool) -> Void)? = nil) {
        guard let mainView = self.mainView ?? self.presentationViewController() else {
            completion?(false)
            return
        }
        
        guard let alertView = self.asAlertView() else {
            completion?(false)
            return
        }
        
        self.alertView = alertView
        
        if let navigationController = mainView.navigationController {
            self.present(at: navigationController, completion: completion)
            return
        }
        
        self.present(at: mainView, completion: completion)
    }
    
    private var layoutHandler: ((T) -> Void)? = nil
    final public func applyLayout(_ handler: @escaping (T) -> Void) -> Self {
        self.layoutHandler = handler
        return self
    }
    
    private func applyBasic() -> T {
        var viewController = T()
        
        if let title = payload.title {
            viewController = viewController.with(title: title)
        }
        
        if let text = payload.text {
            viewController = viewController.with(text: text)
        }
        
        viewController = viewController.with(preferredStyle: payload.preferedStyle)
        
        if let image = payload.image {
            viewController = viewController.with(image: image)
        }
        
        self.layoutHandler?(viewController)
        return viewController
    }
    
    public final func asAlertView() -> T? {
        let view = self.applyBasic()
        
        var viewController = AlertFactory.allFields(in: view, self.payload.inputTitles) ?? view
        
        if !self.hasButton {
            viewController = viewController.append(button: AlertFactoryButton.cancel(title: self.defaultCancelTitle))
        } else {
            if let cancelButton = self.payload.cancelButton {
                viewController = viewController.append(button: cancelButton)
            }
            
            if let destructiveButton = self.payload.destructiveButton {
                viewController = viewController.append(button: destructiveButton)
            }
            
            payload.otherButtons.forEach {
                viewController = viewController.append(button: $0)
            }
        }
        
        viewController.didConfiguredAlertView()
        return viewController
    }
    
    private static func allFields(in alertView: T, _ fields: [AlertFactoryField]) -> T? {
        var fields = fields
        var alertView = alertView
        
        if fields.isEmpty {
            return nil
        }
        
        let field = fields.removeFirst()
        alertView = alertView.append(textField: field)
        
        let next = self.allFields(in: alertView, fields)
        
        return next == nil ? alertView : next
    }
    
    open func presentationViewController() -> UIViewController? {
        return nil
    }
}
