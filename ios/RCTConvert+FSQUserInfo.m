//  Copyright © 2023 Foursquare. All rights reserved.

#import "RCTConvert+FSQUserInfo.h"
#import "FSQUserInfo+JSON.h"

@implementation RCTConvert (FSQUserInfo)

RCT_CUSTOM_CONVERTER(FSQUserInfo *, FSQUserInfo, [FSQUserInfo userInfoWithJSON:json])

@end
