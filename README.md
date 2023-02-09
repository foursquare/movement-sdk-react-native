# Movement SDK React Native module

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/foursquare/movement-sdk-react-native/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/foursquare/movement-sdk-react-native/tree/main)

## Table of Contents

- [Installing](#installing)
- [Usage](#usage)
  - [Application Setup](#application-setup)
  - [Getting User's Current Location](#getting-users-current-location)
  - [Passive Location Detection](#passive-location-detection)
  - [Debug Screen](#debug-screen)
  - [Test Visits](#test-visits)
- [Samples](#samples)
- [FAQ](#faq)

## Installing

1. Install module

   npm

   ```bash
   npm install @foursquare/movement-sdk-react-native
   ```

   Yarn

   ```bash
   yarn add @foursquare/movement-sdk-react-native
   ```

2. Link native code with [autolinking](https://github.com/react-native-community/cli/blob/master/docs/autolinking.md)

   ```bash
   cd ios && pod install && cd ..
   ```

## Usage

### Application Setup

#### iOS Setup

1. You must call `[[FSQMovementSdkManager sharedManager] configureWithConsumerKey:secret:delegate:completion:]` from `application:didFinishLaunchingWithOptions` in a your application delegate, for example:

```objc
// AppDelegate.m
#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <Movement/Movement.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [[FSQMovementSdkManager sharedManager] configureWithConsumerKey:@"CONSUMER_KEY"
                                                           secret:@"CONSUMER_SECRET"
                                                         delegate:nil
                                                       completion:nil];


  // Other react native initialization code

  return YES;
}

...

@end

```
> Don't forget to use your actual `CONSUMER_KEY` and `CONSUMER_SECRET`, which can be retrieved from your [Foursquare Developer Console](https://foursquare.com/developers/apps).

This allows the SDK to run in the background and send you visit notifications, even when your iOS app isn't open.

2. Ensure the `CFBundleIdentifier` of your project's `Info.plist` is correctly added to your Foursquare [Developer Console](https://foursquare.com/developers/apps/) app's iOS Bundle IDs setting. For more details on how to set this up, please refer to Pilgrim's [iOS Getting Started Guide](https://location.foursquare.com/developer/docs/ios-getting-started#1-register-app-bundle-id).

#### Android Setup

1. You must call `MovementSdk.with(MovementSdk.Builder)` from `onCreate` in a your `android.app.Application` subclass, for example:

```java
// MainApplication.java
import android.app.Application;
import com.facebook.react.ReactApplication;
import com.foursquare.movement.MovementSdk;

public class MainApplication extends Application implements ReactApplication {

    @Override
  public void onCreate() {
    super.onCreate();

    MovementSdk.Builder builder = new MovementSdk.Builder(this)
            .consumer("CONSUMER_KEY", "CONSUMER_SECRET")
            .enableDebugLogs();
    MovementSdk.with(builder);

    // Other react native initialization code
  }

  ...

}
```
> Don't forget to use your actual `CONSUMER_KEY` and `CONSUMER_SECRET`, which can be retrieved from your [Foursquare Developer Console](https://foursquare.com/developers/apps).

This allows Pilgrim to run in the background and send you visit notifications, even when your Android app isn't open.

2. In `android/app/build.gradle` modify the `signingConfigs` section to use your keystore file and ensure the `storePassword`, `keyAlias`, and `keyPassword` are set correctly:
```text
signingConfigs {
     debug {
       storeFile file('/path/to/file.keystore')
       storePassword 'storePassword'
       keyAlias 'keyAlias'
       keyPassword 'keyPassword'
     }
   }
```

3. Ensure the `SHA1` key hash of your project is correctly added to your Foursquare [Developer Console](https://foursquare.com/developers/apps/) app's Android Key Hashes setting. For more details on how to set this up, please refer to Pilgrim's [Android Getting Started Guide](https://location.foursquare.com/developer/docs/android-getting-started#1-register-your-apps-key-hashes).

### Get User's Install ID

Each time the SDK is installed on a user's device, it creates a unique `installId`. The returned value will be a `Promise<string>`. This can be used to allow your users to submit [Data Erasure Requests](https://location.foursquare.com/developer/reference/erasure) or for debugging in our [Event Logs](https://location.foursquare.com/developer/docs/view-sdk-event-logs) tool in your developer console. Example usage:

```javascript
import MovementSdk from '@foursquare/movement-sdk-react-native';
import React, {useState, useEffect} from 'react';
import {Text} from 'react-native';

export default () => {
  const [installId, setInstallId] = useState('-');

  useEffect(() => {
    (async () => {
      setInstallId(await MovementSdk.getInstallId());
    })();
  });

  return (
    <React.Fragment>
      <Text>Install ID: {installId}</Text>
    </React.Fragment>
  );
};

```

### Getting User's Current Location

You can actively request the current location of the user by calling the `MovementSdk.getCurrentLocation` method. The return value will be a `Promise<CurrentLocation>`. The `CurrentLocation` object has the current venue the device is most likely at as well as any geofences that the device is in (if configured). Find more information [for Android](https://location.foursquare.com/developer/docs/movement-sdk-android-add-features#get-current-location) and [for iOS](https://location.foursquare.com/developer/docs/movement-sdk-ios-add-features#get-current-location). Example usage below:

```javascript
import MovementSdk, {
  CurrentLocation,
} from '@foursquare/movement-sdk-react-native';
import React, {useEffect, useState} from 'react';
import {Alert, Text} from 'react-native';

export default () => {
  const [currentLocation, setCurrentLocation] = useState<CurrentLocation>();

  useEffect(() => {
    async () => {
      try {
        setCurrentLocation(await MovementSdk.getCurrentLocation());
      } catch (e) {
        Alert.alert('Movement SDK', `${e}`);
      }
    };
  });

  if (currentLocation != null) {
    const venue = currentLocation.currentPlace.venue;
    const venueName = venue?.name || 'Unnamed venue';
    return (
      <React.Fragment>
        <Text>Venue: {venueName}</Text>
      </React.Fragment>
    );
  } else {
    return (
      <React.Fragment>
        <Text>Loading...</Text>
      </React.Fragment>
    );
  }
};

```

### Passive Location Detection

Passive location detection is controlled with the `MovementSdk.start` and `MovementSdk.stop` methods. When started Movement SDK will send notifications to [Webhooks](https://developer.foursquare.com/docs/pilgrim-sdk/webhooks) and other [third-party integrations](https://developer.foursquare.com/docs/pilgrim-sdk/integrations). Example usage below:

```javascript
import {Alert, Button} from 'react-native';
import MovementSdk from '@foursquare/movement-sdk-react-native';
import React from 'react';

export default () => {
  const startMovement = async function () {
    const canEnable = await MovementSdk.isEnabled();
    if (canEnable) {
      MovementSdk.start();
      Alert.alert('Movement SDK', 'Movement SDK started');
    } else {
      Alert.alert('Movement SDK', 'Error starting');
    }
  };

  const stopMovement = function () {
    MovementSdk.stop();
    Alert.alert('Movement SDK', 'Movement SDK stopped');
  };

  return (
    <React.Fragment>
      <Button title="Start" onPress={() => startMovement()} />
      <Button title="Stop" onPress={() => stopMovement()}
      />
    </React.Fragment>
  );
};
```

### Debug Screen

The debug screen is shown using the `MovementSdk.showDebugScreen` method. This screen contains logs sent from the Movement SDK and other debugging tools/information. Example usage below:

```javascript
import React, {Component} from 'react';
import {Button} from 'react-native';
import MovementSdk from '@foursquare/movement-sdk-react-native';

export default () => {
  const showDebugScreen = function () {
    MovementSdk.showDebugScreen();
  };

  return (
    <React.Fragment>
      <Button title="Show Debug Screen" onPress={() => showDebugScreen()} />
    </React.Fragment>
  );
};

```

### Test Visits

Test arrival visits can be fired with the method `MovementSdk.fireTestVisit`. You must pass a location to be used for the test visit. The arrival notification will be received via [Webhooks](https://developer.foursquare.com/docs/pilgrim-sdk/webhooks) and other [third-party integrations](https://developer.foursquare.com/docs/pilgrim-sdk/integrations)

```javascript
import React from 'react';
import {Alert, Button} from 'react-native';
import MovementSdk from '@foursquare/movement-sdk-react-native';

export default () => {
  const fireTestVisit = async function () {
    navigator.geolocation.getCurrentPosition(
      position => {
        const latitude = position.coords.latitude;
        const longitude = position.coords.longitude;
        MovementSdk.fireTestVisit(latitude, longitude);
        Alert.alert(
          'Movement SDK',
          `Sent test visit with location: (${latitude},${longitude})`,
        );
      },
      err => {
        Alert.alert('Movement SDK', `${err}`);
      },
    );
  };

  return (
    <React.Fragment>
      <Button title="Fire Test Visit" onPress={() => fireTestVisit()} />
    </React.Fragment>
  );
};

```

### User Info

For partners utilizing the server-to-server method for visit notifications, user info can be passed with the method `MovementSdk.setUserInfo`.

```javascript
import MovementSdk, {
  UserInfoUserIdKey,
  UserInfoGenderKey,
  UserInfoBirthdayKey,
  UserInfoGenderMale,
} from '@foursquare/movement-sdk-react-native';
import {useEffect} from 'react';

export default () => {
  useEffect(() => {
    (async () => {
      MovementSdk.setUserInfo(
        {
          [UserInfoUserIdKey]: 'userId',
          [UserInfoGenderKey]: UserInfoGenderMale,
          [UserInfoBirthdayKey]: new Date(2000, 0, 1).getTime(),
          otherKey: 'otherVal',
        },
        true,
      );
    })();
  }, []);
};

```

## Samples

- [React Native Movement SDK Sample App](https://github.com/foursquare/RNMovementSample) - Basic application using movement-sdk-react-native

## FAQ

Consult Movement SDK documentation [here](https://location.foursquare.com/developer/docs/movement-sdk-faqs)
