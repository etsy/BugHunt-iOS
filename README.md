# Bug Hunt : gamified focused testing of your app

A drop-in module that allows for easy bug reporting, sending test cases to your users, and keeping track of number of bugs reported per users.

Throughtout the development of your app, you may want some specific feedback on new features you added, or on bugs you fixed - BugHunt is here to help. By feeding test-scenarios to your users and keeping tab of the good karma points, you can achieve guided, focused testing of your app while making it a game to your (internal) users.

**Meant for beta and internal usage. Future additions might include code not approved for the App Store.**

<p align="center">
<br />
<img src='bughunt.gif'/>
<br />
</p>
## Usage

To show the Bug Hunt overlay:

```objc
[BugHunt showBugHunt];
```

#### EBHNetworkCommunicator

To handle network events, create a class that conforms to the `EBHNetworkCommunicator` protocol and give an instance to the BugHunt module:

```objc
MyNetworkCommunicator *networkCommunicator = [[MyNetworkCommunicator alloc] init];
[BugHunt setNetworkCommunicator:networkCommunicator];
```

Your network communicator is now responsible for responding to requests:

```objc
- (BOOL)createBugHuntIssue:(EBHBugReport *)bugReport
                  completion:(EBHCreateNewIssueCompletionBlock)completionBlock
{
    // Perform request asynchronously and call the completion block
    // when finished.

    // Let the caller know we are attempting to make the request so they
    // can display a loading indicator, etc if they would like.
    return YES;
}
```

#### Fetching test tasks

You typically would feed the test scenarios from a backend system, such as your issue tracker.

```objc
- (BOOL)fetchBugHuntTasks:(EBHFetchTasksCompletionBlock)completionBlock
{
    // Perform request asynchronously and call the completion block
    // when finished, with an array of EBHTask

    // Let the caller know we are attempting to make the request so they
    // can display a loading indicator, etc if they would like.
    return YES;
}

#### Fetching leaderboard scores

Leaderboard scores can be kept into your backend system as well - simply implement a way to retrieve the scores.

```objc
- (BOOL)fetchBugHuntLeaderboard:(EBHFetchLeaderboardCompletionBlock)completionBlock
{
    // Perform request asynchronously and call the completion block
    // when finished, with an array of EBHLeaderboardUser

    // Let the caller know we are attempting to make the request so they
    // can display a loading indicator, etc if they would like.
    return YES;
}

## Installation

### CocoaPods (preferred)

```ruby
pod 'BugHunt', :git => 'https://github.com/etsy/BugHunt-iOS.git'
```

### Manual Installation

1. Copy the `BugHunt` folder to your project.
2. Copy over the source from MBProgressHUD and AFNetworking.

## Roadmap / Known Issues

* Allow Bug Hunt to read in strings, parameters, etc from a config file.
* Option for reducing screenshot size before sending.
* Capture alert views.
* Add support for more than 3 pictures.
* Add rotation support.

## Contributing

Contributions welcome!

1. Fork
2. Make changes
3. Add a test if you can