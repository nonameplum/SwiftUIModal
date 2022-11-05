import UIKit
import SwiftUI


/// A view that presents SwiftUI ``DismissableView`` modaly without animation.
public struct NonAnimatedUIKitModal<Presented>: UIViewControllerRepresentable where Presented: DismissableView {
    public let isPresented: Binding<Bool>
    public let content: () -> Presented

    /// Creates non-animated modal that enables programmatic control
    /// of the modal visibility and content.
    /// - Parameters:
    ///   - isPresented: A Binding to state that controls the visibility of the modal.
    ///   - content: The view to show in the modal.
    public init(isPresented: Binding<Bool>, content: @escaping () -> Presented) {
        self.isPresented = isPresented
        self.content = content
    }

    public final class Coordinator {
        private let parent: NonAnimatedUIKitModal
        weak var presentedController: UIHostingController<Presented>?

        init(_ parent: NonAnimatedUIKitModal) {
            self.parent = parent
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        return viewController
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented.wrappedValue, let vc = context.coordinator.presentedController {
            vc.rootView = content()
        }

        if isPresented.wrappedValue {
            var contentController: UIHostingController<Presented>!
            contentController = UIHostingController(rootView: content())
            contentController.modalPresentationStyle = .custom
            contentController.view.backgroundColor = .clear
            context.coordinator.presentedController = contentController
            uiViewController.present(contentController, animated: false)
        } else if uiViewController.presentedViewController != nil {
            context.coordinator.presentedController?.rootView.dismiss(completion: {
                uiViewController.dismiss(animated: false)
            })
        }
    }
}

