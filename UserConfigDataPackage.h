//
//  UserConfigDataPackage.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/6/1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserConfigDataPackage : NSObject {
	
	NSString *m_MenuBorder;
	NSString *m_MenuBackground;
	NSString *m_InfoBarBackground;
	NSString *m_ItemBorder;
	NSString *m_ItemBackground;
	NSString *m_Wallpaper;
	CGFloat m_PoolRed;
	CGFloat m_PoolGreen;
	CGFloat m_PoolBlue;
	CGFloat m_PoolAlpha;
	NSString *m_LastPoolName;
	NSString *m_TopRightBorder;
	NSString *m_TopRightBorder2;
	
}

@property (nonatomic, retain) NSString *m_MenuBorder;
@property (nonatomic, retain) NSString *m_MenuBackground;
@property (nonatomic, retain) NSString *m_InfoBarBackground;
@property (nonatomic, retain) NSString *m_ItemBorder;
@property (nonatomic, retain) NSString *m_ItemBackground;
@property (nonatomic, retain) NSString *m_Wallpaper;
@property CGFloat m_PoolRed;
@property CGFloat m_PoolGreen;
@property CGFloat m_PoolBlue;
@property CGFloat m_PoolAlpha;
@property (nonatomic, retain) NSString *m_LastPoolName;
@property (nonatomic, retain) NSString *m_TopRightBorder;
@property (nonatomic, retain) NSString *m_TopRightBorder2;

-(id)InitPackage;

@end
