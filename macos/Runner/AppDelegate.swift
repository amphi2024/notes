import Cocoa
import FlutterMacOS
import Photos

@main
class AppDelegate: FlutterAppDelegate {
    
    var methodChannel: FlutterMethodChannel?
    
    func getAppSupportDirectory() -> String {
        let fileManager = FileManager.default
        if let baseAppSupportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let appBundleID = Bundle.main.bundleIdentifier ?? "DefaultApp"
            let appSupportDirectory = baseAppSupportDirectory.appendingPathComponent(appBundleID)
            
            // Ensure the directory exists
            do {
                try fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)
                return appSupportDirectory.path
            } catch {
                print("Error creating App Support subdirectory: \(error)")
                return ""
            }
        }
        return ""
    }
    
    
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    @objc override func applicationDidFinishLaunching(_ notification: Notification) {
        
        mainFlutterWindow?.toolbar = NSToolbar()
        if #available(macOS 11.0, *) {
            mainFlutterWindow?.toolbarStyle = .unified
        }
        
        let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
        methodChannel = FlutterMethodChannel(name: "notes_method_channel",
                                                 binaryMessenger: controller.engine.binaryMessenger)
        
        methodChannel?.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
            case "get_storage_path":
                result(self.getAppSupportDirectory())
                break
            default:
                result(FlutterMethodNotImplemented)
                break
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(onEnterFullScreen), name: NSWindow.didEnterFullScreenNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onExitFullScreen), name: NSWindow.didExitFullScreenNotification, object: nil)

    }
    
    @objc func onEnterFullScreen(notification: Notification) {
        mainFlutterWindow?.toolbar = nil
        methodChannel?.invokeMethod("on_enter_fullscreen", arguments: nil)
    }

    @objc func onExitFullScreen(notification: Notification) {
        mainFlutterWindow?.toolbar = NSToolbar()
        if #available(macOS 11.0, *) {
            mainFlutterWindow?.toolbarStyle = .unified
        }
       methodChannel?.invokeMethod("on_exit_fullscreen", arguments: nil)
    }
    
}
