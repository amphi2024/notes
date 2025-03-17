import Cocoa
import FlutterMacOS
import Photos

@main
class AppDelegate: FlutterAppDelegate {
    
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
        
        let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "notes_method_channel",
                                                 binaryMessenger: controller.engine.binaryMessenger)
        
        methodChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
            case "get_storage_path":
                result(self.getAppSupportDirectory())
                break
            default:
                break
            }
        }
    }
    
}
