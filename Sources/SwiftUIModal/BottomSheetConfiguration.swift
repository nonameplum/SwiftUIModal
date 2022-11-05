import SwiftUI

/// A type to configure a bottom sheet with a custom appearance and custom interaction behavior.
public struct BottomSheetConfiguration {
    /// Default bottom sheet configuration
    public static let `default` = BottomSheetConfiguration()
    /// A dimension that's proportional to the bottom sheet height
    /// that is used to decide if the bottom sheet should be dismissed.
    public var dismissRatio: CGFloat = 0.3
    /// A dimension in points that allows to specify additional offset
    /// that the bottom sheet view can be draged over it's height.
    public var maxOverDrag: CGFloat = 30
    /// A view used a bottom sheet content background.
    public var background = AnyView(RoundedRectangle(cornerRadius: 32).fill(Color.white))
    /// A view that is used as the dim behind the bottom sheet content.
    public var dim = AnyView(Color.black.opacity(0.3))
    /// A view that is used as a drag indicator on top of the bottom sheet content.
    public var indicator = AnyView(
        RoundedRectangle(cornerRadius: 2)
            .fill(.gray)
            .frame(width: 64, height: 4)
            .padding([.top], 12)
            .padding([.bottom], 16)
    )

    fileprivate init() {}

    /// Creates the bottom sheet configuration with a custom appearance and custom interaction behavior.
    /// - Parameters:
    ///   - dismissRatio: A dimension that's proportional to the bottom sheet height
    ///                   that is used to decide if the bottom sheet should be dismissed.
    ///   - maxOverDrag: A dimension in points that allows to specify additional offset
    ///                  that the bottom sheet view can be draged over it's height.
    ///   - background: A view used a bottom sheet content background.
    ///   - dim: A view that is used as the dim behind the bottom sheet content.
    ///   - indicator: A view that is used as a drag indicator on top of the bottom sheet content.
    public init<Background: View, Dim: View, Indicator: View>(
        dismissRatio: CGFloat? = nil,
        maxOverDrag: CGFloat? = nil,
        background: (() -> Background)? = nil,
        dim: (() -> Dim)? = nil,
        indicator: (() -> Indicator)? = nil
    ) {
        if let dismissRatio {
            self.dismissRatio = dismissRatio
        }
        if let maxOverDrag {
            self.maxOverDrag = maxOverDrag
        }
        if let background {
            self.background = AnyView(background())
        }
        if let dim {
            self.dim = AnyView(dim())
        }
        if let indicator {
            self.indicator = AnyView(indicator())
        }
    }
}

private struct BottomSheetConfigurationKey: EnvironmentKey {
    static let defaultValue: BottomSheetConfiguration? = nil
}

extension EnvironmentValues {
    var bottomSheetConfiguration: BottomSheetConfiguration? {
        get { self[BottomSheetConfigurationKey.self] }
        set { self[BottomSheetConfigurationKey.self] = newValue }
    }
}

extension View {
    /// Sets the bottom sheet configuration with a custom appearance and custom interaction behavior.
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
    ///         .bottomSheetConfiguration(.default)
    ///     }
    ///
    ///     func didDismiss() {
    ///         // Handle the dismissing action.
    ///     }
    /// }
    /// ```
    public func bottomSheetConfiguration(_ configuration: BottomSheetConfiguration) -> some View {
        environment(\.bottomSheetConfiguration, configuration)
    }
}
