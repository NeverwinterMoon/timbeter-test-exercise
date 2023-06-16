# Building the App

## Requirements

- Xcode 14.3
- Emulator or a real iOS device with iOS 16.x; the emulator works just fine and has full app functionality. By default, the emulator has some images in the Photo Library, and new ones can be added from the computer by simply dragging and dropping onto the running emulator.
- Apple ID account. This **does not** have to be an account enrolled in the developer program, any Apple ID account should work.

## Building

- Xcode > Preferences > Account > login with Apple ID
- Xcode > open project > in the navigator, select project, in "targets" select the only target, then "Signing & Capabilities" > under "Team", select "Personal Team"
Ensure "Automatically manage signing" is checked under the same section as above
Either select one of the simulators or connect the actual phone and select it at the very top

### For the real device only

- When running on the phone, the first launch will likely fail with a message indicating "Untrusted Developer" warning
Go to iOS settings on the phone > General > "VPN & Device Management" > under "Developer App" section, tap the profile (Apple ID account) > tap on "Trust 'Apple Development: <apple-id-account-identifier>'" > tap "Trust"
Try launching again from Xcode

# Architecture

This app is developed with the latest version of SwiftUI (which is tied to iOS version 16 in this case). The architecture is deliberately more advanced than was required for the app of this scope. SwiftUI allows easy connection to various services/repositories through property wrappers. For instance, it allows connection to UserDefaults through `@AppStorage` property wrapper and fetching from Core Data using `@FetchRequest` property wrapper. Doing this speeds up development but doesn't necessarily provide the best architecture. Thus, I explicitly avoided such things here, even though I would typically use them in an app of this complexity.

Firstly, the app does not use any third-party libraries. I avoid using those in general unless absolutely necessary (like integration with Google services or Realm database). The app uses a custom dependency injection mechanism through the use of DIContainer. All the required services and repositories are provided through DIContainer.

All the services and repositories conform to protocols, meaning the implementation can be substituted when needed: for instance, in tests. There are no tests here, unfortunately, but the substitution is demonstrated through stubs used for SwiftUI previews (every page and component has a preview generator and can be observed and interacted with in Xcode).

Note that service methods are implemented in a way that aligns with SwiftUI's approach to reactive programming. Instead of returning a value (for example, in `LogMeasurementService#fetchLogMeasurementList`), the return value is "bound" to the value that is a part of a view model triggering the service method. This is especially useful when working with asynchronous, longer calls.

Please note that I used UserDefaults to persist measurement data. Even though I persist simple values, I wouldn't have used UserDefaults for anything like this in a production app and would have rather opted for a Realm database, which is not only easy to use but also cross-platform and allows syncing data between devices running different OSs (for example, Android and iOS). This is done only to simplify the scope of the exercise. Nonetheless, the calls to UserDefaults are done in a way that I would have used for asynchronous database calls to fetch/store data. In fact, due to the way layering is implemented, UserDefaults can easily be substituted by any other repository.

## Error Handling
There is very basic error handling. I used only one error type everywhere: `TimbeterError.generic`. Nonetheless, wherever an error is possible, it is handled. Most of the time, it's done through the Loadable wrapper which has four states: .notRequested, .isLoading, .loaded, .failed.

# Challenges

The only challenge I experienced was with the `PhotosPicker` - a new addition to SwiftUI that allows working with photos from the library. At first, it seemed extremely nice and easy to use, but I soon ran into a problem where I couldn't use it to access photos using just the "itemIdentifier". So, after spending a good amount of time trying, I had to use the `PHImageManager`. The disappointing part about `PhotosPicker` was not only that loading based purely on "itemIdentifier" didn't work but also that because it returns SwiftUI's `Image` and not `UIImage`, there was no straightforward way to copy the image to app storage, as `Image` is not convertible to `UIImage` out of the box (there is a very hacky way of doing that). In essence, I wish I hadn't wasted so much time on PhotosPicker and had just started with non-SwiftUI APIs from the beginning.

# Assumptions and Decisions

One important decision to note is related to what I wrote above. Because `PhotosPicker` is still partially in play, all the images displayed in "history" are not copies but are linked to the Photo Library. I understand that in a real-life scenario this would probably be bad, but within the scope of this exercise, I think it works rather well - there is no data duplication (as in making a copy of the image).

I assumed that the point for "display the annotated image with the corresponding length and diameter" did not involve showing actual **measurement lines** in the history. Then I assumed that it might be good to have, but decided not to spend any more time on it, as I had already exceeded my own estimation due to the infamous `PhotosPicker`.

# Final Words

It was a fun exercise. If you would like something changed/fixed or have any questions, I would gladly respond. Also, feedback of any sort is greatly appreciated.
