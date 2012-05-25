//
//  MenuData.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PackingCheckListAppDelegate.h"
#import "MenuData.h"
#import "MenuPageView.h"
#import "CatalogData.h"

@implementation MenuData

@synthesize mDelegate;
@synthesize m_MenuPageView;
@synthesize m_MainCatalogArray;

-(id)InitWithPageNum:(int)pageNum WithPageName:(NSString*)pageName WithDelegate:(PackingCheckListAppDelegate*)delegate;
{
	if(self=[super init])
	{
		self.mDelegate=delegate;
		
		//init a menu page view since init the menu page view add three icons with no image first 
		self.m_MenuPageView=[[MenuPageView alloc] InitWithPageNumber:pageNum WithName:pageName WithFrame:CGRectMake(0, 80*pageNum, 320, 80) WithDelegate:self.mDelegate];
		
		//init main catalog array
		m_MainCatalogArray=[[NSMutableArray alloc] init];
	}
	
	return self;
}

-(void)AddIconWithIconName:(NSString*)iconName WithFileName:(NSString*)fileName
{
	[m_MenuPageView AddIconWithIconName:iconName WithImageFileName:fileName];
	
	//[m_MenuPageView Finish];
}

-(void)AddCatalog:(CatalogData*)catalog
{
	[m_MainCatalogArray addObject:catalog];
}

- (void)dealloc {
	
	if(m_MenuPageView!=nil)
	{
		[m_MenuPageView release];
	}
	
	if(m_MainCatalogArray!=nil)
	{
		[m_MainCatalogArray removeAllObjects];
		[m_MainCatalogArray release];
	}

    [super dealloc];
}

@end
