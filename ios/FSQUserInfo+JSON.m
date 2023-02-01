//  Copyright © 2023 Foursquare. All rights reserved.

#import "FSQUserInfo+JSON.h"

@implementation FSQUserInfo(JSON)

+ (instancetype)userInfoWithJSON:(id)json
{
    FSQUserInfo *userInfo = [[FSQUserInfo alloc] init];
    for (NSString *key in json) {
        if ([key isEqualToString:@"userId"] ||
            [key isEqualToString:@"gender"] ||
            [key isEqualToString:@"birthday"]) {
            [userInfo setUserId:json[key]];
        } else {
            [userInfo setUserInfo:json[key] forKey:key];
        }
    }
    return userInfo;
}

@end
