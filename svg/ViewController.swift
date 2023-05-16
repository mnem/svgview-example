//
//  ViewController.swift
//  svg
//
//  Created by David Wagner on 16/05/2023.
//
import UIKit

class ViewController: UIViewController {

    let svg = SVGView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(svg)
        svg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            svg.widthAnchor.constraint(equalToConstant: 256),
            svg.heightAnchor.constraint(equalToConstant: 256),
            svg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            svg.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        Task {
            do {
                try await svg.load(url: URL(string: "https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/ruby.svg")!)
                print("Loaded")
            } catch {
                print("Uh-oh: \(error)")
            }
        }
    }
}

