//  Copyright © 2023 Foursquare. All rights reserved.

#import "FSQChain+JSON.h"

@implementation FSQChain (JSON)

- (NSDictionary *)json {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    jsonDict[@"id"] = self.foursquareID;
    jsonDict[@"name"] = self.name;
    return jsonDict;
}

@end
