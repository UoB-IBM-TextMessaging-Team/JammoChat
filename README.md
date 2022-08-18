#  <img src="https://user-images.githubusercontent.com/13105267/184379189-378c004f-26e2-45a7-b5a8-0c3fe310e49c.jpg" width="60" height="60"> JammoChat - AR & AI Chatting Experience 

A text messaging app with vivid AR & AI experience powered by *IBM Watson*.  
Special thanks to [Mix and Jam](https://www.youtube.com/c/mixandjam) with wonderful open-source 3D asset!

Brief look             |  AR/AI chat interface
:-------------------------:|:-------------------------:
![20220812_153024](https://user-images.githubusercontent.com/13105267/184378612-d688535d-3a87-4ff2-ad1b-8755ac95ba5f.gif)  |   ![20220812_155903](https://user-images.githubusercontent.com/13105267/184383193-325864c3-2864-4fc9-ba59-6b24ef1faf62.gif)


## Project Brief

AI and Augmented Reality Text Messaging Application - create a new text messaging application that is designed to run on mobile devices (Android) that will provide a more visual experience to text messaging, in the form of an augmented reality avatar (that represents the sender) and speaks out the message using Watson


## Build Instruction

The build requirement including:

* [Google flutter (3.0.0+)](https://docs.flutter.dev/get-started/install)
*Due to a flutter upstream bug with `PlatformView` existing in flutter 3.0.0-3.1.0, it's recommend to bump flutter version to 3.3.0 pre. Details: [issue #17](https://github.com/UoB-IBM-TextMessaging-Team/ar_ai_textmessaging_unity/issues/17)*

* [Unity 2022.1.1f1(with android NDK 21)](https://unity3d.com/get-unity/download)

To build the app, you just need to:

1. (First time init/If the unity project been changed/) Open the `unity` project in`/unity/ARView-IBM-TextMessaging`, In `File` select `build setting` and switch platform to`android`. Then Menu -> Flutter -> Export Android
2. Setting up`android/local.properties`. If you excute `flutter run`, a `android/local.properties` will automatically generates. But you still need to set `flutter.compileSdkVersion`,`flutter.minSdkVersion` and  `ndk.dir`. Following varibles is essential to the project build:    
   `sdk.dir=<android SDK location>`  
   `flutter.sdk=<Flutter location>`  
   `flutter.compileSdkVersion=33`  
   `flutter.minSdkVersion=24`  
   `ndk.dir=<android NDK location>`    (You can find your android NDK path in Unity->Menu->Edit->Preferences->External Tools)
3. (Highly recommended) Installing flutter plugin in your working IDE
4. `flutter run`    

If you got any installation problem, check your flutter installation using `flutter doctor`. Make sure `android/local.properties` are set correctly. Further question please dm @Cheong43 .

## Unity Project Folder

`/unity` is the unity project location, `ARView-IBM-TextMessaging` is the current unity work dir. The `flutter-unity-view-widget-plugin` and `IBM Watson Unity sdk` already installed, please do not making any change on them.

If you would like to build the unity project independently, just use the unity `build and run`

## Trouble Shooting

*Work in progress..    
Any "redeclaration" error when building, just run `flutter clean`, it will clean the pub cache.    

## Team Members
- Paul Chou
- Zhichang Lin
- Xiaolan Li
- Xiuqing Wang
- Wangchen Zhao
- Junchan Zhou



