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

#if os(iOS) || os(tvOS)
import UIKit

internal class AFAlertController: UIAlertController {
    var dismissedHandler: (() -> Void)? = nil

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isBeingDismissed {
            self.dismissedHandler?()
        }
    }
}

extension AFAlertController {
    static func make(title: String?,
                     message: String?,
                     style: UIAlertController.Style,
                     actions: [(String, UIAlertAction.Style, () -> Void)]) -> AFAlertController {

        let alertController = AFAlertController(title: title, message: message, preferredStyle: style)

        actions.forEach { title, style, onTap in
            alertController.addAction(.init(
                title: title,
                style: style,
                handler: { _ in onTap() }
            ))
        }

        return alertController
    }
}
#endif
