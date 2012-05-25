//
//  UserConfigDataPackage.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/6/1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserConfigDataPackage.h"


@implementation UserConfigDataPackage


@synthesize m_MenuBorder;
@synthesize m_MenuBackground;
@synthesize m_InfoBarBackground;
@synthesize m_ItemBorder;
@synthesize m_ItemBackground;
@synthesize m_Wallpaper;
@synthesize m_PoolRed;
@synthesize m_PoolGreen;
@synthesize m_PoolBlue;
@synthesize m_PoolAlpha;
@synthesize m_LastPoolName;
@synthesize m_TopRightBorder;
@synthesize m_TopRightBorder2;

-(id)InitPackage
{
	if(self=[super init])
	{
		
	}
	
	return self;
}


- (void)dealloc {
	
	if(m_MenuBorder!=nil)
	{
		self.m_MenuBorder=nil;
	}
	
	if(m_MenuBackground!=nil)
	{
		self.m_MenuBackground=nil;
	}
	
	if(m_InfoBarBackground!=nil)
	{
		self.m_InfoBarBackground=nil;
	}
	
	if(m_ItemBorder!=nil)
	{
		self.m_ItemBorder=nil;
	}
	
	if(m_ItemBackground!=nil)
	{
		self.m_ItemBackground=nil;
	}
	
	if(m_Wallpaper!=nil)
	{
		self.m_Wallpaper=nil;
	}
	
	if(m_LastPoolName!=nil)
	{
		self.m_LastPoolName=nil;
	}
	
	if(m_TopRightBorder!=nil)
	{
		self.m_TopRightBorder=nil;
	}
	
	if(m_TopRightBorder2!=nil)
	{
		self.m_TopRightBorder2=nil;
	}
	
    [super dealloc];
}

@end
