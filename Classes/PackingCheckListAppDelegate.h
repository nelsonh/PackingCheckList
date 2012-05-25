//
//  PackingCheckListAppDelegate.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/29.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
#define DragDelayTime 0.001
#define NarrowFadeOut 3.0
#define LoadingProgressView NO

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class MainBackground;

@class PoolView;
@class ImportPhotoImageView;
@class PoolBackground;
@class WallpaperView;
@class ItemView;

@class InformationBar;
@class MenuView;
@class MenuBorder;
@class MenuBackground;
@class ItemBorder;
@class ItemBackground;
@class TopRightBorder;
@class TopRightBorder2;
@class DataController;
@class Utility;

@class LoadingProgressBar;

@interface PackingCheckListAppDelegate : NSObject <UIApplicationDelegate, UIAccelerometerDelegate, UIAlertViewDelegate> {
    UIWindow *window;
	
	MainBackground *m_MainBackground;
	
	PoolView *m_PoolView;
	ImportPhotoImageView *m_ImportPhotoImageView;
	PoolBackground *m_PoolBackground;
	WallpaperView *m_WallpaperView;
	ItemView *m_ItemView;
	InformationBar *m_InfoBar;
	MenuView *m_MenuView;
	MenuBorder *m_MenuBorder;
	MenuBackground *m_MenuBackground;
	ItemBorder *m_ItemBorder;
	ItemBackground *m_ItemBackground;
	TopRightBorder *m_TopRightBorder;
	TopRightBorder2 *m_TopRightBorder2;
	
	DataController *m_DataController;
	
	Utility *m_Utility;
	
	//test
	BOOL zoom;
	
	BOOL isAlertOn;
	
	//last acceleration
	UIAcceleration *m_LastAcceleration;
	
	//device model
	NSString *m_DeviceModel;
	NSString *m_DeviceName;
	NSString *m_DeviceOperationSystem;
	NSString *m_DeviceOSVersion;
	NSString *m_DeviceLocalizeModel;
	NSString *m_DeviceUniqueIdentifier;
	
	UIImageView *m_LoadingImage;
	UIActivityIndicatorView *m_LoadingActivity;
	
	LoadingProgressBar *m_LoadingProgressBar;
	
	NSString *m_Mode;
	
	/*
	//fun
	UIImageView *sImage;
	int s;
	 */
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) MainBackground *m_MainBackground;

@property (nonatomic, retain) PoolView *m_PoolView;
@property (nonatomic, retain) ImportPhotoImageView *m_ImportPhotoImageView;
@property (nonatomic, retain) PoolBackground *m_PoolBackground;
@property (nonatomic, retain) WallpaperView *m_WallpaperView;
@property (nonatomic, retain) ItemView *m_ItemView;
@property (nonatomic, retain) InformationBar *m_InfoBar;
@property (nonatomic, retain) MenuView *m_MenuView;
@property (nonatomic, retain) MenuBorder *m_MenuBorder;
@property (nonatomic, retain) MenuBackground *m_MenuBackground;
@property (nonatomic, retain) ItemBorder *m_ItemBorder;
@property (nonatomic, retain) ItemBackground *m_ItemBackground;
@property (nonatomic, retain) TopRightBorder *m_TopRightBorder;
@property (nonatomic, retain) TopRightBorder2 *m_TopRightBorder2;

@property (nonatomic, retain) DataController *m_DataController;
@property (nonatomic, retain) Utility *m_Utility;

@property (nonatomic, retain) UIAcceleration *m_LastAcceleration;

@property (nonatomic, retain) NSString *m_DeviceModel;
@property (nonatomic, retain) NSString *m_DeviceName;
@property (nonatomic, retain) NSString *m_DeviceOperationSystem;
@property (nonatomic, retain) NSString *m_DeviceOSVersion;
@property (nonatomic, retain) NSString *m_DeviceLocalizeModel;
@property (nonatomic, retain) NSString *m_DeviceUniqueIdentifier;

@property (nonatomic, retain) UIImageView *m_LoadingImage;


-(void)BringInformationBarToTop;
-(void)BringMenuToTop;
-(void)ShackCheck:(UIAcceleration*)lastAcceleration WithCurrentAcceleration:(UIAcceleration*)currentAcceleration WithThreshold:(double)threshold;
-(void)RetrieveDeviceInformation;
-(void)LoadApp;
-(void)LoadingImageFadeOut;
-(void)UpdateProgressBar;
-(void)LoadUserConfig;



//-(void)Bound;


//test function
-(void)Zoom;

-(void)NoCustomAlert:(NSString*)title WithMessage:(NSString*)message;


@end



