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

public protocol AlertFactoryPayloadType {
    associatedtype Title
    associatedtype Text
    
    var title: Title? { get set }
    var text: Text? { get set }
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
