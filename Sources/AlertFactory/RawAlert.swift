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

import SwiftUI

public protocol RawAlert {
    func render(_ isPresenting: Binding<Bool>) -> AnyView
}

public extension RawAlert {
    @inline(__always) @inlinable
    func present(_ render: AlertRender<Self>) {
        render.payload += [self]
    }

    @inlinable
    func present() {
        guard let render = AlertManager.shared.render(Self.self) else {
            print("[Warning] couldn't restore AlertFactory<\(Self.self)> on AlertManager")
            return
        }

        render.payload += [self]
    }

    @inlinable
    static func shared() -> AlertRender<Self> {
        if let render = AlertManager.shared.render(Self.self) {
            return render
        }
        
        let render = AlertRender<Self>()
        AlertManager.shared.store(render)
        return render
    }
}
