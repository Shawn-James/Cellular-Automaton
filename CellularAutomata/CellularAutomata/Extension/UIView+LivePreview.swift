// Copyright © 2020 Shawn James. All rights reserved.
// UIView+LivePreview.swift

#if DEBUG
import SwiftUI

extension UIView {
    var livePreview: some View { LivePreview(view: self) }
    
    struct LivePreview<V: UIView>: UIViewRepresentable {
        let view: V
        
        func makeUIView(context: UIViewRepresentableContext<LivePreview<V>>) -> V { return view }
        
        func updateUIView(_ uiView: V, context: Context) { }
    }
    
}

#endif
