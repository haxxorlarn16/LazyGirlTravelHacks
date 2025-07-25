# Firebase Setup for Lazy Girl Travel Hacks

This guide will help you set up Firebase authentication for email/password login in your iOS app.

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter a project name (e.g., "lazy-girl-travel-hacks")
4. Choose whether to enable Google Analytics (optional)
5. Click "Create project"

## Step 2: Add iOS App to Firebase

1. In your Firebase project console, click the iOS icon (+ Add app)
2. Enter your app's bundle ID: `com.lauren.lazygirltravelhacks`
3. Enter app nickname: "Lazy Girl Travel Hacks"
4. Click "Register app"
5. Download the `GoogleService-Info.plist` file

## Step 3: Replace Configuration File

1. Replace the placeholder `GoogleService-Info.plist` file in your project with the downloaded one
2. Make sure the file is added to your Xcode project target

## Step 4: Add Firebase Dependencies in Xcode

1. Open your project in Xcode
2. Select your project in the navigator
3. Select your app target
4. Go to the "Package Dependencies" tab
5. Click the "+" button to add a package
6. Enter the Firebase iOS SDK URL: `https://github.com/firebase/firebase-ios-sdk`
7. Select the following packages:
   - `FirebaseAuth`
   - `FirebaseCore`
8. Click "Add Package"

## Step 5: Enable Email/Password Authentication

1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Go to the "Sign-in method" tab
4. Enable "Email/Password" provider
5. Click "Save"

## Step 6: Test the Implementation

1. Build and run your app
2. Tap "Continue with Email" on the sign-in screen
3. Try creating a new account or signing in with existing credentials

## Features Implemented

✅ **Email Sign Up**: Users can create new accounts with email and password
✅ **Email Sign In**: Users can sign in with existing email/password
✅ **Form Validation**: Real-time validation for email format and password strength
✅ **Error Handling**: Clear error messages for authentication failures
✅ **Loading States**: Visual feedback during authentication processes
✅ **Pixel Art Styling**: Consistent with your app's design theme
✅ **Apple Sign-In Integration**: Works alongside existing Apple Sign-In

## Security Notes

- Passwords must be at least 6 characters long
- Email addresses are validated for proper format
- Firebase handles password hashing and security
- User data is stored securely in Firebase

## Troubleshooting

If you encounter build errors:
1. Make sure `GoogleService-Info.plist` is added to your target
2. Verify Firebase packages are properly linked
3. Clean build folder (Cmd+Shift+K) and rebuild
4. Check that Firebase is initialized in `lazygirltravelhacksApp.swift`

For authentication errors:
1. Check Firebase Console for any configuration issues
2. Verify email/password authentication is enabled
3. Check network connectivity
4. Review error messages in Xcode console 