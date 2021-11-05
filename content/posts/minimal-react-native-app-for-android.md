+++
title = "A Minimal React Native App for Android"
author = ["Krishan Wyse"]
publishDate = 2020-04-12T00:00:00+01:00
tags = ["softdev", "appdev"]
categories = ["softdev"]
draft = false
+++

Generators that build seed applications for you from templates appear to be the
norm among front-end ecosystems.  A recent foray into app develop prompted me to
check out React Native.  Right from the start, the documentation recommends
creating a project from a generator — and the project it creates is big.  It
then doesn't go on to explain what each of the individual files are doing.

I'm not a fan of this approach.  I decided to create a new project from scratch
and try to get it working in an Android emulator.  This post follows that
journey.

This app will not be ready for production.  It is intended to be the starting
point from which you can add what you need, when you need it.  The goal here is
to get something running.


## Creating a React Native application {#creating-a-react-native-application}

A minimal React Native application is simple.  The hard part was getting it
running on Android, but we will get to that later.  The React Native application
itself is just four files:

-   `App.json`
-   `app.js`
-   `index.js`
-   `package.json`

Starting with `package.json`, since that manages the packages, include React and
React Native, and with appropriate versions:

```json
{
  "dependencies": {
    "react": "16.11",
    "react-native": "0.62"
  }
}
```

The two files above it are necessary just to get things working.  `index.js`
must register the application:

```javascript
import { AppRegistry } from 'react-native';
import App from './App';
import { name as appName } from './app.json';

AppRegistry.registerComponent(appName, () => App);
```

`app.json` need only include the name of the application:

```json
{
  "name": "MyMinimalApp"
}
```

The final file is the interesting one.  This is where the layout logic lives.

```jsx
import React from 'react';
import { Text, View } from 'react-native';

export default function App() {
  return (
    <View style={{
	flex: 1,
	alignItems: 'center',
	justifyContent: 'center'
    }}>
      <Text>Hello, world!</Text>
    </View>
  );
}
```

If you're curious about the odd HTML-like syntax, that's [JSX](https://reactjs.org/docs/jsx-in-depth.html). JSX simply
provides syntactic sugar to covert those tags into Javascript functions.  If
you're curious about the meanings of the tags themselves, check out the [API
docs](https://reactnative.dev/docs/components-and-apis).


## Creating the Android component {#creating-the-android-component}

In order to run this on Android, a valid Android project must be created in a
sub-directory called `android` in the root of the project.  A valid Android
project is composed of numerous files.

First we have the core Java files that comprise of the application itself.

-   `app/src/main/java/com/myminimalapp/MainActivity.java`
-   `app/src/main/java/com/myminimalapp/MainApplication.java`

We also have the Android manifest file used by the build tools and the Android
operating system, as well as the styles file used to declare the app theme in
the manifest.

-   `app/src/main/AndroidManifest.xml`
-   `app/src/main/res/values/styles.xml`

And finally, we have the Gradle files used to build the project.  I've only
included the Unix-specific `gradlew` file here, but on Windows you would have a
`gradlew.bat` file.  These files serve as wrappers for Gradle so that it can be
executed without installation on the local machine.

-   `build.gradle`
-   `gradlew`
-   `settings.gradle`
-   `app/build.gradle`

The first Java class, `MainActivity`, has little boilerplate needed.

```java
package com.myminimalapp;

import com.facebook.react.ReactActivity;

public class MainActivity extends ReactActivity {
    @Override
    protected String getMainComponentName() {
	return "MyMinimalApp";
    }
}
```

The name of the main component of the application must be stated so that React
Native knows which component it must render.

The second Java file, `MainApplication`, must implement the one method of
`ReactApplication`.

```java
package com.myminimalapp;

import android.app.Application;
import com.facebook.react.PackageList;
import com.facebook.react.ReactApplication;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;

import java.util.List;

public class MainApplication extends Application implements ReactApplication {
    @Override
    public ReactNativeHost getReactNativeHost() {
	return new ReactNativeHost(this) {
	    @Override
	    public boolean getUseDeveloperSupport() {
		return BuildConfig.DEBUG;
	    }

	    @Override
	    protected List<ReactPackage> getPackages() {
		return new PackageList(this).getPackages();
	    }

	    @Override
	    protected String getJSMainModuleName() {
		return "index";
	    }
	};
    }
}
```

`ReactNativeHost` has two abstract methods that must be implemented.  The final
method, `getJSMainModuleName()`, must be overridden so that the correct
Javascript file is executed on startup.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.myminimalapp">
  <uses-permission android:name="android.permission.INTERNET" />
  <application
    android:name=".MainApplication"
    android:usesCleartextTraffic="true"
    android:theme="@style/AppTheme">
    <activity
      android:name=".MainActivity"
      android:windowSoftInputMode="adjustResize">
      <intent-filter>
	<action android:name="android.intent.action.MAIN" />
      </intent-filter>
    </activity>
  </application>
</manifest>
```

`AndroidManifest.xml` points to our `MainActivity` and `MainApplication`
classes, sets the app theme, declares necessary permissions, and specifies the
core behaviour on startup.  `android:usesCleartextTraffic` is necessary
[starting from Android API level 28](https://stackoverflow.com/a/56808180).

The app theme is declared in `styles.xml`.

```xml
<resources>
  <style name="AppTheme" parent="Theme.AppCompat.Light.NoActionBar"></style>
</resources>
```

With that, the final step is to flesh our the build system.  `gradlew` is a
file generated by invoking Gradle inside the project.

```shell
$ gradle wrapper
```

This will also generate a `gradlew.bat` executable for use on Windows.
`settings.gradle` declares the nested `app` project inside the Android project.

```groovy
include ':app'
```

The two `build.gradle` files are all that's left.

```groovy
buildscript {
    ext {
	buildToolsVersion = "28.0.3"
	minSdkVersion = 16
	compileSdkVersion = 28
	targetSdkVersion = 28
    }

    repositories {
	google()
	jcenter()
    }

    dependencies {
	classpath("com.android.tools.build:gradle:3.5.2")
    }
}

allprojects {
    repositories {
	mavenLocal()

	maven {
	    url("$rootDir/../node_modules/react-native/android")
	}

	maven {
	    url("$rootDir/../node_modules/jsc-android/dist")
	}

	google()
	jcenter()
    }
}
```

This is the root `build.gradle` file.  It declares the Android API versions to
use and necessary dependencies.

The one inside `app` is more complex.

```groovy
apply plugin: "com.android.application"

apply from: "../../node_modules/react-native/react.gradle"

android {
    compileSdkVersion rootProject.ext.compileSdkVersion

    compileOptions {
	sourceCompatibility JavaVersion.VERSION_1_8
	targetCompatibility JavaVersion.VERSION_1_8
    }

    defaultConfig {
	applicationId "com.myminimalapp"
	minSdkVersion rootProject.ext.minSdkVersion
	targetSdkVersion rootProject.ext.targetSdkVersion
	versionCode 1
	versionName "1.0"
    }
}

dependencies {
    implementation fileTree(dir: "libs", include: ["*.jar"])
    implementation "com.facebook.react:react-native:+"
    implementation "org.webkit:android-jsc:+"
}

apply from: file("../../node_modules/@react-native-community/cli-platform-android/native_modules.gradle"); applyNativeModulesAppBuildGradle(project)
```

Where we can, we import the values used in the root `build.gradle` file.
Otherwise, this file is again about declaring dependencies.


## Running the app {#running-the-app}

Before you can see this app running on an emulator, you'll need to set up your
local environment:

-   [Install Node.js](https://nodejs.dev/how-to-install-nodejs)
-   [Set up an Android development environment](https://reactnative.dev/docs/environment-setup)

From the root project directory (_not_ the Android project directory), start the
Metro bundler.

```shell
$ npx react-native start
```

Then, start the Android component.

```shell
$ npx react-native run-android
```

You should then see the app load up in your emulator.

{{< figure src="/images/minimal_react_native_android_app.png" >}}


## Where to go from here {#where-to-go-from-here}

Most of this was learnt by taking apart a sample React Native project and seeing
what I could get away with removing.  Now it's time to add things back in.

Even if a snappy UI was added and the app did something useful, it wouldn't be
ready to go onto the Play Store.  There are steps that must be taken to get an
app production-ready, but there are numerous tutorials covering that process.
Until we get to that point, we have a codebase where we know the purpose of
every file in it.  If we run into a problem down the road, we're more likely to
know how to fix it because we built the application from the ground up.  With
the foundation in place, the rest of the journey is about incremental iteration.