//
//  ViewController.swift
//  02-BasicTableView Expanded
//
//  Created by Daniel Pink on 11/02/2016.
//  Copyright © 2016 Daniel Pink. All rights reserved.
//

import Cocoa


struct Template {
    let name: String
    let image: NSImage?
}

class ViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    let tableData: [String] = [
        "NSQuickLookTemplate",
        "NSBluetoothTemplate",
        "NSIChatTheaterTemplate",
        "NSSlideshowTemplate",
        "NSActionTemplate",
        "NSSmartBadgeTemplate",
        "NSIconViewTemplate",
        "NSListViewTemplate",
        "NSColumnViewTemplate",
        "NSFlowViewTemplate",
        "NSPathTemplate",
        "NSInvalidDataFreestandingTemplate",
        "NSLockLockedTemplate",
        "NSLockUnlockedTemplate",
        "NSGoRightTemplate",
        "NSGoLeftTemplate",
        "NSRightFacingTriangleTemplate",
        "NSLeftFacingTriangleTemplate",
        "NSAddTemplate",
        "NSRemoveTemplate",
        "NSRevealFreestandingTemplate",
        "NSFollowLinkFreestandingTemplate",
        "NSEnterFullScreenTemplate",
        "NSExitFullScreenTemplate",
        "NSStopProgressTemplate",
        "NSStopProgressFreestandingTemplate",
        "NSRefreshTemplate",
        "NSRefreshFreestandingTemplate",
        "NSBonjour",
        "NSComputer",
        "NSFolderBurnable",
        "NSFolderSmart",
        "NSFolder",
        "NSNetwork",
        "NSMobileMe",
        "NSMultipleDocuments",
        "NSUserAccounts",
        "NSPreferencesGeneral",
        "NSAdvanced",
        "NSInfo",
        "NSFontPanel",
        "NSColorPanel",
        "NSUser",
        "NSUserGroup",
        "NSEveryone",
        "NSUserGuest",
        "NSMenuOnStateTemplate",
        "NSMenuMixedStateTemplate",
        "NSApplicationIcon",
        "NSTrashEmpty",
        "NSTrashFull",
        "NSHomeTemplate",
        "NSBookmarksTemplate",
        "NSCaution",
        "NSStatusAvailable",
        "NSStatusPartiallyAvailable",
        "NSStatusUnavailable",
        "NSStatusNone"]
    
    var tableContents: [Template] {
        var array: [Template] = []
        for name in tableData {
            let contents = Template(name: name, image: NSImage(named: name))
            array.append(contents)
        }
        return array
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.reloadData()
        
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        // Get a copy of the data for this particular row
        guard let template = tableContents[safe: row] else {
            return nil
        }
        
        // Identify which column we are providing a view for. Note that the identifier string
        // needed to be entered into IB manually
        guard let columnIdentifier = tableColumn?.identifier else {
            return nil
        }
        
        switch columnIdentifier {
        case "MainCell":
            // Ask the tableView to make a view for us. In this case we know that is will be an
            // NSTableCellView so we force downcast it accordingly.
            let cellView = tableView.makeViewWithIdentifier(columnIdentifier, owner: self) as! NSTableCellView
            cellView.textField?.stringValue = template.name
            cellView.imageView?.objectValue = template.image
            
            return cellView
        case "SizeCell":
            let cellView = tableView.makeViewWithIdentifier(columnIdentifier, owner: self) as! NSTableCellView
            
            let size = template.image?.size ?? NSZeroSize
            
            cellView.textField?.stringValue = "\(size)"
            return cellView
        default:
            return nil
        }
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        print("Selection Changed \(notification)")
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return tableContents.count
    }
}

