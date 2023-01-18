//  Copyright © 2023 Foursquare. All rights reserved.

#import "FSQCategory+JSON.h"
#import "FSQCategoryIcon+JSON.h"

@implementation FSQCategory (JSON)

- (NSDictionary *)json {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    jsonDict[@"id"] = self.foursquareID;
    jsonDict[@"name"] = self.name;

    if (self.pluralName) {
        jsonDict[@"pluralName"] = self.pluralName;
    }

    if (self.shortName) {
        jsonDict[@"shortName"] = self.shortName;
    }

    if (self.icon) {
        jsonDict[@"icon"] = [self.icon json];
    }

    jsonDict[@"isPrimary"] = @(self.isPrimary);

    return jsonDict;
}

@end
