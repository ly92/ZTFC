//
//  UIDevice+Additions.m
//  CardToon
//
//  Created by Austin on 7/18/13.
//  Copyright (c) 2013 com.coortouch.ender. All rights reserved.
//

#import "UIDevice+Additions.h"

@implementation UIDevice (Additions)


- (BOOL) microphoneAvailable
{
	AVAudioSession *ptr = [AVAudioSession sharedInstance];
	return ptr.inputIsAvailable;
}

- (void) vibrateWithSound
{
	AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

-(void) vibrateWithoutSound
{
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (BOOL) doesPhotoLibraryHavePictures
{
	return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) doesCameraRollHavePictures
{
	return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

- (BOOL) cameraAvailable
{
	return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) videoCameraAvailable
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
	
    
	if (![sourceTypes containsObject:(NSString *)kUTTypeMovie ]){
        
		return NO;
	}
    
	return YES;
}

- (BOOL) frontCameraAvailable
{
#ifdef __IPHONE_4_0
	return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
#else
	return NO;
#endif
    
}

- (BOOL) cameraFlashAvailable
{
#ifdef __IPHONE_4_0
	return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
#else
	return NO;
#endif
}


- (BOOL) canSendEmail
{
	return [MFMailComposeViewController canSendMail];
}

- (BOOL) canSendSMS
{
#ifdef __IPHONE_4_0
	return [MFMessageComposeViewController canSendText];
#else
	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]];
#endif
}

- (BOOL) canMakePhoneCalls
{
	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
}

- (BOOL) multitaskingCapable
{
	BOOL backgroundSupported = NO;
	if ([self respondsToSelector:@selector(isMultitaskingSupported)])
		backgroundSupported = self.multitaskingCapable;
    
	return backgroundSupported;
}

- (BOOL) compassAvailable
{
	BOOL compassAvailable = NO;
    
#ifdef __IPHONE_3_0
	compassAvailable = [CLLocationManager headingAvailable];
#else
	CLLocationManager *cl = [[CLLocationManager alloc] init];
	compassAvailable = cl.headingAvailable;
	[cl release];
#endif
    
	return compassAvailable;
    
}

- (BOOL) gyroscopeAvailable
{
#ifdef __IPHONE_4_0
	CMMotionManager *motionManager = [[CMMotionManager alloc] init];
	BOOL gyroAvailable = motionManager.gyroAvailable;
	
	return gyroAvailable;
#else
	return NO;
#endif
    
}


- (BOOL) retinaDisplayCapable
{
	int scale = 1.0;
	UIScreen *screen = [UIScreen mainScreen];
	if([screen respondsToSelector:@selector(scale)])
		scale = screen.scale;
    
	if(scale == 2.0f) return YES;
	else return NO;
}
@end
