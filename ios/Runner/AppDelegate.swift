import UIKit
import Flutter
import Foundation
import PhotosUI

func getAppSupportDirectory() -> String {
    let fileManager = FileManager.default
    if let baseAppSupportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
        let appBundleID = Bundle.main.bundleIdentifier ?? "DefaultApp"
        let appSupportDirectory = baseAppSupportDirectory.appendingPathComponent(appBundleID)
        
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


@main
@objc class AppDelegate: FlutterAppDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var picker: UIImagePickerController?
    var methodChannel: FlutterMethodChannel?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
     let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
       methodChannel = FlutterMethodChannel(name: "notes_method_channel",
                                                 binaryMessenger: controller.binaryMessenger)
        
        methodChannel?.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
            case "get_storage_path":
                result(getAppSupportDirectory())

//                if let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
//                    let appSupportDirPath = appSupportDir.path
//                    let appBundleID = Bundle.main.bundleIdentifier ?? "DefaultApp"
//                    let appSupportDirectory = appSupportDir.appendingPathComponent(appBundleID)
//                    result(appSupportDirectory.path)
//                } else {
//                    result("")
//        
//                }
            break
            case "select_image":
                 self.openImagePicker()
                break
                
            case "select_video":
                self.openVideoPicker()
                break
//            case "set_portait":
//                break
//            case "rotate_screen":
//                break
            case "show_toast":
                break
                
            default:
            break
            }
        }
      
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    // 이미지 선택기를 여는 함수
       func openImagePicker() {
           guard let controller = window?.rootViewController as? FlutterViewController else {
               return
           }
           picker = UIImagePickerController()
           picker?.delegate = self
           picker?.sourceType = .photoLibrary
           controller.present(picker!, animated: true, completion: nil)
       }
        
    func openVideoPicker() {
        guard let controller = window?.rootViewController as? FlutterViewController else {
              return
          }
          picker = UIImagePickerController()
          picker?.delegate = self
          picker?.sourceType = .photoLibrary
          picker?.mediaTypes = ["public.movie"] // 비디오를 선택하도록 설정
          controller.present(picker!, animated: true, completion: nil)
    }
       // 이미지 선택 완료 후 호출되는 델리게이트 메소드
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           picker.dismiss(animated: true, completion: nil)
           
            if let mediaType = info[.mediaType] as? String {
                  switch mediaType {
                  case "public.movie": // 비디오 처리
                      if let videoURL = info[.mediaURL] as? URL {
                          print("Video URL selected")
                          let videoPath = videoURL.path
                          methodChannel?.invokeMethod("on_video_selected", arguments: videoPath)
                      }
                  case "public.image": // 이미지 처리
                      if let imageURL = info[.imageURL] as? URL {
                          print("Image URL selected")
                          let imagePath = imageURL.path
                          methodChannel?.invokeMethod("on_image_selected", arguments: imagePath)
                      } else if let image = info[.originalImage] as? UIImage {
                          print("UIImage is selected")
                          let tempDir = FileManager.default.temporaryDirectory
                          let imageName = UUID().uuidString + ".png"
                          let imagePath = tempDir.appendingPathComponent(imageName).path
                          if let data = image.pngData() {
                              try? data.write(to: URL(fileURLWithPath: imagePath))
                              methodChannel?.invokeMethod("on_image_selected", arguments: imagePath)
                          }
                      }
                  default:
                      print("Unsupported media type selected")
                  }
              }
       }
  
}
