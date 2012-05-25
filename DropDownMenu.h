//
//  DropDownMenu.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#define Between 2

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;

@interface DropDownMenu : UIView {
	
	PackingCheckListAppDelegate *mDelegate;
	
	CGRect m_OriginRect;
	
	NSString *m_MenuName;
	
	NSString *m_Title;
	
	UILabel *m_TitleLable;
	
	NSMutableArray *m_ButtonArray;
	
	UIImageView *m_ImageView;
}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property CGRect m_OriginRect;
@property (nonatomic, retain) UILabel *m_TitleLable;
@property (nonatomic, retain) NSString *m_Title;
@property (nonatomic, retain) NSString *m_MenuName;
@property (nonatomic, retain) NSMutableArray *m_ButtonArray;
@property (nonatomic, retain) UIImageView *m_ImageView;

-(id)InitWithMenuName:(NSString*)menuName WithTitle:(NSString*)title WithButtonArray:(NSMutableArray*)buttonArray WithFrame:(CGRect)viewFrame;

-(void)ShowMenu;
-(void)HideMenu;
-(void)ReleaseSelf;

@end
