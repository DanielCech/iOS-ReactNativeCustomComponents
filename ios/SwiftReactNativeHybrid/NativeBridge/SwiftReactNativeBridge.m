//
//  SwiftReactNativeBridge.m
//  SwiftReactNativeHybrid
//
//  Created by Dan on 2017-06-13.
//  Copyright (c) 2017 STRV. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(NativeModuleCallSwift, NSObject)

// Type 1: Calling a Swift function from JavaScript
RCT_EXTERN_METHOD(helloSwift:(NSString *)greeting)
RCT_EXTERN_METHOD(clearSignature)
@end



// Type 2: Calling a Swift function with a callback
@interface RCT_EXTERN_MODULE(NativeModuleJavaScriptCallback, NSObject)

RCT_EXTERN_METHOD(scanBarcode:(RCTResponseSenderBlock *)callback)
RCT_EXTERN_METHOD(takePatientPhoto:(RCTResponseSenderBlock *)callback)
RCT_EXTERN_METHOD(scanIDCard:(RCTResponseSenderBlock *)callback)
RCT_EXTERN_METHOD(scanDoctorReferenceLetter:(RCTResponseSenderBlock *)callback)

@end


//Type 3: Broadcasting data from Swift and listening in JavaScript
@interface RCT_EXTERN_MODULE(NativeModuleBroadcastToJavaScript, RCTEventEmitter)
@end



