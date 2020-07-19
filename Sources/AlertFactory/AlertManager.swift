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

class AlertManager {
    struct Weak {
        weak var object: AnyObject!
    }

    var renders: [Weak] = []

    func store<Payload>(_ render: AlertRender<Payload>) where Payload: RawAlert {
        self.renders.append(.init(object: render))
    }

    func remove<Payload>(_ render: AlertRender<Payload>) where Payload: RawAlert {
        self.renders = self.renders.filter {
            $0.object !== render
        }
    }

    func render<Payload>(_ payloadType: Payload.Type) -> AlertRender<Payload>? where Payload: RawAlert {
        guard let render = self.renders.first(where: { $0.object is AlertRender<Payload> })?.object as? AlertRender<Payload> else {
            return nil
        }

        return render
    }

    static let shared: AlertManager = .init()
}
