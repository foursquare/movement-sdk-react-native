//  Copyright © 2023 Foursquare Labs. All rights reserved.

#import "RNMovementSdk.h"
#import <Movement/Movement.h>
#import "FSQCurrentLocation+JSON.h"
#import "RCTConvert+FSQUserInfo.h"

@implementation RNMovementSdk

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_REMAP_METHOD(getInstallId,
                 getInstallIdWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    resolve([FSQMovementManager sharedManager].installId);
}

RCT_EXPORT_METHOD(start) {
    [[FSQMovementManager sharedManager] start];
}

RCT_EXPORT_METHOD(stop) {
    [[FSQMovementManager sharedManager] stop];
}

RCT_REMAP_METHOD(getCurrentLocation,
                 getCurrentLocationWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    [[FSQMovementManager sharedManager] getCurrentLocationWithCompletion:^(FSQCurrentLocation * _Nullable currentLocation, NSError * _Nullable error) {
        if (error) {
            reject(@"get_current_location", error.localizedDescription, error);
            return;
        }
        resolve(currentLocation.json);
    }];
}

RCT_EXPORT_METHOD(fireTestVisit:(double)latitude longitude:(double)longitude) {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [[FSQMovementManager sharedManager].visitTester fireTestVisit:location];
}

RCT_EXPORT_METHOD(showDebugScreen) {
    [FSQMovementManager sharedManager].debugLogsEnabled = YES;
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [[FSQMovementManager sharedManager] presentDebugViewController:viewController];
}

RCT_REMAP_METHOD(isEnabled,
                 isEnabledWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    resolve(@([[FSQMovementManager sharedManager] isEnabled]));
}

RCT_REMAP_METHOD(userInfo,
                 userInfoWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    resolve((NSDictionary *)[FSQMovementManager sharedManager].userInfo.source);
}

RCT_EXPORT_METHOD(setUserInfo:(NSDictionary *)userInfoDict persisted:(BOOL)persisted) {
    [[FSQMovementManager sharedManager] setUserInfo:[RCTConvert FSQUserInfo:userInfoDict] persisted:persisted];
}

@end

