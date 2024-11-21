//
//  ManagedNavigationStack.swift
//  Navigator
//
//  Created by Michael Long on 11/10/24.
//

import SwiftUI

@MainActor
public struct ManagedNavigationStack<Content: View>: View {

    @Environment(\.navigator) private var parent: Navigator
    @Environment(\.dismiss) private var action: DismissAction

    private var dismissible: Bool
    private var content: Content

    /// Initializes NavigationStack
    public init(content: () -> Content) {
        self.dismissible = false
        self.content = content()
    }

    /// Initializes NavigationStack
    public init(dismissible: Bool, content: () -> Content) {
        self.dismissible = dismissible
        self.content = content()
    }

    public var body: some View {
        WrappedNavigationStack(parent: parent, action: dismissible ? action : nil, content: content)
    }

    // Wrapped view exists so parent environment variables can be extracted and passed to navigator.
    private struct WrappedNavigationStack: View {

        @StateObject private var navigator: Navigator
        private let content: Content

        init(parent: Navigator, action: DismissAction?, content: Content) {
            self._navigator = .init(wrappedValue: .init(parent: parent, action: action))
            self.content = content
        }

        public var body: some View {
            NavigationStack(path: $navigator.path) {
                content
            }
            .sheet(item: $navigator.sheet ) { destination in
                destination.asView()
            }
            .fullScreenCover(item: $navigator.fullScreenCover) { destination in
                destination.asView()
            }
            .environment(\.navigator, navigator)
        }
    }

}
