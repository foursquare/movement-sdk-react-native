//  Copyright © 2023 Foursquare. All rights reserved.

#import "FSQUserInfo+JSON.h"

@implementation FSQUserInfo(JSON)

+ (instancetype)userInfoWithJSON:(id)json
{
    FSQUserInfo *userInfo = [[FSQUserInfo alloc] init];
    for (NSString *key in json) {
        if ([key isEqualToString:@"userId"]) {
            [userInfo setUserId:json[key]];
        } else if ([key isEqualToString:@"gender"]) {
            [userInfo setGender:json[key]];
        } else if ([key isEqualToString:@"birthday"]) {
            [userInfo setBirthday:json[key]];
        } else {
            [userInfo setUserInfo:json[key] forKey:key];
        }
    }
    return userInfo;
}

@end
