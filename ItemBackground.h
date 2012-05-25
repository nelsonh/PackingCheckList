//
//  ItemBackground.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/6.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;
@class DropDownCancelDetectionView;

@interface ItemBackground : UIView {
	
	//point to data source
	PackingCheckListAppDelegate *mDelegate;

	CGRect m_OriginRect;
	
	//background image
	UIImageView *m_BackgroundImage;
	
	
	DropDownCancelDetectionView *m_DropDownDetectionView;
	
	NSString *m_ImageFileName;
	
	//narrow up
	UIImageView *m_ItemLeftNarrow;
	
	//narrow down
	UIImageView *m_ItemRightNarrow;
}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) UIImageView *m_BackgroundImage;
@property (nonatomic, retain) DropDownCancelDetectionView *m_DropDownDetectionView;
@property (nonatomic, retain) NSString *m_ImageFileName;
@property (nonatomic, retain) UIImageView *m_ItemLeftNarrow;
@property (nonatomic, retain) UIImageView *m_ItemRightNarrow;

-(void)EaseOut;
-(void)EaseIn;

-(void)ChangeBackgroundImage:(NSString*)fileName;

-(void)BringDropDownDetectionViewtoTop;
-(void)BringDropDownDetectionViewtoBack;

-(void)ShowLeftNarrow;
-(void)ShowRightNarrow;
-(void)ShowBothNarrow;
-(void)HideBothNarrow;

@end
