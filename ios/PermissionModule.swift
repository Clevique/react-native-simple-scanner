import AVFoundation
import React

@objc(PermissionModule)
class PermissionModule: NSObject {
  @objc static func requiresMainQueueSetup() -> Bool {
    return false
  }

  @objc func checkCameraPermission(
    _ resolve: @escaping RCTPromiseResolveBlock,
    reject: @escaping RCTPromiseRejectBlock
  ) {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    let statusString = mapStatusToString(status)
    resolve(statusString)
  }

  @objc func requestCameraPermission(
    _ resolve: @escaping RCTPromiseResolveBlock,
    reject: @escaping RCTPromiseRejectBlock
  ) {
    AVCaptureDevice.requestAccess(for: .video) { granted in
      resolve(granted)
    }
  }

  private func mapStatusToString(_ status: AVAuthorizationStatus) -> String {
    switch status {
    case .authorized:
      return "granted"
    case .denied, .restricted:
      return "denied"
    case .notDetermined:
      return "not-determined"
    @unknown default:
      return "not-determined"
    }
  }
}
