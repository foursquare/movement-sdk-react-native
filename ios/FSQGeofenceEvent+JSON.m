//  Copyright © 2023 Foursquare. All rights reserved.

#import "FSQGeofenceEvent+JSON.h"
#import "CLLocation+JSON.h"
#import "FSQVenue+JSON.h"

@implementation FSQGeofenceEvent (JSON)

- (NSDictionary *)json {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    jsonDict[@"id"] = self.geofenceID;
    jsonDict[@"name"] = self.name;

    if (self.venue != nil) {
        FSQVenue *venue = self.venue;
        jsonDict[@"venueId"] = venue.foursquareID;
        jsonDict[@"venue"] = [self.venue json];
    }

    if (self.partnerVenueID) {
        jsonDict[@"partnerVenueId"] = self.partnerVenueID;
    }

    jsonDict[@"location"] = [self.location json];
    jsonDict[@"timestamp"] = @(self.timestamp.timeIntervalSince1970);
    return jsonDict;
}

@end
