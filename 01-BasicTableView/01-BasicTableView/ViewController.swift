//
//  ViewController.swift
//  01-BasicTableView
//
//  Created by Daniel Pink on 11/02/2016.
//  Copyright © 2016 Daniel Pink. All rights reserved.
//

import Cocoa

/*
Notes as I go.
This little project is a copy of the Basic Table View from the NSTableViewPlayground example project from Apple. I find the Apple example a little overwhelming as the project includes several examples bundled into a single application. Hopefully seperating it out will make it easier to follow. 
https://developer.apple.com/library/mac/samplecode/TableViewPlayground/Introduction/Intro.html#//apple_ref/doc/uid/DTS40010727

- Start off with a blank project using the Cocoa Application template.
- Drag an NSTableView out into IB and size it to fill its view
- Change the column header names and adjust their sizes.
- Set identifiers for both columns in IB.
- Extend the ViewController with the NSTableViewDelegate and NSTableViewDataSource protocols. I like to keep my protocol conformance in seperate extensions. This helps to identify which methods belong to which protocols.
- Create an outlet in the ViewController to reference the tableView
- In IB connect the tableView to the view controller via the delegate, datasource and tableview outlets. (You can do this by control dragging from the NSTableview (Make sure you have clicked on it three times to get to the NSTableView rather than the NSScrollView or NSClipView) to the little blue ViewController symbol that is directly above the NSTableView (In the 'window' chrome).
- In IB replace the plain Table View Cell in the first column by deleting it (click on it 4 times to select then press delete) and putting in its place an Image & Text Table Cell View.
- Replace the Table View Cell in the second column with an NSTextField (Label). I'm not sure why you would do this? Just to show that any View can be used maybe?
- Create our data. In this case we are taking a list of template names and looking up some built in system images based on those names. We then create a struct with the name and image and store that in an array. There are several other ways to do this such as
    - Could have had a Template enum. Didn't as the list might change as the OS updates
    - Could have just used a (name, NSImage) tuple. This might be better.
- Our model needs to be indexed by an integer to keep track of which data goes into which row. This makes an array a logical choice. There are other options though as dictionaries and sets can export their data to arrays which can then be used by the table. This allows filtering and sorting too.
- Ask the tableView to reload its data when the view has loaded. This will initiate a string of delegate calls from the tableView to our ViewController in which the required data is extracted and then displayed.
- Implement the dataSource method, numberOfRowsInTableView. The tableView asks is data source how many rows it needs to display.
- Implement the delegate method, viewForTableColumn. The tableView asks its delegate for a View to display for each row and column. We have to identify which data is needed and produce a view that suits. We can use the tableView to create an empty view of the right type using makeViewWithIdentifier.
- The program should now run and display the correct data. 
- Couple of clean up items
    - Format the size details correctly
    - Make sure the layout constraints have been set correctly 
        - Make the tableView fill the view
        - 

*/

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
            let textField = tableView.makeViewWithIdentifier(columnIdentifier, owner: self) as! NSTextField
            
            let size = template.image?.size ?? NSZeroSize
            
            textField.stringValue = "\(size)"
            return textField
        default:
            return nil
        }
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return tableContents.count
    }
}