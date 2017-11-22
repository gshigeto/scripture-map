//
//  ScriptureViewController.swift
//  Scripture Map
//
//  Created by Gavin Nitta on 11/9/17.
//  Copyright © 2017 Gavin Nitta. All rights reserved.
//

import UIKit
import WebKit

class ScriptureViewController : UIViewController, WKNavigationDelegate {
    
    // MARK: - Storyboard
    private struct Storyboard {
        static let ShowMapIdentifier = "Show Map"
    }
    
    // MARK: - Properties
    var book: Book!
    var chapter = 0
    var geoLocation: GeoPlace? = nil
    
    // MARK: - Outlets
    private weak var mapViewController: MapViewController?
    private var webView: WKWebView!
    
    // MARK: - View Controller Lifecycle
    override func loadView() {
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.preferences.javaScriptEnabled = false
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureDetailViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let html = ScriptureRenderer.sharedRenderer.htmlForBookId(book.id, chapter: chapter)
        webView.loadHTMLString(html.0, baseURL: nil)
        if let mapVC = mapViewController {
            mapVC.title = "Map"
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ShowMapIdentifier {
            let navVC = segue.destination as? UINavigationController
            if let mapVC = navVC?.topViewController as? MapViewController {
                loadScriptures(mapVC)
            }
        }
    }
    
    // MARK: - Private Functions
    private func loadScriptures(_ mapVC: MapViewController? = nil) {
        let scriptures = GeoDatabase.sharedGeoDatabase.versesForScriptureBookId(book.id, chapter)
        var locations: [(GeoPlace, GeoTag)] = []
        for scripture in scriptures {
            locations += GeoDatabase.sharedGeoDatabase.geoTagsForScriptureId(scripture.id)
        }
        let viewController = mapVC == nil ? mapViewController : mapVC
        viewController?.locations = locations
        if let geo = geoLocation {
            viewController?.centerLocation = geo
            viewController?.title = geo.placename
            viewController?.centerPin(geo)
        } else {
            viewController?.title = "Map"
        }
    }
    
    // MARK: - WebKit Navigation Delegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let path = navigationAction.request.url?.absoluteString {
            if path.hasPrefix(ScriptureRenderer.Constant.baseUrl) {
                let arr = path.split(separator: "/")
                let id: Int? = Int(arr[arr.count - 1])
                let geo = GeoDatabase.sharedGeoDatabase.geoPlaceForId(id!)!
                geoLocation = geo
                if let mapVC = mapViewController {
                    mapVC.centerPin(geo)
                    mapVC.title = geo.placename
                } else {
                    performSegue(withIdentifier: Storyboard.ShowMapIdentifier, sender: self)
                }
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    
    // MARK: - Helpers
    func configureDetailViewController() {
        if let splitVC = splitViewController {
            if let navVC = splitVC.viewControllers.last as? UINavigationController {
                mapViewController = navVC.topViewController as? MapViewController
            } else {
                mapViewController = splitVC.viewControllers.last as? MapViewController
            }
            loadScriptures()
        } else {
            mapViewController = nil
        }
    }
    
}
