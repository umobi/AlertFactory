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

internal class PresentAlertView: UIView {
    weak private var viewController: UIViewController?

    private var parent: UIViewController? {
        sequence(
            first: self as UIResponder,
            next: { $0.next }
        )
        .first(where: { $0 is UIViewController }) as? UIViewController
    }

    private var readyToCommitHandler: (() -> Void)? = nil

    override func didMoveToWindow() {
        super.didMoveToWindow()

        guard self.window != nil else {
            return
        }

        self.readyToCommitHandler?()
        self.readyToCommitHandler = nil
    }

    func present(_ viewController: UIViewController) {
        guard self.viewController == nil else {
            return
        }

        guard let parent = self.parent else {
            self.readyToCommitHandler = { [weak self] in
                self?.present(viewController)
            }

            return
        }

        parent.present(viewController, animated: true, completion: nil)

        self.viewController = viewController
    }

    func dismiss() {
        self.viewController?.dismiss(animated: true, completion: nil)
    }
}
#endif
