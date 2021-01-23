# FirebaseSPMBug

Demonstrates an issue where adding `firebase-ios-sdk` to Xcode Swift Packages, as well as depending on it in a local Swift Package causes packages to fail to resolve consistently.

## The Results:

![firebase-ios-sdk displays as greyed out](screenshot.png)

![the underlying error](screenshot2.png)

`artifact of binary target 'FirebaseAnalytics' failed extraction: The operation couldn’t be completed. (TSCBasic.StringError error 1.)`
`artifact of binary target 'GoogleAppMeasurement' failed extraction: The operation couldn’t be completed. (TSCBasic.StringError error 1.)`

## The (Workaround) Solution:

Some combination of closing Xcode, Resetting Package Cache, and Updating Package Dependencies can resolve it temporarily.
