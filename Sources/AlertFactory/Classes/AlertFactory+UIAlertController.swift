//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation
import UIKit

extension UIAlertController: AlertFactoryType {    
    
    public func with(title: String) -> Self {
        return .init(title: title, message: self.message, preferredStyle: self.preferredStyle)
    }
    
    public func with(text: String) -> Self {
        return .init(title: self.title, message: text, preferredStyle: self.preferredStyle)
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
