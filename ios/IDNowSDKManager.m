//
//  IDNowSDK.m
//  IDNowSDK
//
//  Created by Developer on 8/9/19.
//  Copyright © 2019 IDNowSDK. All rights reserved.
//

#import "IDNowSDKManager.h"
#import <React/RCTLog.h>

@implementation IDNowSDKManager


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

// To export a module named IDNowSDKManager
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location) {
    RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
}

RCT_EXPORT_METHOD(startProcessWithToken:(NSString *)token andLanguage:(NSString *)lang)
{
    UIViewController* vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    IDNowSDK* sdk = [[IDNowSDK alloc] init];
    [sdk startWithToken:token
      preferredLanguage:lang
     fromViewController:vc
               listener:^(IdentResult result, NSString * _Nonnull message)
     {
         switch (result) {
             case IdentResultFINISHED:
                 [self sendEventWithName:IDNowResultFINISHED body:message];
                 
             case IdentResultCANCELLED:
                 [self sendEventWithName:IDNowResultCANCELLED body:message];
                 
             case IdentResultERROR:
                 [self sendEventWithName:IDNowResultERROR body:message];
         }
     }];
}

@end
