//
//  FileSystemBar.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;
@class FileSystemButton;

@interface FileSystemBar : UIView {
	
	PackingCheckListAppDelegate *mDelegate;
	
	CGRect m_OriginRect;
	
	FileSystemButton *m_CreateNew;
	FileSystemButton *m_ManageList;
	FileSystemButton *m_Sort;
	
	BOOL m_ButtonTouched;

}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property CGRect m_OriginRect;
@property BOOL m_ButtonTouched;
@property (nonatomic, retain) FileSystemButton *m_CreateNew;
@property (nonatomic, retain) FileSystemButton *m_ManageList;
@property (nonatomic, retain) FileSystemButton *m_Sort;

-(id)InitWithFrame:(CGRect)viewFrame WithDelegate:(PackingCheckListAppDelegate*)delegate;
-(void)UnClickedButton;
-(void)ShowFileSystemButton;
-(void)HideFileSystemButton;

@end
