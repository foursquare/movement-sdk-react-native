//  Copyright © 2023 Foursquare Labs. All rights reserved.

#import "RNMovementSdk.h"
#import <MovementSdk/MovementSdk.h>
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
    resolve([FSQMovementSdkManager sharedManager].installId);
}

RCT_EXPORT_METHOD(start) {
    [[FSQMovementSdkManager sharedManager] start];
}

RCT_EXPORT_METHOD(stop) {
    [[FSQMovementSdkManager sharedManager] stop];
}

RCT_REMAP_METHOD(getCurrentLocation,
                 getCurrentLocationWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    [[FSQMovementSdkManager sharedManager] getCurrentLocationWithCompletion:^(FSQCurrentLocation * _Nullable currentLocation, NSError * _Nullable error) {
        if (error) {
            reject(@"get_current_location", error.localizedDescription, error);
            return;
        }
        resolve(currentLocation.json);
    }];
}

RCT_EXPORT_METHOD(fireTestVisit:(double)latitude longitude:(double)longitude) {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [[FSQMovementSdkManager sharedManager].visitTester fireTestVisit:location];
}

RCT_EXPORT_METHOD(showDebugScreen) {
    [FSQMovementSdkManager sharedManager].debugLogsEnabled = YES;
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [[FSQMovementSdkManager sharedManager] presentDebugViewController:viewController];
}

RCT_REMAP_METHOD(isEnabled,
                 isEnabledWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    resolve(@([[FSQMovementSdkManager sharedManager] isEnabled]));
}

RCT_REMAP_METHOD(userInfo,
                 userInfoWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    resolve((NSDictionary *)[FSQMovementSdkManager sharedManager].userInfo.source);
}

RCT_EXPORT_METHOD(setUserInfo:(NSDictionary *)userInfo persisted:(BOOL)persisted) {
    [[FSQMovementSdkManager sharedManager] setUserInfo:[RCTConvert FSQUserInfo:userInfo] persisted:persisted];
}

@end

