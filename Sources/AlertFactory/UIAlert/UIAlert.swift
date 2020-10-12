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
import SwiftUI

#if os(iOS) || os(tvOS)
import UIKit

public struct UIAlert: RawAlert {
    typealias ButtonPayload = (String, UIAlertAction.Style, () -> Void)
    let title: String?
    let message: String?
    let style: UIAlertController.Style
    let buttons: [ButtonPayload]

    public init() {
        self.title = nil
        self.message = nil
        self.style = .alert
        self.buttons = []
    }

    private init(_ original: UIAlert, editable: Editable) {
        self.title = editable.title
        self.message = editable.message
        self.style = editable.style
        self.buttons = editable.buttons.unique().sorted()
    }

    private func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    private class Editable {
        var title: String?
        var message: String?
        var style: UIAlertController.Style
        var buttons: [(String, UIAlertAction.Style, () -> Void)]

        init(_ original: UIAlert) {
            self.title = original.title
            self.message = original.message
            self.style = original.style
            self.buttons = original.buttons
        }
    }

    public func render(_ isPresenting: Binding<Bool>) -> AnyView {
        AnyView(
            EmptyView()
                .background(
                    PresentAlert(
                        isPresenting: isPresenting.wrappedValue,
                        onDismiss: {
                            isPresenting.wrappedValue = false
                        },
                        content: {
                            AFAlertController.make(
                                title: self.title,
                                message: self.message,
                                style: self.style,
                                actions: self.buttons.map { title, style, action in
                                    (title, style, {
                                        action()
                                        isPresenting.wrappedValue = false
                                    })
                                }
                            )
                        }
                    )
                )
        )
    }
}

public extension UIAlert {
    func title(_ title: String) -> Self {
        self.edit {
            $0.title = title
        }
    }
}

public extension UIAlert {
    func message(_ message: String) -> Self {
        self.edit {
            $0.message = title
        }
    }
}

public extension UIAlert {
    func cancelButton(title: String, onTap: @escaping () -> Void) -> Self {
        self.edit {
            $0.buttons += [(
                title,
                .cancel,
                onTap
            )]
        }
    }

    func cancelButton(title: String) -> Self {
        self.edit {
            $0.buttons += [(
                title,
                .cancel,
                {}
            )]
        }
    }
}

public extension UIAlert {
    func destructiveButton(title: String, onTap: @escaping () -> Void) -> Self {
        self.edit {
            $0.buttons += [(
                title,
                .destructive,
                onTap
            )]
        }
    }
}

public extension UIAlert {
    func defaultButton(title: String, onTap: @escaping () -> Void) -> Self {
        self.edit {
            $0.buttons += [(
                title,
                .default,
                onTap
            )]
        }
    }
}

public extension UIAlert {
    func style(_ style: UIAlertController.Style) -> Self {
        self.edit {
            $0.style = style
        }
    }
}

extension Array where Element == UIAlert.ButtonPayload {
    func unique() -> [Element] {
        var buttons = [Element]()

        for slice in self.reversed() {
            switch slice.1 {
            case .cancel, .destructive:
                if buttons.contains(where: { $0.1 == slice.1 }) {
                    continue
                }

                buttons.append(slice)
            case .default:
                buttons.append(slice)
            @unknown default:
                buttons.append(slice)
            }
        }

        return buttons
    }

    func sorted() -> [Element] {
        var matrix: [[Element]] = [[], [], []]

        for slice in self.reversed() {
            switch slice.1 {
            case .cancel:
                matrix[0] += [slice]
            case .default:
                matrix[1] += [slice]
            case .destructive:
                matrix[2] += [slice]
            @unknown default:
                matrix[1] += [slice]
            }
        }

        return matrix[0] + matrix[1] + matrix[2]
    }
}

#endif

