package com.foursquare.movement.react

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.foursquare.api.FoursquareLocation
import com.foursquare.api.types.Category
import com.foursquare.api.types.Photo
import com.foursquare.api.types.Venue
import com.foursquare.api.types.geofence.GeofenceEvent
import com.foursquare.movement.Confidence
import com.foursquare.movement.CurrentLocation
import com.foursquare.movement.LocationType
import com.foursquare.movement.Visit

internal object Utils {
    fun currentLocationJson(currentLocation: CurrentLocation): WritableMap =
        Arguments.createMap().apply {
            putMap("currentPlace", visitJson(currentLocation.currentPlace))
            putArray("matchedGeofences", Arguments.createArray().apply {
                for (event in currentLocation.matchedGeofences) {
                    pushMap(geofenceEventJson(event))
                }
            })
        }

    private fun visitJson(visit: Visit) = Arguments.createMap().apply {
        putMap("location", foursquareLocationJson(visit.location))
        val locationType = when (visit.getType()) {
            LocationType.HOME -> 1
            LocationType.WORK -> 2
            LocationType.VENUE -> 3
            else -> 0
        }
        putInt("locationType", locationType)
        val confidence = when (visit.getConfidence()) {
            Confidence.LOW -> 1
            Confidence.MEDIUM -> 2
            Confidence.HIGH -> 3
            else -> 0
        }
        putInt("confidence", confidence)
        putDouble("arrivalTime", (visit.arrival / 1000).toDouble())
        visit.getVenue()?.let { putMap("venue", venueJson(it)) }
        putArray("otherPossibleVenues", Arguments.createArray().apply {
            for (venue in visit.getOtherPossibleVenues()) {
                pushMap(venueJson(venue))
            }
        })
    }

    private fun geofenceEventJson(geofenceEvent: GeofenceEvent) = Arguments.createMap().apply {
        putString("id", geofenceEvent.id)
        putString("name", geofenceEvent.name)
        geofenceEvent.venue?.let {
            geofenceEvent.venue
            putString("name", it.name)
            putString("venueId", it.id)
            putMap("venue", venueJson(it))
        }
        geofenceEvent.partnerVenueId?.let { putString("partnerVenueId", it) }
        putMap("location", locationJson(geofenceEvent.lat, geofenceEvent.lng))
        putDouble("timestamp", (geofenceEvent.timestamp / 1000).toDouble())
    }

    private fun chainJson(chain: Venue.VenueChain) = Arguments.createMap().apply {
        putString("id", chain.id)
        putString("name", chain.name)
    }

    private fun chainsArrayJson(chains: List<Venue.VenueChain>) = Arguments.createArray().apply {
        for (chain in chains) {
            pushMap(chainJson(chain))
        }
    }

    private fun categoryArrayJson(categories: List<Category>) = Arguments.createArray().apply {
        for (category in categories) {
            pushMap(categoryJson(category))
        }
    }

    private fun categoryJson(category: Category) = Arguments.createMap().apply {
        putString("id", category.id)
        putString("name", category.name)
        category.pluralName?.let { putString("pluralName", it) }
        category.shortName?.let { putString("shortName", category.shortName) }
        category.image?.let { putMap("icon", categoryIconJson(it)) }
        putBoolean("isPrimary", category.isPrimary)
    }

    private fun categoryIconJson(photo: Photo) = Arguments.createMap().apply {
        putString("prefix", photo.prefix)
        putString("suffix", photo.suffix)
    }

    private fun hierarchyJson(hierarchy: List<Venue.VenueParent>) = Arguments.createArray().apply {
        for (parent in hierarchy) {
            pushMap(Arguments.createMap().apply {
                putString("id", parent.id)
                putString("name", parent.name)
                putArray("categories", categoryArrayJson(parent.categories))
            })
        }
    }

    private fun venueJson(venue: Venue) = Arguments.createMap().apply {
        putString("id", venue.id)
        putString("name", venue.name)
        putMap("locationInformation", venueLocationJson(venue.location))
        if (venue.partnerVenueId != null) {
            putString("partnerVenueId", venue.partnerVenueId)
        }
        putDouble("probability", venue.probability)
        putArray("chains", chainsArrayJson(venue.venueChains))
        putArray("categories", categoryArrayJson(venue.categories))
        putArray("hierarchy", hierarchyJson(venue.hierarchy))
    }

    private fun venueLocationJson(venueLocation: Venue.Location) = Arguments.createMap().apply {
        venueLocation.address?.let { putString("address", it) }
        venueLocation.crossStreet?.let { putString("crossStreet", it) }
        venueLocation.city?.let { putString("city", it) }
        venueLocation.state?.let { putString("state", it) }
        venueLocation.postalCode?.let { putString("postalCode", it) }
        venueLocation.country?.let { putString("country", it) }
        putMap("location", locationJson(venueLocation.lat, venueLocation.lng))
    }

    private fun foursquareLocationJson(foursquareLocation: FoursquareLocation) =
        locationJson(foursquareLocation.lat, foursquareLocation.lng)


    private fun locationJson(lat: Double, lng: Double) = Arguments.createMap().apply {
        putDouble("latitude", lat)
        putDouble("longitude", lng)
    }
}
