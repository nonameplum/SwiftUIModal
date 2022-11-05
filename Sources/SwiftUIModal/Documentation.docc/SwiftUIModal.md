# ``SwiftUIModal``

A sliding sheet from the bottom of the screen that uses UIKit to present true *modal* view, but the whole animation and UI is driven by the SwiftUI.
It uses and provides ``NonAnimatedUIKitModal`` view that handles the modal UIKit wrapped modal presentation.

## Additional Resources

* [GitHub Repo](https://github.com/nonameplum/UIEnvironment)

## Overview

![modal presentation](modal_presentation)

The bottom shhet usage is very similar to SwiftUI [`sheet`](https://developer.apple.com/documentation/SwiftUI/View/sheet(isPresented:onDismiss:content:)) or [`fullScreenCover`](https://developer.apple.com/documentation/swiftui/view/fullscreencover(ispresented:ondismiss:content:)) by using `bottomSheet` method:

```swift
struct Modal: View {
    @State private var isPresenting: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Button("Show bottom sheet") {
                    isPresenting.toggle()
                }
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
```

In addition to that, the bottom sheet can be also used standalone, e.g. by using `if` statement and conditionally show the view:

```swift
struct NonModal: View {
    @State private var isPresenting: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Button("Show bottom sheet") {
                    isPresenting.toggle()
                }
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
```

The difference between the two, is that in the first case the bottom sheet will be presented modaly on top of any other view including navigation bar.

## Topics

### Presentation

- ``NonAnimatedUIKitModal``

- ``DismissableView``

### Configuration

- ``BottomSheetConfiguration``
