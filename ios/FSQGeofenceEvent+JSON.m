//  Copyright © 2023 Foursquare. All rights reserved.

#import "FSQGeofenceEvent+JSON.h"
#import "CLLocation+JSON.h"
#import "FSQVenue+JSON.h"

@implementation FSQGeofenceEvent (JSON)

- (NSDictionary *)json {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    jsonDict[@"geofenceId"] = self.geofenceId;
    jsonDict[@"name"] = self.name;

    if (self.venue != nil) {
        FSQVenue *venue = self.venue;
        jsonDict[@"venueId"] = venue.venueId;
        jsonDict[@"venue"] = [self.venue json];
    }

    if (self.partnerVenueId) {
        jsonDict[@"partnerVenueId"] = self.partnerVenueId;
    }

    jsonDict[@"location"] = [self.location json];
    jsonDict[@"timestamp"] = @(self.timestamp.timeIntervalSince1970);
    return jsonDict;
}

@end
