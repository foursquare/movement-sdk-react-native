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
    resolve([FSQMovementSdkManager shared].installId);
}

RCT_EXPORT_METHOD(start) {
    [[FSQMovementSdkManager shared] start];
}

RCT_EXPORT_METHOD(stop) {
    [[FSQMovementSdkManager shared] stop];
}

RCT_REMAP_METHOD(getCurrentLocation,
                 getCurrentLocationWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    [[FSQMovementSdkManager shared] getCurrentLocationWithCompletion:^(FSQCurrentLocation * _Nullable currentLocation, NSError * _Nullable error) {
        if (error) {
            reject(@"get_current_location", error.localizedDescription, error);
            return;
        }
        resolve(currentLocation.json);
    }];
}

RCT_EXPORT_METHOD(fireTestVisit:(double)latitude longitude:(double)longitude) {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [[FSQMovementSdkManager shared].visitTester fireTestVisitWithLocation:location];
}

RCT_EXPORT_METHOD(showDebugScreen) {
    [FSQMovementSdkManager shared].isDebugLogsEnabled = YES;
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (@available(iOS 14.0, *)) {
        [[FSQMovementSdkManager shared] presentDebugViewControllerWithParentViewController:viewController];
    }
}

RCT_REMAP_METHOD(isEnabled,
                 isEnabledWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    resolve(@([[FSQMovementSdkManager shared] isEnabled]));
}

RCT_REMAP_METHOD(userInfo,
                 userInfoWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    resolve((NSDictionary *)[FSQMovementSdkManager shared].userInfo.source);
}

RCT_EXPORT_METHOD(setUserInfo:(NSDictionary *)userInfo persisted:(BOOL)persisted) {
    [[FSQMovementSdkManager shared] setUserInfo:[RCTConvert FSQUserInfo:userInfo] persisted:persisted];
}

@end

