import SwiftUI

private struct BottomSheetViewModifier<SheetContent>: ViewModifier where SheetContent: View {
    let isPresented: Binding<Bool>
    let contentView: () -> SheetContent
    let onDismiss: (() -> Void)?
    @Environment(\.bottomSheetConfiguration) private var configuration

    init(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> SheetContent
    ) {
        self.isPresented = isPresented
        self.onDismiss = onDismiss
        self.contentView = content
    }

    func body(content: Content) -> some View {
        content.background(
            NonAnimatedUIKitModal(
                isPresented: isPresented,
                content: {
                    BottomSheetView(
                        configuration: configuration,
                        onDismiss: {
                            onDismiss?()
                            isPresented.wrappedValue = false
                        },
                        content: contentView
                    )
                }
            )
        )
    }
}

extension View {
    /// Presents a modal bottom sheet view that covers as much of the screen as
    /// possible when binding to a Boolean value you provide is true.
    ///
    /// Use this method to show a bottom sheet view that covers as much of the screen
    /// as possible. The example below displays a custom view when the user
    /// toggles the value of the `isPresenting` binding:
    ///
    /// ```swift
    /// struct FullBottomSheetPresentedOnDismiss: View {
    ///     @State private var isPresenting = false
    ///     var body: some View {
    ///         Button("Present Full-Screen Bottom Sheet") {
    ///             isPresenting.toggle()
    ///         }
    ///         .bottomSheet(isPresented: $isPresenting, onDismiss: didDismiss) {
    ///             VStack {
    ///                 Text("A bottom sheet view.")
    ///                     .font(.title)
    ///             }
    ///         }
    ///     }
    ///
    ///     func didDismiss() {
    ///         // Handle the dismissing action.
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the bottom sheet view.
    ///   - onDismiss: The closure to execute when dismissing the bottom sheet view.
    ///   - content: A closure that returns the content of the bottom sheet view.
    public func bottomSheet<Content>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Swift.Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content: View {
        modifier(BottomSheetViewModifier(isPresented: isPresented, onDismiss: onDismiss, content: content))
    }

    /// Presents a modal bottom sheet view that covers as much of the screen as
    /// possible using the binding you provide as a data source for the
    /// sheet's content.
    ///
    /// Use this method to show a bottom sheet view that covers as much of the
    /// screen as possible. In the example below a custom structure —
    /// `CoverData` — provides data for the bottom sheet view to display in the
    /// `content` closure when the user clicks or taps the
    /// "Present Bottom Sheet With Data" button:
    ///
    /// ```swift
    /// struct FullBottomSheetPresentedOnDismissContent: View {
    ///     @State var coverData: CoverData?
    ///     var body: some View {
    ///         Button("Present Bottom Sheet With Data") {
    ///             coverData = CoverData(body: "Custom Data")
    ///         }
    ///         .bottomSheet(item: $coverData, onDismiss: didDismiss) { details in
    ///             VStack(spacing: 20) {
    ///                 Text("\(details.body)")
    ///             }
    ///         }
    ///     }
    ///
    ///     func didDismiss() {
    ///         // Handle the dismissing action.
    ///     }
    /// }
    ///
    /// struct CoverData: Identifiable {
    ///     var id: String {
    ///         return body
    ///     }
    ///     let body: String
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the sheet.
    ///     When `item` is non-`nil`, the system passes the contents to
    ///     the modifier's closure. You display this content in a sheet that you
    ///     create that the system displays to the user. If `item` changes,
    ///     the system dismisses the currently displayed sheet and replaces
    ///     it with a new one using the same process.
    ///   - onDismiss: The closure to execute when dismissing the bottom sheet view.
    ///   - content: A closure returning the content of the bottom sheet view.
    public func bottomSheet<Item, Content>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        ViewBuilder content: @escaping (Item) -> Content
    ) -> some View where Content: View {
        bottomSheet(isPresented: item.isPresent(), onDismiss: onDismiss, content: {
            if let value = item.wrappedValue {
                content(value)
            } else {
                let _ = assertionFailure("Missing value needed to present the bottom sheet content")
                EmptyView()
            }
        })
    }
}
