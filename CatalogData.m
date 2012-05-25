//
//  CatalogData.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PackingCheckListAppDelegate.h"
#import "CatalogData.h"
#import "ItemPageView.h"


@implementation CatalogData

@synthesize mDelegate;
@synthesize m_ItemPageViewArray;

-(id)InitWithDelegate:(PackingCheckListAppDelegate*)delegate
{
	if(self=[super init])
	{
		self.mDelegate=delegate;
		
		//init ItemPageViewArray
		m_ItemPageViewArray=[[NSMutableArray alloc] init];
	}
	
	return self;
}

-(void)AddItemPageView:(ItemPageView*)itemPageView
{
	[itemPageView CheckEmpty];
	[m_ItemPageViewArray addObject:itemPageView];
}

- (void)dealloc {
	
	if(m_ItemPageViewArray!=nil)
	{
		[m_ItemPageViewArray removeAllObjects];
		[m_ItemPageViewArray release];
	}
	
	
    [super dealloc];
}

@end
