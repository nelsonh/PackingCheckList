//
//  ImportPhoto.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PackingCheckListAppDelegate;
@class ImportPhotoPreviewController;
@class NamePhotoController;
@class ImportPhotoBackgroundController;

typedef enum Select_Type{
	Camera=0,
	PhotoLibrary
}SelectType;

@interface ImportPhoto : NSObject <UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	
	PackingCheckListAppDelegate *mDelegate;
	
	//use to handle preview view
	UINavigationController *m_NavController;
	
	//import photo preview controller
	ImportPhotoPreviewController *m_ImportPhotoPreviewController;
	
	//name photo controller;
	NamePhotoController *m_NamePhotoController;
	
	//user selected type
	SelectType m_UserSelectedType;
	
	//user iphone model
	BOOL m_IsUserUseIphone;
}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;

@property (nonatomic, retain) UINavigationController *m_NavController;
@property (nonatomic, retain) ImportPhotoPreviewController *m_ImportPhotoPreviewController;
@property (nonatomic, retain) NamePhotoController *m_NamePhotoController;

-(id)InitImportPhotoWithDelegate:(PackingCheckListAppDelegate*)delegate;
-(void)ActiveImportPhotoMenu;
-(void)CloseImportPhotoUtility;
-(void)FinishImportPhotoUtility:(UIImage*)mImage WithImageName:(NSString*)imageName;
-(void)ReleaseNavigation;


@end
