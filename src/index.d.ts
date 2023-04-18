export interface Location {
  latitude: number
  longitude: number
}

/**
 * An object representing an interaction with one or more registered geofence radii.
 */
export interface GeofenceEvent {
  geofenceId: string
  name: string
  venueId?: string
  venue?: Venue
  partnerVenueId?: string
  location: Location
  timestamp: number
}

/**
 * Foursquare location object for a venue.
 */
export interface LocationInformation {
  address?: string
  crossStreet?: string
  city?: string
  state?: string
  postalCode?: string
  country?: string
  location?: Location
}

/**
 * Foursquare representation of a chain of venues, i.e. Starbucks.
 */
export interface Chain {
  id: string
  name: string
}

/**
 * Foursquare category for a venue.
 */
export interface Category {
  id: string
  name: string
  pluralName?: string
  shortName?: string
  icon?: CategoryIcon
  isPrimary: boolean
}

/**
 * The icon image information for a category.
 */
export interface CategoryIcon {
  prefix: string
  suffix: string
}

/**
 * Representation of a venue in the Foursquare Places database.
 */
export interface Venue {
  id: string
  name: string
  locationInformation?: LocationInformation
  partnerVenueId?: string
  probability?: number
  chains: [Chain]
  categories: [Category]
  hierarchy: [VenueParent]
}

export interface VenueParent {
  id: string
  name: string
  categories: [Category]
}

/**
 * Everything the Movement SDK knows about a user's location, including raw data and a probable venue.
 */
export interface Visit {
  location?: Location
  locationType: number
  confidence: number
  arrivalTime?: number
  venue?: Venue
  otherPossibleVenues?: [Venue]
}

/**
 * An object representing the current location of the user.
 */
export interface CurrentLocation {
  currentPlace: Visit
  matchedGeofences: [GeofenceEvent]
}

export declare const UserInfoUserIdKey: string // value is string
export declare const UserInfoGenderKey: string // value is string
export declare const UserInfoBirthdayKey: string // value is number

export declare const UserInfoGenderMale: string
export declare const UserInfoGenderFemale: string
export declare const UserInfoGenderNotSpecified: string

export type UserInfo = { [key: string]: string | number }

export interface MovementSdk {
  /**
   * Returns a unique identifier that gets generated the first time this sdk runs on a specific device.
   */
  getInstallId(): Promise<string>

  /**
   * Call this after configuring the SDK to start the SDK and begin receiving location updates.
   * */
  start(): void

  /**
   * Stop receiving location updates, until you call `start` again.
   */
  stop(): void

  /**
   * Gets the current location of the user.
   * This includes possibly a visit and and an array of geofences.
   */
  getCurrentLocation(): Promise<CurrentLocation>

  /**
   * Generates a visit and optional nearby venues at the given location.
   *
   * @param latitude location latitude
   * @param longitude location longitude
   */
  fireTestVisit(latitude: number, longitude: number): void

  /**
   * Initializes a debug mode view controller for viewing Movement SDK logs and presents it.
   */
  showDebugScreen(): void

  /**
   * Is Movement SDK currently enabled.
   */
  isEnabled(): Promise<boolean>

  /**
   * For applications utilizing the server-to-server method for visit notifications,
   * you can use this to pass through your own identifier to the notification endpoint call.
   */
  userInfo(): Promise<UserInfo>

  /**
   * For applications utilizing the server-to-server method for visit notifications,
   * you can use this to pass through your own identifier to the notification endpoint call.
   *
   * @param persisted Set to true to persist the user info data.
   */
  setUserInfo(userInfo: UserInfo, persisted: boolean): void
}

declare let MovementSdk: MovementSdk
export default MovementSdk
