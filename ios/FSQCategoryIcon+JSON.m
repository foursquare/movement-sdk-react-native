//  Copyright © 2023 Foursquare. All rights reserved.

#import "FSQCategoryIcon+JSON.h"

@implementation FSQCategoryIcon (JSON)

- (NSDictionary *)json {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    jsonDict[@"prefix"] = self.prefix;
    jsonDict[@"suffix"] = self.suffix;
    return jsonDict;
}

@end
