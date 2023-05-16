//
//  ViewController.swift
//  svg
//
//  Created by David Wagner on 16/05/2023.
//
import UIKit
import WebKit

final class SVGView: UIView {
    private let image: UIImageView = .init()
    private var svg: String?
    private var wv: WKWebView
    
    override init(frame: CGRect) {
        wv = .init(frame: .zero)
        super.init(frame: frame)

        wv.navigationDelegate = self
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("No supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        render()
    }
    
    func load(url: URL) async throws {
        let (data, _) = try await URLSession.shared.data(from: url)
        self.svg = String(decoding: data, as: UTF8.self)
        render()
    }
}

extension SVGView {
    private func render() {
        guard let svg else { return }
        wv.frame = frame
        wv.loadHTMLString(svg, baseURL: nil)
    }
    
    private func renderSnapshot() {
        wv.takeSnapshot(with: .init()) { [weak self] image, error in
            guard let image else {
                print("Snapshot error: \(String(describing: error))")
                return
            }
            self?.image.image = image
        }
    }
}

extension SVGView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        renderSnapshot()
    }
}
