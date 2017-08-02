//
//  UIDevice+Additions.h
//  CardToon
//
//  Created by Austin on 7/18/13.
//  Copyright (c) 2013 com.coortouch.ender. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMotion/CoreMotion.h>
#import <MessageUI/MessageUI.h>

@interface UIDevice (Additions)
- (BOOL) microphoneAvailable;
- (void) vibrateWithSound;
- (void) vibrateWithoutSound;

- (BOOL) doesPhotoLibraryHavePictures;
- (BOOL) doesCameraRollHavePictures;

- (BOOL) cameraAvailable;
- (BOOL) videoCameraAvailable;
- (BOOL) frontCameraAvailable;
- (BOOL) cameraFlashAvailable;

- (BOOL) canSendEmail;
- (BOOL) canSendSMS;
- (BOOL) canMakePhoneCalls;

- (BOOL) multitaskingCapable;
- (BOOL) retinaDisplayCapable;

- (BOOL) compassAvailable;
- (BOOL) gyroscopeAvailable;
@end
