//  Copyright © 2023 Foursquare. All rights reserved.

#import "FSQVenue+JSON.h"
#import "FSQCategory+JSON.h"
#import "FSQChain+JSON.h"

@implementation FSQVenue (JSON)

- (NSDictionary *)json {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];

    jsonDict[@"id"] = self.foursquareID;
    jsonDict[@"name"] = self.name;

    if (self.locationInformation) {
        NSMutableDictionary *locationInformationDict = [NSMutableDictionary dictionary];

        if (self.locationInformation.address) {
            locationInformationDict[@"address"] = self.locationInformation.address;
        }
        if (self.locationInformation.crossStreet) {
            locationInformationDict[@"crossStreet"] = self.locationInformation.crossStreet;
        }
        if (self.locationInformation.city) {
            locationInformationDict[@"city"] = self.locationInformation.city;
        }
        if (self.locationInformation.state) {
            locationInformationDict[@"state"] = self.locationInformation.state;
        }
        if (self.locationInformation.postalCode) {
            locationInformationDict[@"postalCode"] = self.locationInformation.postalCode;
        }
        if (self.locationInformation.country) {
            locationInformationDict[@"country"] = self.locationInformation.country;
        }
        locationInformationDict[@"location"] = @{@"latitude": @(self.locationInformation.coordinate.latitude),
                                                 @"longitude": @(self.locationInformation.coordinate.longitude)};

        jsonDict[@"locationInformation"] = locationInformationDict;
    }

    if (self.partnerVenueId) {
        jsonDict[@"partnerVenueId"] = self.partnerVenueId;
    }

    if (self.probability) {
        jsonDict[@"probability"] = self.probability;
    }

    NSMutableArray *chainsArray = [NSMutableArray array];
    for (FSQChain *chain in self.chains) {
        [chainsArray addObject:[chain json]];
    }
    jsonDict[@"chains"] = chainsArray;

    jsonDict[@"categories"] = [FSQVenue categoriesArrayJson:self.categories];

    NSMutableArray *hierarchyArray = [NSMutableArray array];
    for (FSQVenue *venueParent in self.hierarchy) {
        NSMutableDictionary *venueParentDict = [NSMutableDictionary dictionary];
        venueParentDict[@"id"] = venueParent.foursquareID;
        venueParentDict[@"name"] = venueParent.name;
        venueParentDict[@"categories"] = [FSQVenue categoriesArrayJson:venueParent.categories];
    }
    jsonDict[@"hierarchy"] = hierarchyArray;

    return jsonDict;
}

+ (NSArray<NSDictionary *> *)categoriesArrayJson:(NSArray<FSQCategory *> *)categories {
    NSMutableArray *categoriesArray = [NSMutableArray array];
    for (FSQCategory *category in categories) {
        [categoriesArray addObject:[category json]];
    }
    return categoriesArray;
}

@end
