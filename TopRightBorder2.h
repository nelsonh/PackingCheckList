//
//  TopRightBorder2.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/7.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;

@interface TopRightBorder2 : UIView {
	
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
