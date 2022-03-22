# stream-chat-swift-test-helpers
Test Helpers used by Stream iOS SDKs for testing purposes. Written in Swift.

## Pre-requisities

In order to use this `Swift Package`, you'll need:
* Xcode 11


## Installation Guide
1. Setup your GitHub account in Xcode 11 (and above) under _Preferences-Accounts_

2. Add this repo to your Xcode project `https://github.com/GetStream/stream-chat-swift-test-helpers.git`

3. Add `StreamChatTestHelpers` package to your project's test target as Swift Package Dependency.

4. Once correctly added, you should see it in the Project Navigator pane under Swift Package dependencies

5. Start using the `StreamChatTestHelpers` by importing them in your test files: `import StreamChatTestHelpers`, or `@_exported import StreamChatTestHelpers` to make it accessible target-wise.
---

## 3rd party Dependencies
This package depends on [Difference](https://github.com/krzysztofzablocki/Difference) Swift package, that brings better way to identify what's different between 2 instances.
![TestHelpers](./resources/difference.png).

Mock server depends on [Swifter](https://github.com/httpswift/swifter) - a tiny HTTP server engine.

# Usage

## StreamChatTestHelpers - Unit tests

### Testing Result type
```swift
// Success value
XCTAssertEqual(result, success: "Success Value")
XCTAssertResultSuccess(result)

// Failure
XCTAssertEqual(result, failure: MyError.first)
XCTAssertResultFailure(result)
```

### Testing errors in type-safe way

```swift
XCTAssertEqual(MyError.first, .first)

XCTAssertThrowsError(try PathUpdate(with: data), ParsingError.failedToParseJSON)
```

### Testing errors in Swift

It's important to not treat the errors as outcasts in our code, but rather make them the first citizens of our API.
Testing the errors in Swift is in many occasions a tedious process, the test helpers are here to increase your productivity.

----
How does it work:

**Generic errors** in *Swift* can be compared based on their reflection

```swift
public extension Error {
    var stringReflection: String {
        return String(reflecting: self)
    }
}
```

#### Testing errors for equality

Let's consider we have declared `enum` with this case
```swift
public enum DeliveryStatusError: Error, Hashable {
  ...
  case fileSendingIsDisabled(messageId: String?)
  ...
}
```

We can leverage the fact the `XCTAssertEqual` now contains a test API that allows us to test 2 errors for equality.
If the type of the given error can be inferred, we can leverage the type-safety, which comes with the code-completion for free!

```swift
  XCTAssertEqual(error, .fileSendingIsDisabled(messageId: "some-long-id"))
```

#### Throwing Example:

Instead of writing code like this

```swift
func testItThrowsAnInternalError() {
    // given
    let myStruct = MyStruct()

    // when
    XCTAssertThrowsError(try myStruct.runningThisFuncCanThrow(), "It should throw error") { (error) in
        // then
        switch error {
        case let error as MyError:
            switch error {
            case .internalError:
                XCTAssertTrue(true)
            default:
                XCTFail("It didnt throw an internalError error")
            }
        default:
            XCTFail("It didnt throw MyError, error: \(error)")
        }
    }
}
```

You can make use of helper `XCTAssertThrowsTypedError`.

```swift
func testItThrowsTypedInternalError() {
    // given
    let myStruct = MyStruct()

    // then
    XCTAssertThrowsError(try myStruct.runningThisFuncCanThrow(),
                         MyError.internalError,
                         "It should throw error")
}
```

### Testing `Result` in Swift

Since the `Result` is an `enum` in a nutshell, testing the `Result` type usually requires you to switch over it's cases to identify the success/failure case of that result.
This can become a burden if you use `Result` types a lot.

Instead of writing test like this
```
func testRequestingTheResourceGivesMeSuccessResult() {
    // given
    let myStruct = MyStruct()

    // when
    let result = myStruct.requestSuccessResource()

    // then
    switch result {
    case .success:
        XCTAssertTrue(true)
    case .failure:
        XCTFail("The result is failure")
    }
}
```

#### Testing success `Result`

you can test the success of `Result` like this:
```
func testSuccessResult() {
    // given
    let myStruct = MyStruct()

    // when
    let result = myStruct.requestSuccessResource()

    // then
    XCTAssertResultSuccess(result)
    XCTAssertEqual(result, success: "Succes value")
}
```

This test will assert of the result is `failure`.

#### Testing failure `Result`

Testing the failure result with given error type looks like this

```swift
func testFailureResult() {
    // given
    let myStruct = MyStruct()

    // when
    let result = myStruct.requestFailureResource()

    // then
    XCTAssertResultFailure(result)
    XCTAssertEqual(result, failure: MyError.internalError)
}
```

## StreamChatTestHelpers - UI tests

This package provides support for writing UI tests, accessing UI elements and running actions & gestures on them.

### Robot Pattern

This package allows you to build your UI test architecture around two fundamentals concepts - Robot pattern and GIVEN, WHEN, THEN, AND notation.

Hide the UI test implementation detail behind the `Robot.
```
public protocol Robot: AnyObject {}
```

You may want to create as many `Robot`s as needed to interact with your app during the UI test suite run.

Example:

```swift
func testReceiveMessage() throws {
    let message = "test message"
    let author = "Han Solo"
    
    GIVEN("user opens the channel") {
        userRobot.login().openChannel()
    }
    WHEN("participant sends the message: '\(message)'") {
        participantRobot
            .startTyping()
            .stopTyping()
            .sendMessage(message)
    }
    THEN("the message is delivered") {
        userRobot
            .waitForParticipantsMessage()
            .assertMessageAuthor(author)
    }
}
```
