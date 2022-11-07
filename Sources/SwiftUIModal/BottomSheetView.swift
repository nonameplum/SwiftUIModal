import SwiftUI

public struct BottomSheetView<Content>: DismissableView where Content: View {
    public var onDismiss: () -> Void

    @GestureState private var translation: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    @State private var show = false
    private let explicitConfiguration: BottomSheetConfiguration?
    @Environment(\.bottomSheetConfiguration) private var environmentConfiguration
    private var configuration: BottomSheetConfiguration {
        environmentConfiguration ?? explicitConfiguration ?? BottomSheetConfiguration.default
    }

    private let content: Content

    public init(
        configuration: BottomSheetConfiguration? = nil,
        onDismiss: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    ) {
        self.explicitConfiguration = configuration
        self.onDismiss = onDismiss
        self.content = content()
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                configuration.indicator
                content
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                    .onTapGesture {}
                Rectangle().fill(.clear).frame(maxWidth: geometry.size.width, maxHeight: Constants.bottomPaddingHeight)
            }
            .padding(.bottom, safeAreaInsets().bottom)
            .readSize {
                contentHeight = $0.height
            }
            .background(configuration.background)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: maxOffset)
            .animation(springAnimation, value: translation)
            .simultaneousGesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    dismissIfNeededOnDragEnd(translationHeight: value.translation.height)
                }
            )
        }
        .background {
            configuration.dim
                .gesture(TapGesture().onEnded {
                    dismiss()
                })
                .opacity(show ? 1 : 0)
        }
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(springAnimation) {
                    show = true
                }
            }
        }
    }

    public func dismiss(completion: @escaping () -> Void = {}) {
        withAnimation(springAnimation) {
            show = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            completion()
            onDismiss()
        }
    }

    // MARK: Helpers
    private let springAnimation: Animation = .interactiveSpring(
        response: 0.35,
        dampingFraction: 0.78,
        blendDuration: 0
    )

    private var maxOffset: CGFloat {
        let offset = show ? 0 : contentHeight
        return offset + Constants.bottomPaddingHeight + max(translation, -configuration.maxOverDrag)
    }

    private func dismissIfNeededOnDragEnd(translationHeight: CGFloat) {
        let ratioHeight = (contentHeight - Constants.bottomPaddingHeight) * configuration.dismissRatio
        if translationHeight > ratioHeight {
            dismiss()
        }
    }

    private func safeAreaInsets() -> UIEdgeInsets {
        UIApplication.shared
            .connectedScenes
            .first
            .flatMap { $0 as? UIWindowScene }?
            .windows
            .first(where: { $0.isKeyWindow })?
            .safeAreaInsets
            ?? .zero
    }
}

private enum Constants {
    /// Padding added to the bottom of the sheet to allow over drag
    /// to the top and also to avoid bottom rounded corners to be visible
    static let bottomPaddingHeight: CGFloat = 100
}
