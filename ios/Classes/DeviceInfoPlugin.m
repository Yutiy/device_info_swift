#import "DeviceInfoPlugin.h"
#import <device_info/device_info-Swift.h>

@implementation DeviceInfoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDeviceInfoPlugin registerWithRegistrar:registrar];
}
@end
