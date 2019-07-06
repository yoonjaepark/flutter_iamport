#import "FlutterIamportPlugin.h"
#import <flutter_iamport/flutter_iamport-Swift.h>

@implementation FlutterIamportPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterIamportPlugin registerWithRegistrar:registrar];
}
@end
