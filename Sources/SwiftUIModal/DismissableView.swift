import SwiftUI

/// A type that represents a part of a modaly presented view
/// and can be dismissed.
public protocol DismissableView: View {
    func dismiss(completion: @escaping () -> Void)
}
