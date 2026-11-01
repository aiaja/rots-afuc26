import SwiftUI
import WebKit

struct HomeView: View {
    // URL scene Spline 3D pengguna
    private let splineSceneURL = URL(string: "https://my.spline.design/miniroomartcopy-Cxjf3nOWQydowSIy3eCxUxFy/")!

    @State private var isLoading = true

    var body: some View {
        ZStack {
            // Background dasar
            Color.black.ignoresSafeArea()

            // 1. Tampilan 3D Layar Penuh (Full Screen Web / iframe)
            SplineFullWebView(url: splineSceneURL, isLoading: $isLoading)
                .ignoresSafeArea()

            // 2. Loading Indicator saat pertama kali memuat model 3D
            if isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.3)
                    Text("Memuat 3D Mini Room...")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(24)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

// MARK: - WKWebView Pembungkus Layar Penuh (Fullscreen & Touch-Ready)
private struct SplineFullWebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false

        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: SplineFullWebView

        init(_ parent: SplineFullWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            withAnimation(.easeOut(duration: 0.3)) {
                parent.isLoading = false
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            withAnimation {
                parent.isLoading = false
            }
        }
    }
}

#Preview {
    HomeView()
}
