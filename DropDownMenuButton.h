//
//  DropDownMenuButton.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;

@interface DropDownMenuButton : UIButton {
	
	PackingCheckListAppDelegate *mDelegate;
	
	CGRect m_OriginRect;
	
	NSString *m_ButtonName;
	
	NSString *m_DisplayName;
	
	BOOL m_Behaviour;
	
	NSString *m_ActionCommand;

}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property CGRect m_OriginRect;
@property (nonatomic, retain) NSString *m_ButtonName;
@property (nonatomic, retain) NSString *m_DisplayName;
@property BOOL m_Behaviour;
@property (nonatomic, retain) NSString *m_ActionCommand;

-(id)InitWithButtonName:(NSString*)Name WithDisplayName:(NSString*)displayName WithBehaviour:(BOOL)behaviour WithAction:(NSString*)action WithFrame:(CGRect)viewFrame WithImageFileName:(NSString*)imageFileName;

@end
