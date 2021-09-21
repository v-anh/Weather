//
//  BaseViewController.swift
//  Weather
//
//  Created by Anh Tran on 21/09/2021.
//

import Foundation
import UIKit
class BaseViewController: UIViewController {
    lazy var activityIndicationView = ActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySetUp()
    }
    
    private func activitySetUp() {
        activityIndicationView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicationView)
        NSLayoutConstraint.activate([
        activityIndicationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        activityIndicationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        activityIndicationView.heightAnchor.constraint(equalToConstant: 50),
        activityIndicationView.widthAnchor.constraint(equalToConstant: 50.0)])
    }
    
    func startLoading() {
        activityIndicationView.isHidden = false
        activityIndicationView.startAnimating()
    }
    
    func finishLoading() {
        activityIndicationView.stopAnimating()
    }
    
    func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
