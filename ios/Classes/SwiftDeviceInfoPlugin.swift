import Flutter
import UIKit

public class SwiftDeviceInfoPlugin: NSObject, FlutterPlugin {
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "plugins.yutiy/device_info", binaryMessenger: registrar.messenger())
    let instance = SwiftDeviceInfoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "getIosDeviceInfo") {
      let device = UIDevice.current
      
      let (sysname, nodename, release, version, machine) = self.transformTuple()
      let dic = [
        "name": device.name,
        "systemName": device.systemName,
        "systemVersion": device.systemVersion,
        "model": device.model,
        "localizedModel": device.localizedModel,
        "identifierForVendor": (device.identifierForVendor?.uuidString)!,
        "isPhysicalDevice": self.isDevicePhysical(),
        "utsname" : [
          "sysname": sysname,
          "nodename": nodename,
          "release": release,
          "version": version,
          "machine": machine,
        ]
      ] as [String: Any]
      result(dic)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
  
  // tuple -> String
  private func transformTuple() -> (sysname: String, nodename: String, release: String, version: String, machine: String) {
    var systemInfo = utsname()
    uname(&systemInfo)
    
    let sysname = withUnsafePointer(to: &systemInfo.sysname.0) {
      ptr in
      return String(cString: ptr)
    }
    
    let nodename = withUnsafePointer(to: &systemInfo.nodename.0) {
      ptr in
      return String(cString: ptr)
    }
    
    let release = withUnsafePointer(to: &systemInfo.release.0) {
      ptr in
      return String(cString: ptr)
    }
    
    let version = withUnsafePointer(to: &systemInfo.version.0) {
      ptr in
      return String(cString: ptr)
    }
    
    let machine = withUnsafePointer(to: &systemInfo.machine.0) {
      ptr in
      return String(cString: ptr)
    }
    
    return (sysname: sysname, nodename: nodename, release: release, version: version, machine: machine)
  }

  private func isDevicePhysical() -> NSString {
    // 宏 -> 编译时进行处理
    #if targetEnvironment(simulator)
      let isPhysicalDevice: NSString  = "true"
    #else
      let isPhysicalDevice: NSString = "false"
    #endif
  
    return isPhysicalDevice
  }
  
}
