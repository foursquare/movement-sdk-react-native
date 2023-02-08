//  Copyright © 2023 Foursquare. All rights reserved.

#import "RCTConvert.h"
#import <MovementSdk/MovementSdk.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTConvert (FSQUserInfo)

+ (FSQUserInfo *)FSQUserInfo:(id)json;

@end

NS_ASSUME_NONNULL_END
