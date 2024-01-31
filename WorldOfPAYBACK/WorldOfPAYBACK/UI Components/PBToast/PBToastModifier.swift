//
//  PBToastModifier.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 31/01/2024.
//

import SwiftUI

struct PBToastModifier: ViewModifier {
    
    let message: String?
    @Binding var isShowing: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            if isShowing, let message {
                PBToast(message: message)
                    .padding(.top, 20)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isShowing = false
                            }
                        }
                    }
                    .zIndex(9999)
                    .transition(.opacity)
            }
        }
    }
}

extension View {
    func pbToastView(message: String?,
                     isShowing: Binding<Bool>) -> some View {
        self.modifier(PBToastModifier(message: message,
                                      isShowing: isShowing))
    }
}
