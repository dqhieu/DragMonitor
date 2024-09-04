//
//  DragMonitorApp.swift
//  DragMonitor
//
//  Created by Dinh Quang Hieu on 3/9/24.
//

import SwiftUI
import AppKit

@main
struct DragMonitorApp: App {

  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {

  var dragMonitor: Any?
  var lastPasteboardChangeCount: Int = NSPasteboard(name: .drag).changeCount

  func applicationDidFinishLaunching(_ notification: Notification) {
    dragMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDragged) { _ in
      self.checkForDraggedItems()
    }
  }

  func checkForDraggedItems() {
    let dragPasteboard = NSPasteboard(name: .drag)
    let currentChangeCount = dragPasteboard.changeCount
    guard lastPasteboardChangeCount != currentChangeCount else {
      return
    }
    lastPasteboardChangeCount = currentChangeCount
    let dragTypes = [NSPasteboard.PasteboardType.URL]
    if dragPasteboard.availableType(from: dragTypes) != nil {
      print("💛 dragging")
      if let urls = dragPasteboard.readObjects(forClasses: [NSURL.self]) as? [URL] {
        print("💛", urls.map(\.path))
      }
    }
  }
}
