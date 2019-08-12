//
//  IDNowSDK.m
//  IDNowSDK
//
//  Created by Developer on 8/9/19.
//  Copyright © 2019 IDNowSDK. All rights reserved.
//

#import "IDNowSDKManager.h"
#import <React/RCTLog.h>
#import <IDnowSDK/IDnowSettings.h>
#import <IDnowSDK/IDnowController.h>

@interface  IDNowSDKManager() <IDnowControllerDelegate>

@property (strong, nonatomic) UIViewController      *rootController;
@property (strong, nonatomic) IDnowController *idnowController;
@property (strong, nonatomic) IDnowSettings      *settings;

@end

@implementation IDNowSDKManager

// To export a module named IDNowSDKManager
RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

// events
#define IDNowResultSUCCESS @"IDNowResultSUCCESS"
#define IDNowResultFINISHED @"IDNowResultFINISHED"
#define IDNowResultCANCELLED @"IDNowResultCANCELLED"
#define IDNowResultERROR @"IDNowResultERROR"

- (NSArray<NSString *> *)supportedEvents {
    return @[
             IDNowResultSUCCESS,
             IDNowResultFINISHED,
             IDNowResultCANCELLED,
             IDNowResultERROR,
             ];
}

- (void)setupIDNowSettings {
    
    // Set up and customize settings
    
    if (self.settings == NULL) {
        self.settings = [IDnowSettings new];
        self.settings.showErrorSuccessScreen = true;
        self.settings.showVideoOverviewCheck = true;
        self.settings.ignoreCompanyID        = true;
    }
    
    // Set up IDnowController
    self.idnowController = [[IDnowController alloc] initWithSettings: self.settings];
    
    self.rootController = UIApplication.sharedApplication.keyWindow.rootViewController;
}

RCT_EXPORT_METHOD(startVideoIdentification:(NSString *)companyID withToken:(NSString *)token)
{
    
    [self setupIDNowSettings];

    self.settings.transactionToken = token;
    self.settings.companyID = companyID;
    
    self.idnowController.delegate  = nil;
    __weak typeof(self) weakSelf   = self;
    
    // Initialize identification using blocks
    // (alternatively you can set the delegate and implement the IDnowControllerDelegate protocol)
    [self.idnowController initializeWithCompletionBlock: ^(BOOL success, NSError *error, BOOL canceledByUser)
    {
        if ( success )
        {
            // Start identification using blocks
            [weakSelf.idnowController startIdentificationFromViewController: self.rootController
                                               withCompletionBlock: ^(BOOL success, NSError *error, BOOL canceledByUser)
             {
                 if ( success )
                 {
                     // identification was successfull
                     [self sendEventWithName:IDNowResultSUCCESS body:weakSelf.idnowController];
                 }
                 else
                 {
                     [self sendEventWithName:IDNowResultCANCELLED body:error];
                 }
             }];
        }
        else if ( error )
        {
            [self sendEventWithName:IDNowResultERROR body:error];
        }
    }];
}

RCT_EXPORT_METHOD(startPhotoIdentification:(NSString *)companyID withToken:(NSString *)token)
{
    [self setupIDNowSettings];
    
    self.settings.transactionToken = token;
    self.settings.companyID = companyID;
    
    // This time we use the delegate instead of blocks (it's your choice)
    self.idnowController.delegate = self;
    
    // Initialize identification
    [self.idnowController initialize];
}

#pragma mark - IDnowControllerDelegate -

- (void)idnowController:(nonnull IDnowController *)idnowController initializationDidFailWithError:(nonnull NSError *)error {
    [self sendEventWithName:IDNowResultERROR body:error];
}

- (void)idnowControllerDidFinishInitializing:(nonnull IDnowController *)idnowController {
    
    // Initialization was successfull -> Start identification
    [self.idnowController startIdentificationFromViewController: self.rootController];
}

- (void) idnowControllerCanceledByUser: (IDnowController *) idnowController
{
    // The identification was canceled by the user.
    // For example the user tapped on the "x"-Button or simply navigates back.
    // Normally you don't have to do anything...
    
    [self sendEventWithName:IDNowResultCANCELLED body:idnowController];
}


- (void) idnowController: (IDnowController *) idnowController identificationDidFailWithError: (NSError *) error
{
    // Identification failed
    // If showErrorSuccessScreen (Settings) is disabled and error.type == IDnowErrorTypeIdentificationFailed
    // you can show for example an alert to your users.
    [self sendEventWithName:IDNowResultERROR body:error];
}


- (void) idnowControllerDidFinishIdentification: (IDnowController *) idnowController
{
    // Identification was successfull
    // If showErrorSuccessScreen (Settings) is disabled
    // you can show for example an alert to your users.
     [self sendEventWithName:IDNowResultSUCCESS body:idnowController];
}

@end
