//
//  FileSystemButton.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;

@interface FileSystemButton : UIImageView {

	PackingCheckListAppDelegate *mDelegate;
	
	CGRect m_OriginRect;
	
	NSString *m_Name;
	
	BOOL m_Behaviour;
	
	BOOL m_Touched;
	
	NSString *m_ActionCommand;
	
	NSString *m_ImageName;
}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property CGRect m_OriginRect;
@property (nonatomic, retain) NSString *m_Name;
@property BOOL m_Behaviour;
@property (nonatomic, retain) NSString *m_ActionCommand;
@property (nonatomic, retain) NSString *m_ImageName;

-(id)InitWithButtonName:(NSString*)buttonName WithBehaviour:(BOOL)behaviour WithAcion:(NSString*)action WithImageName:(NSString*)imageFileName WithFrame:(CGRect)viewFrame;

@end
