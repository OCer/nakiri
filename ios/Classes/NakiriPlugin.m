#import "NakiriPlugin.h"
#if __has_include(<nakiri/nakiri-Swift.h>)
#import <nakiri/nakiri-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "nakiri-Swift.h"
#endif

@implementation NakiriPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNakiriPlugin registerWithRegistrar:registrar];
}
@end
