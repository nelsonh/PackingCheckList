//
//  PoolBackground.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/6.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;
@class DropDownCancelDetectionView;

@interface PoolBackground : UIView {
	
	//point to data source
	PackingCheckListAppDelegate *mDelegate;
	
	CGRect m_OriginRect;
	
	DropDownCancelDetectionView *m_DropDownDetectionView;
	
	CGFloat m_Red, m_Green, m_Blue, m_Alpha;
}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) DropDownCancelDetectionView *m_DropDownDetectionView;
@property CGFloat m_Red;
@property CGFloat m_Green;
@property CGFloat m_Blue;
@property CGFloat m_Alpha;

-(void)ZoomIn;
-(void)ZoomOut;

-(void)ChangeBackgroundColor:(UIColor*)color;

-(void)BringDropDownDetectionViewtoTop;
-(void)BringDropDownDetectionViewtoBack;

@end
