//
//  ControlPanelView.swift
//  SwiftHub
//
//  Created by Nayebaziz, Sahand on 5/15/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import StateView

enum ControlPanelViewKey: StateKey {
    case
    StatusKey,
    StatusValue,
    StatusTappedSelector
}

class ControlPanelView: StateView, FilteredDisplayDelegate {
    
    override func getInitialState() -> [String : Any?] {
        return [
            "filter" : nil
        ]
    }
    
    override func render() {
        
        backgroundColor = UIColor.whiteColor()
        clipsToBounds = true
        layer.cornerRadius = 4.0
        
        let createdAtStatus = place(ControlPanelStatusView.self, key: "createdStatus") { make in
            make.height.equalTo(self)
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-28)
            make.width.equalTo(self).dividedBy(2).offset(-56)
        }
        
        createdAtStatus.prop(forKey: ControlPanelViewKey.StatusKey, is: "Filter")
        if let filter = state["filter"] as? SHGithubCreatedFilter {
            createdAtStatus.prop(forKey: ControlPanelViewKey.StatusValue, is: filter.prettyString)
        } else {
            createdAtStatus.prop(forKey: ControlPanelViewKey.StatusValue, is: "none")
        }
        createdAtStatus.prop(forKey: ControlPanelViewKey.StatusTappedSelector) { _ in
            self.parentViewController.presentViewController(FilterAlertViewController(delegate: self), animated: true, completion: nil)
        }
    }
    
    func didReceiveFilters(filters: [SHGithubCreatedFilter]) {
        if filters.isEmpty {
            self.state["filter"] = nil
        } else {
            self.state["filter"] = filters.first!
        }
        
        (parentViewController as? FilteredDisplayDelegate)?.didReceiveFilters(filters)
    }
}
