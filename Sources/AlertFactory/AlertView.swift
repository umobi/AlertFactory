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

    init(_ state: AlertRender<Payload>,_ content: @escaping () -> Content) {
        self.state = state
        self.content = content
    }

    var body: some View {
        self.content()
            .environmentObject(self.state)
            .background({ () -> AnyView in 
                guard self.state.isPresenting, let payload = self.state.actualPayload else {
                    return AnyView(EmptyView())
                }


                return AnyView(payload.render(self.$state.isPresenting))
            }())
    }
}

public class AlertRender<Payload>: ObservableObject where Payload: RawAlert {
    public typealias Body = AnyView

    public init() {}

    internal var isPresenting: Bool = false {
        didSet {
            if oldValue && !self.isPresenting {
                OperationQueue.main.addOperation {
                    self.isLocked = false

                    if self.payload.isEmpty {
                        self.actualPayload = nil
                        self.objectWillChange.send()
                    } else {
                        self.lock()
                    }
                }
            }
        }
    }

    internal var actualPayload: Payload?

    var payload: [Payload] = [] {
        didSet {
            self.lock()
        }
    }

    var isLocked: Bool = false

    func lock() {
        if let payload = self.payload.first {
            if !self.isLocked {
                self.isLocked = true
                let payload = payload

                OperationQueue.main.addOperation {
                    self.isPresenting = true
                    self.actualPayload = payload
                    self.objectWillChange.send()
                }

                self.payload.removeFirst()
            }
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
