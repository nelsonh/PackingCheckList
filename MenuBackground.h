//
//  MenuBackground.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/6.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;
@class DropDownCancelDetectionView;

@interface MenuBackground : UIView {
	
	//point to data source
	PackingCheckListAppDelegate *mDelegate;
	
	CGRect m_OriginRect;
	
	//background image
	UIImageView *m_BackgroundImage;
	
	//narrow up
	UIImageView *m_MenuUpNarrow;
	
	//narrow down
	UIImageView *m_MenuDownNarrow;
	
	DropDownCancelDetectionView *m_DropDownDetectionView;
	
	NSString *m_ImageFileName;

}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) UIImageView *m_BackgroundImage;
@property (nonatomic, retain) UIImageView *m_MenuUpNarrow;
@property (nonatomic, retain) UIImageView *m_MenuDownNarrow;
@property (nonatomic, retain) DropDownCancelDetectionView *m_DropDownDetectionView;
@property (nonatomic, retain) NSString *m_ImageFileName;

-(void)EaseOut;
-(void)EaseIn;
-(void)ShowUpNarrow;
-(void)ShowDownNarrow;
-(void)ShowBothNarrow;

-(void)ChangeBackgroundImage:(NSString*)fileName;

-(void)BringDropDownDetectionViewtoTop;
-(void)BringDropDownDetectionViewtoBack;

@end
