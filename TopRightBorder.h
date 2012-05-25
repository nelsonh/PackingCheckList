//
//  TopRightBorder.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/6.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


//This class is go with item view
//This class is created for effect

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;

@interface TopRightBorder : UIView {
	
	//point to data source
	PackingCheckListAppDelegate *mDelegate;
	
	UIImageView *m_Border;
	
	CGRect m_OriginRect;
	
	NSString *m_ImageFileName;

}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) UIImageView *m_Border;
@property (nonatomic, retain) NSString *m_ImageFileName;


-(void)EaseOut;
-(void)EaseIn;
-(void)ChangeBorderImage:(NSString*)fileName;
-(void)Reset;

@end
