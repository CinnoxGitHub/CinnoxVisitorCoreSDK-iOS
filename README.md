[![Swift](https://img.shields.io/badge/Swift-5.7_5.8-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.7_5.8-Orange?style=flat-square)
[![iOS](https://img.shields.io/badge/iOS-13+-blue?style=flat-square)](https://img.shields.io/badge/iOS-13-blue?style=flat-square)
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-black?style=flat-square)](https://img.shields.io/badge/iOS-14-blue?style=flat-square)
# `CinnoxVisitorCoreSDK`

This guide provides instructions for setting up and using the `CinnoxVisitorCoreSDK` framework in your iOS application.

<img src="https://github.com/CinnoxGitHub/ios_visitor_sample_app/blob/44aa6473f11a994bc94bab623a09bc275ebcabe5/Demo.gif" width="200">

## iOS Quick Start Guide

To quickly integrate the `CinnoxVisitorCoreSDK` framework into your iOS application, follow these steps:

1. Open your Xcode project and navigate to the project directory.
2. Open the `Podfile` file and add the following line:
```ruby
platform :ios, '13.0'
source 'https://github.com/CocoaPods/Specs'

target 'YOUR_APP_TARGET' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'CinnoxVisitorCoreSDK', '1.0.0.14'

  target 'YOUR_APP_NOTIFICATIONSERVICE_TARGET' do
    inherit! :search_paths
  end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
    end
end

```
3. Save the `Podfile` and run the command `pod install` in the project directory to install the framework.
> Note: Make sure you have CocoaPods installed on your system before running the `pod install` command.
4. Once the installation is complete, open the generated `.xcworkspace` file to access your project in Xcode.

## Adding a Sample App to a Cinnox Project

To add a sample app to a Cinnox project, follow these steps:

1. Use the `bundleID` from your Xcode project.
2. Download the generated `M800ServiceInfo.plist` file from Cinnox.
3. Replace the existing `plist` file in the root directory of the sample app with the downloaded `M800ServiceInfo.plist` file.
> Note: Make sure you select both 'Your_App_Target' and 'YOUR_APP_NOTIFICATIONSERVICE_TARGET' in the 'Target Membership' section for `M800ServiceInfo.plist`.

## Xcode Signing & Capabilities

In Xcode, you can configure various capabilities to extend the functionality of your application or allow it to access certain system services. Please ensure that your application is correctly configured for the Notification Service Extension:

Select your application target and switch to the **"Signing & Capabilities"** tab.

1. **App Groups**
2. **Keychain Sharing**
3. **Notifications**
4. **Background Modes:** Background fetch, Remote notifications, Voice over IP (VoIP)

## Xcode Privacy
Requires **Permissions** in Xcode's **Info.plist**
1. Privacy - Media Library Usage Description
2. Privacy - Camera Usage Description
3. Privacy - Microphone Usage Description
4. Privacy - Photo Library Additions Usage Description
5. Privacy - Photo Library Usage Description

## How to Use

To use the `CinnoxVisitorCoreSDK` framework in your iOS application, follow these steps:

### Step 1: Add Initialization Code

In your `AppDelegate.swift` file, add the following code snippet to the `application(_:didFinishLaunchingWithOptions:)` method:

```swift
import CinnoxVisitorCoreSDK

var core: CinnoxVisitorCore?

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    CinnoxVisitorCore.configure()
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _,_  in }
    core = CinnoxVisitorCore.initialize(serviceName: "YOUR_SERVICE_NAME.cinnox.com", delegate: self)

    return true
}
```

This code initializes the `CinnoxVisitorCore` with a service name and a delegate object. Adjust the `serviceName` parameter according to your specific Cinnox service configuration.

And **MUST** set `UNUserNotificationCenter.current().delegate = self` here and handle the UNUserNotificationCenterDelegate, CinnoxVisitorCoreSDK will handle notifications.

```swift
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner, .sound, .badge])
}

func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
}

func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
}
```

### Step 2: Add Widget View to View Controller
In your desired view controller, add the following code snippet:


```swift
import UIKit
import CinnoxVisitorCoreSDK

class ViewController: UIViewController {
    var widget = CinnoxVisitorWidget(frame: .init(x: 100, y: 100, width: 50, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Add any additional setup after loading the view.
        view.addSubview(widget)
    }
}
```

This code creates an instance of `CinnoxVisitorWidget` and adds it as a subview to your view controller's view. Adjust the `frame` parameter according to your desired widget position and size.

That's it! You have now successfully integrated the `CinnoxVisitorCoreSDK` framework into your iOS application. You can customize and extend its functionality as needed.

### Step 3: Setup NotificationService Extension

#### 1. Create a Notification Service Extension:

Create a class that inherits from UNNotificationServiceExtension to handle notification requests. This class will be responsible for passing the notification to your SDK and processing the corresponding content. (https://developer.apple.com/documentation/usernotifications/unnotificationserviceextension)

Here's an example code snippet:
```swift
import UserNotifications
import CinnoxVisitorCoreSDK

class NotificationService: UNNotificationServiceExtension {
    public var notificationHandler = CinnoxVisitorCore.createNotificationServiceHandler()
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        notificationHandler.didReceive(request) { content in
            contentHandler(content)
        } nonCinnoxContent: {
            if let bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent) {
                contentHandler(bestAttemptContent)
            }
        }
    }
}
```
Please note the closure contentHandler used to handle the content of notifications sent by the Cinnox Visitor Core SDK. When the notification is sent by the SDK and the processing is successful, the processed content should be passed to the `contentHandler`.And The closure nonCinnoxContent to handle notifications that are not sent by the SDK or in case of processing failure.


#### 2. Configure Application Settings:
In Xcode, ensure that your application is correctly configured for the **NotificationService Extension**:
1. **App Groups**
2. **Keychain Sharing**




### Step 4: Setup APNS Certificate
We are setting up your product's APNS (Apple Push Notification Service) integration to provide efficient push notification services. In order to proceed, we need you to provide `Team ID`, `Key ID` and `.p8` Certificates file from your Apple Developer account.

Please follow the instructions below to provide the required details:

#### 1. Apple Developer Program Team ID
Your Team ID is a unique identifier assigned by Apple. You can find it by:

Going to Apple Developer Membership (https://developer.apple.com/account/#/membership)
Your Team ID will be listed there
#### 2. Key ID of your APNS Key
Each APNS Key has a unique Key ID. You can find the Key ID by:

Going to Apple Developer Certificates, Identifiers & Profiles > Keys (https://developer.apple.com/account/resources)
If you already have an APNS Key, the Key ID will be listed there
#### 3. p8 file of your APNS Key
The APNS Key should be downloaded as a .p8 file. If you haven't created an APNS Key yet, you can do so by:

Signing in to your Apple Developer account
Going to Certificates, Identifiers & Profiles > Keys (https://developer.apple.com/account/resources/authkeys/list)
Clicking the "+" button to create a new key
Entering a key name and checking the "Apple Push Notifications service (APNs)" option
Clicking "Continue" and then "Register"
On the confirmation page, click "Download" to save the .p8 file
Please provide us (support@cinnox.com) with these details so that we can proceed with the setup. If you have any questions or need assistance, feel free to get in touch.

We appreciate your prompt attention to this matter and look forward to delivering the best possible service.

### How to use CTA on your application

You can use its click-to-action (CTA) features (i.e., Click-to-call or Click-to-chat buttons) on your application.

Widget - a widget, i.e., a small application interface, located at the bottom of a UI page that lets your customers or visitors immediately interact with your business through call or chat.

Click-to-call - a CINNOX widget feature that automatically calls a specific Tag or Staff member whenever a customer.

Click-to-chat - a CINNOX widget that automatically launches a chat room for a specific Tag or Staff member whenever a customer.

Here is a step-by-step guide for using CTA function:

```swift
// MARK: create call tag action
let tagAction = CinnoxAction.initTagAction(tagId: "YOUR_TAG_ID", contactMethod: .message)

// MARK: create call staff action
let staffAction = CinnoxAction.initStaffAction(staffEid: "YOUR_STAFF_EID", contactMethod: .message)

// MARK: create open directory action
let directoryAction = CinnoxAction.initDirectoryAction()

CinnoxVisitorCore.current?.callToAction(action: tagAction, completion: { error in
    print(error)
})
```

## Contact Us
If you encounter any technical issues, please contact us (support@cinnox.com)
