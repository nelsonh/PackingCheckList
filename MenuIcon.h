//
//  MenuIcon.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;

@interface MenuIcon : UIImageView {
	
	//point to data source
	PackingCheckListAppDelegate *mDelegate;
	
	//icon name
	NSString *m_IconName;
	
	// image file name
	NSString *m_ImageFileName;
	
	//icon index
	NSUInteger m_Index;

}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) NSString *m_IconName;
@property (nonatomic, retain) NSString *m_ImageFileName;
@property NSUInteger m_Index;

-(id)InitWithIconName:(NSString*)iconName WithImage:(NSString*)imageFileName WithFrame:(CGRect)viewFrame;
-(void)InitImage;

@end
