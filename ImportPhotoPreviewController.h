//
//  ImportPhotoPreviewController.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImportPhotoPreviewView;

@interface ImportPhotoPreviewController : UIViewController {
	
	ImportPhotoPreviewView *m_ImportPhotoPreviewView;
}

@property (nonatomic, retain) ImportPhotoPreviewView *m_ImportPhotoPreviewView;;

-(void)SetupUI;
-(void)UserCancel;
-(void)UserUse;

@end
