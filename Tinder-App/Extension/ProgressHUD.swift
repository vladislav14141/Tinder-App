//
//  ProgressHUD.swift
//  Tinder-App
//
//  Created by Миронов Влад on 14.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import Foundation
import JGProgressHUD

public class ProgressHUD: JGProgressHUD {
    let hud = JGProgressHUD(style: .dark)

    func showHUDWithMessage(in view: UIView, error: Error?) {
        if let err = error {
            hud.textLabel.text = "Failed registration"
            hud.detailTextLabel.text = err.localizedDescription
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
        } else {
            hud.textLabel.text = "Success"
            hud.detailTextLabel.text = "Welcome to Tinder"
            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        }
        hud.show(in: view, animated: true)
        hud.dismiss(afterDelay: 3)
    }
    
    func showProgressHUD(in view: UIView, with message: String) {
        hud.textLabel.text = message
        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        hud.show(in: view, animated: true)
    }
    
    func showUploadingProgressHUD(in view: UIView, progress: Float, with message: String){
        hud.textLabel.text = message
        hud.progress = progress
        hud.indicatorView = JGProgressHUDPieIndicatorView()
        hud.show(in: view, animated: true)

    }
    
    public override func dismiss() {
        self.hud.dismiss()
    }
}
