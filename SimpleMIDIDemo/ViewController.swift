//
//  ViewController.swift
//  SimpleMIDIDemo
//
//  Created by Andrew Madsen on 5/23/16.
//  Copyright © 2016 Mixed In Key. All rights reserved.
//

import Cocoa
import MIKMIDI

/*:
This is just an example to make this demo simple.
In a real app, you'd want a separate class in your app that you use to handle MIDI
instead of doing MIDI stuff directly in your view controller like this.
*/
class ViewController: NSViewController, MIKMIDIConnectionManagerDelegate {

	let connectionManager = MIKMIDIConnectionManager(name: "com.yourcompany.YourApp.ConnectionManager")
	
	override convenience init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		configureConnectionManager()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configureConnectionManager()
	}
	
	private func configureConnectionManager() {
		connectionManager.delegate = self
		connectionManager.eventHandler = { [weak self] (source, commands) -> Void in
			print("Received a MIDI command: \(commands)")
			guard let strongSelf = self else { return }
			commands.forEach(strongSelf.handleMIDICommand)
		}
	}
	
	func handleMIDICommand(command: MIKMIDICommand) {
		textView.textStorage?.mutableString.appendString("Received MIDI command: \(command)\n")
	}
	
	// MARK: - MIKMIDIConnectionManagerDelegate
	
	func connectionManager(manager: MIKMIDIConnectionManager, shouldConnectToNewlyAddedDevice device: MIKMIDIDevice) -> MIKMIDIAutoConnectBehavior {
		// Decide if we want to connect to the device, e.g. depending on its name. For now we'll, just do the default
		// which is to always connect to new devices, or devices that were previously connected
		return .ConnectIfPreviouslyConnectedOrNew
	}
	
	// MARK: - Outlets
	
	@IBOutlet var textView: NSTextView!
}

