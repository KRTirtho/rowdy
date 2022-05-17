#import "RowdyPlugin.h"
#if __has_include(<rowdy/rowdy-Swift.h>)
#import <rowdy/rowdy-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "rowdy-Swift.h"
#endif

@implementation RowdyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRowdyPlugin registerWithRegistrar:registrar];
}
@end
