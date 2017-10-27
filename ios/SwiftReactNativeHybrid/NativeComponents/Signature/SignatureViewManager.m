//  SignatureViewManager.h
//  treez
//
//  Created by Dan on 09.10.2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <React/RCTUIManager.h>

#import "SignatureViewManager.h"
#import "SwiftReactNativeHybrid-Swift.h"

@implementation SignatureViewManager

RCT_EXPORT_MODULE()

- (UIView *)view {
  return [[SignatureView alloc] init];
}

RCT_EXPORT_METHOD(clearSignature:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry){
         UIView *view = viewRegistry[reactTag];
         if ([view isKindOfClass:[SignatureView class]]) {
             [(SignatureView*)view clearSignature];
         } else {
             RCTLogError(@"Unable to access SignatureView");
         }
     }];
}

RCT_EXPORT_METHOD(getSignature:(nonnull NSNumber *)reactTag
                  callback:(RCTResponseSenderBlock)callback)
{
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         UIView *view = viewRegistry[reactTag];
         if ([view isKindOfClass:[SignatureView class]]) {
             [(SignatureView*)view getSignature:callback];
         } else {
             RCTLogError(@"Unable to access SignatureView");
         }
     }];
}



@end
