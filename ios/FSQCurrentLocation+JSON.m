//  Copyright © 2023 Foursquare. All rights reserved.

#import "FSQCurrentLocation+JSON.h"
#import "FSQGeofenceEvent+JSON.h"
#import "FSQVisit+JSON.h"

@implementation FSQCurrentLocation (JSON)

- (NSDictionary *)json {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    jsonDict[@"currentPlace"] = [self.currentPlace json];

    NSMutableArray *geofences = [NSMutableArray array];
    for (FSQGeofenceEvent *event in self.matchedGeofences) {
        [geofences addObject:[event json]];
    }
    jsonDict[@"matchedGeofences"] = geofences;

    return jsonDict;
}

@end
