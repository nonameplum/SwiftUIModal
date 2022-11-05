import SwiftUI

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        Modal()
            .previewDisplayName("Default modal")

        Modal()
            .bottomSheetConfiguration(
                .init(
                    dismissRatio: 0.5,
                    maxOverDrag: 0,
                    background: { Color.yellow },
                    dim: { Color.blue.opacity(0.3) },
                    indicator: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.orange)
                            .frame(width: 100, height: 10).padding()
                    }
                )
            )
            .previewDisplayName("Custom configured modal")

        NonModal()
            .previewDisplayName("Non modal bottom sheet")
    }

    private static let customConfiguration: BottomSheetConfiguration = .init(
        dismissRatio: 0.5,
        maxOverDrag: 0,
        background: { Color.yellow },
        dim: { Color.blue.opacity(0.3) },
        indicator: {
            RoundedRectangle(cornerRadius: 10)
                .fill(.orange)
                .frame(width: 100, height: 10).padding()
        }
    )

    struct Modal: View {
        @State private var isPresenting: Bool = false

        var body: some View {
            NavigationView {
                ZStack {
                    Button("Show bottom sheet") {
                        isPresenting.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .bottomSheet(isPresented: $isPresenting) {
                        ForEach(1 ..< 10) { index in
                            Text("Row \(index)")
                        }
                        .padding([.leading, .trailing])
                    }
                }
                .navigationTitle("Navigation title")
            }
        }
    }

    struct NonModal: View {
        @State private var isPresenting: Bool = false

        init() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UIColor.clear
            appearance.backgroundEffect = UIBlurEffect(style: .light)

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
        }

        var body: some View {
            NavigationView {
                ZStack {
                    Button("Show bottom sheet") {
                        isPresenting.toggle()
                    }
                    .buttonStyle(.borderedProminent)

                    if isPresenting {
                        BottomSheetView(onDismiss: { isPresenting = false }) {
                            ForEach(1 ..< 10) { index in
                                Text("Row \(index)")
                            }
                            .padding([.leading, .trailing])
                        }
                    }
                }
                .navigationTitle("Navigation title")
            }
        }
    }
}
