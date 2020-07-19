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

private struct AlertView<Payload, Content>: View where Payload: RawAlert, Content: View {
    let content: () -> Content
    @ObservedObject var state: AlertRender<Payload>

    @State var isPresenting: Bool = false
    @State var payload: Payload?

    init(_ state: AlertRender<Payload>,_ content: @escaping () -> Content) {
        self.state = state
        self.content = content
    }

    func lock() {
        if let payload = self.state.payload.first {
            if !self.isPresenting {
                let payload = payload

                OperationQueue.main.addOperation {
                    self.isPresenting = true
                    self.payload = payload
                }

                self.state.payload.removeFirst()
            }
        }
    }

    var body: AnyView {
        self.lock()

        guard self.isPresenting, let payload = self.payload else {
            return AnyView(self.content())
        }

        return AnyView(payload.render(self.content(), self.$isPresenting))
    }
}

public class AlertRender<Payload>: ObservableObject where Payload: RawAlert {
    public typealias Body = AnyView

    public init() {}

    var payload: [Payload] = [] {
        didSet {
            self.objectWillChange.send()
        }
    }

    deinit {
        AlertManager.shared.remove(self)
    }
}

public extension View {
    func alertFactory<Payload: RawAlert>(_ state: AlertRender<Payload>) -> AnyView {
        AnyView(AlertView(state, { self }))
    }
}
