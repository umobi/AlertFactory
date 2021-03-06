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

@frozen
public struct UIAlert: RawAlert {
    @usableFromInline
    typealias ButtonPayload = (String, UIAlertAction.Style, () -> Void)

    @usableFromInline
    var title: String?
    
    @usableFromInline
    var message: String?

    @usableFromInline
    var style: UIAlertController.Style

    @usableFromInline
    var buttons: [ButtonPayload]

    public init() {
        self.title = nil
        self.message = nil
        self.style = .alert
        self.buttons = []
    }

    @inline(__always) @usableFromInline
    func edit(_ edit: (inout Self) -> Void) -> Self {
        var mutableSelf = self
        edit(&mutableSelf)
        return mutableSelf
    }

    @inlinable
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
    @inlinable
    func title(_ title: String?) -> Self {
        edit { $0.title = title }
    }
}

public extension UIAlert {
    @inlinable
    func message(_ message: String?) -> Self {
        edit { $0.message = message }
    }
}

public extension UIAlert {
    @inlinable
    func cancelButton(title: String, onTap: @escaping () -> Void) -> Self {
        self.edit {
            $0.buttons += [(
                title,
                .cancel,
                onTap
            )]
        }
    }

    @inlinable
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
    @inlinable
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
    @inlinable
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
    @inlinable
    func style(_ style: UIAlertController.Style) -> Self {
        edit { $0.style = style }
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

