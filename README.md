#  <img src="https://user-images.githubusercontent.com/13105267/184379189-378c004f-26e2-45a7-b5a8-0c3fe310e49c.jpg" width="60" height="60"> JammoChat - AR & AI Chatting Experience 

A text messaging app with vivid AR & AI experience powered by *IBM Watson*.  
Special thanks to [Mix and Jam](https://www.youtube.com/c/mixandjam) with wonderful open-source 3D asset!  

**This project repo merge from [a flutter project](https://github.com/UoB-IBM-TextMessaging-Team/ar_ai_textmessaging_main) and [a unity project](https://github.com/UoB-IBM-TextMessaging-Team/ar_ai_textmessaging_unity). If you would like to learn more, please take a quick glance on our team homepage.:grinning:**

Brief look             |  AR/AI chat interface
:-------------------------:|:-------------------------:
![20220812_153024](https://user-images.githubusercontent.com/13105267/184378612-d688535d-3a87-4ff2-ad1b-8755ac95ba5f.gif)  |   ![20220812_155903](https://user-images.githubusercontent.com/13105267/184383193-325864c3-2864-4fc9-ba59-6b24ef1faf62.gif)


## Project Brief by Client

AI and Augmented Reality Text Messaging Application - create a new text messaging application that is designed to run on mobile devices (Android) that will provide a more visual experience to text messaging, in the form of an augmented reality avatar (that represents the sender) and speaks out the message using Watson


## Build Instruction

*To custom you server, you need to reset the firebase and microservice config.*

The build requirement including:

* [Google flutter (3.0.0+)](https://docs.flutter.dev/get-started/install)
*Due to a flutter upstream bug with `PlatformView` existing in flutter 3.0.0-3.1.0, it's recommend to bump flutter version to 3.3.0 pre. Details: [issue #17](https://github.com/UoB-IBM-TextMessaging-Team/ar_ai_textmessaging_unity/issues/17)*

* [Unity 2022.1.1f1(with android NDK 21)](https://unity3d.com/get-unity/download)

To build the app, you just need to:

1. (First time init/If the unity project been changed) Open the `unity` project in`/unity/ARView-IBM-TextMessaging`, In `File` select `build setting` and switch platform to`android`. Then Menu -> Flutter -> Export Android
2. Setting up`android/local.properties`. If you excute `flutter run`, a `android/local.properties` will automatically generates. But you still need to set `flutter.compileSdkVersion`,`flutter.minSdkVersion` and  `ndk.dir`. Following varibles are essential to the project build:  

   ```
   sdk.dir=<android SDK location>
   flutter.sdk=<Flutter location>
   flutter.compileSdkVersion=33
   flutter.minSdkVersion=24
   ndk.dir=<android NDK location>    //You can find your android NDK path installed with unity in Unity->Menu->Edit->Preferences->External Tools
   ```
   
3. (Highly recommended) Installing flutter plugin in your working IDE
4. `flutter run`    

If you got any installation or build problem, check your flutter config using `flutter doctor`. Make sure `android/local.properties` are set correctly. Further question please dm [@Cheong43](https://github.com/Cheong43) .

### Unity Project Folder

`/unity` is the unity project location, `ARView-IBM-TextMessaging` is the current unity working dir. If you would like do any modification, make sure using `Unity 2022.1.1f1`.

If you would like to build the unity project independently, just use the unity `build and run`

### Trouble Shooting

*Work in progress..    
Any "redeclaration" error when building, just run `flutter clean`, it will clean the pub cache.    

## Team Members
- Paul Chou ([@PoHsuanChou](https://github.com/PoHsuanChou))
- Zhichang Lin ([@Cheong43](https://github.com/Cheong43))
- Xiaolan Li ([@XLanLi](https://github.com/XLanLi))
- Xiuqing Wang ([@Aeolia1](https://github.com/Aeolia1))
- Wangchen Zhao ([@Corey52HZ](https://github.com/Corey52HZ))
- Junchan Zhou ([@zzzhh7](https://github.com/zzzhh7))

## Our Friends

Shout out to our lovely buddy [UoB-SpaceMath](https://github.com/UOB-SpaceMath) team! We shared a lot of development experience along the way.  
They did [a cool educative math game](https://github.com/UOB-SpaceMath/SpaceMath) with AR and IBM Watson, definitely worth a look👾
