//
//  PoolSubView.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PoolPageView.h"
#import "PackingCheckListAppDelegate.h"
#import "PoolIcon.h"
#import "PoolView.h"
#import "ItemIcon.h"
#import "ItemPageView.h"
#import "DataController.h"

@implementation PoolPageView

@synthesize mDelegate;
@synthesize m_TaskRowContainer;
@synthesize m_ItemRowContainer;
@synthesize m_PageName;

-(void)ZoomIn
{
	[UIView beginAnimations:@"Zoom in" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
    [self setFrame:CGRectMake(320*m_PageNumber, self.frame.origin.y, 320, 480)];

	
	//make each icon zoom in task
	for(int i=0; i<[m_TaskRowContainer count]; i++)
	{
		NSMutableArray *itemContainer=[m_TaskRowContainer objectAtIndex:i];
		
		for(int j=0; j<[itemContainer count]; j++)
		{
			[(PoolIcon*)[itemContainer objectAtIndex:j] setFrame:CGRectMake(j*76, (i*76)+20, 76, 76)];
			
			//tell icon to zoom in it's sub view
			[(PoolIcon*)[itemContainer objectAtIndex:j] ZoomInSubView];
			
			//must set origin
			[(PoolIcon*)[itemContainer objectAtIndex:j] setM_OriginRect: [(PoolIcon*)[itemContainer objectAtIndex:j] frame]];
		}
	}
	
	//get total task icons height
	int taskHeight=[m_TaskRowContainer count]*76;
	
	//make each icon zoom in item
	for(int i=0; i<[m_ItemRowContainer count]; i++)
	{
		NSMutableArray *itemContainer=[m_ItemRowContainer objectAtIndex:i];
		
		for(int j=0; j<[itemContainer count]; j++)
		{
			[(PoolIcon*)[itemContainer objectAtIndex:j] setFrame:CGRectMake(j*76, (i*76)+20+taskHeight, 76, 76)];
			
			//tell icon to zoom in it's sub view
			[(PoolIcon*)[itemContainer objectAtIndex:j] ZoomInSubView];
			
			//must set origin
			[(PoolIcon*)[itemContainer objectAtIndex:j] setM_OriginRect: [(PoolIcon*)[itemContainer objectAtIndex:j] frame]];
		}
	}
	
	//update content size
	[self UpdateContentSizeWithIconWidth:76];
	
	[UIView commitAnimations];
}

-(void)ZoomOut
{
	[UIView beginAnimations:@"Zoom in" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[self setFrame:CGRectMake(m_OriginRect.origin.x, m_OriginRect.origin.y, m_OriginRect.size.width, m_OriginRect.size.height)];
	
	//make each icon zoom out task
	for(int i=0; i<[m_TaskRowContainer count]; i++)
	{
		NSMutableArray *itemContainer=[m_TaskRowContainer objectAtIndex:i];
		
		for(int j=0; j<[itemContainer count]; j++)
		{
			[(PoolIcon*)[itemContainer objectAtIndex:j] setFrame:CGRectMake(j*60, i*60, 60, 60)];
			
			//tell icon to zoom out it's sub view
			[(PoolIcon*)[itemContainer objectAtIndex:j] ZoomOutSubView];
			
			//must set origin
			[(PoolIcon*)[itemContainer objectAtIndex:j] setM_OriginRect: [(PoolIcon*)[itemContainer objectAtIndex:j] frame]];
		}
	}
	
	//get total task icons height
	int taskHeight=[m_TaskRowContainer count]*60;
	
	//make each icon zoom out item
	for(int i=0; i<[m_ItemRowContainer count]; i++)
	{
		NSMutableArray *itemContainer=[m_ItemRowContainer objectAtIndex:i];
		
		for(int j=0; j<[itemContainer count]; j++)
		{
			[(PoolIcon*)[itemContainer objectAtIndex:j] setFrame:CGRectMake(j*60, i*60+taskHeight, 60, 60)];
			
			//tell icon to zoom out it's sub view
			[(PoolIcon*)[itemContainer objectAtIndex:j] ZoomOutSubView];
			
			//must set origin
			[(PoolIcon*)[itemContainer objectAtIndex:j] setM_OriginRect: [(PoolIcon*)[itemContainer objectAtIndex:j] frame]];
		}
	}
	
	//update content size
	[self UpdateContentSizeWithIconWidth:60];
	
	[UIView commitAnimations];
}

-(void)UnCheckAllIcons
{
	for(int i=0; i<[m_TaskRowContainer count]; i++)
	{
		NSMutableArray *iconArray=[m_TaskRowContainer objectAtIndex:i];
		
		for(int j=0; j<[iconArray count]; j++)
		{
			PoolIcon *icon=[iconArray objectAtIndex:j];
			[icon HideCheck];
		}
	}
	
	for(int i=0; i<[m_ItemRowContainer count]; i++)
	{
		NSMutableArray *iconArray=[m_ItemRowContainer objectAtIndex:i];
		
		for(int j=0; j<[iconArray count]; j++)
		{
			PoolIcon *icon=[iconArray objectAtIndex:j];
			[icon HideCheck];
		}
	}
}

-(BOOL)IsPoolEmpty
{
	if([m_TaskRowContainer count]==0 && [m_ItemRowContainer count]==0)
	{
		return YES;
	}
	else 
	{
		return NO;
	}

}

-(BOOL)IsAnyIconChecked
{
	for(int i=0; i<[m_TaskRowContainer count]; i++)
	{
		NSMutableArray *iconArray=[m_TaskRowContainer objectAtIndex:i];
		
		for(int j=0; j<[iconArray count]; j++)
		{
			PoolIcon *icon=[iconArray objectAtIndex:j];
			
			if(![(UIImageView*)[icon m_CheckImage] isHidden])
			{
				return YES;
			}
		}
	}
	
	for(int i=0; i<[m_ItemRowContainer count]; i++)
	{
		NSMutableArray *iconArray=[m_ItemRowContainer objectAtIndex:i];
		
		for(int j=0; j<[iconArray count]; j++)
		{
			PoolIcon *icon=[iconArray objectAtIndex:j];
			
			if(![(UIImageView*)[icon m_CheckImage] isHidden])
			{
				return YES;
			}
		}
	}
	
	return NO;
}

-(void)SaveIconDataToPoolTableWithPoolTableName:(NSString*)poolTableName WithIconName:(NSString*)iconName WithIconLableName:(NSString*)iconLableName 
									WithTypeTag:(NSString*)typeTag WithQuantity:(NSUInteger)quantity
{
	[(DataController*)[mDelegate m_DataController] SaveIconDataToPoolTable:poolTableName WithIconName:iconName WithIconLableName:iconLableName 
															   WithTypeTag:typeTag WithQuantity:quantity];
}

-(void)DeleteIconDataFromPoolTableWithIconName:(NSString*)iconName
{
	[(DataController*)[mDelegate m_DataController] DeleteIconDataFromPoolTable:self.m_PageName WithIconName:iconName];
}

//new
-(void)AddIconWithIconName:(NSString*)iconName WithLableName:(NSString*)lableName WithDraggable:(BOOL)draggable WithDangerousTag:(NSString*)dangerousTag WithVisible:(BOOL)visible
			 WithSortIndex:(NSUInteger)sortIndex WithTypeTag:(NSString*)typeTag WithBehaviour:(BOOL)behaviour WithAction:(NSString*)action
			 WithImageName:(NSString*)fileName WithMenuColor:(NSString*)menuColor WithBackgroundColor:(UIColor*)mBackgroundColor 
			 WithWallpaper:(NSString*)wallpaper WithThemeSet:(NSString*)themeSet WithCustomize:(BOOL)customize WithParentPageView:(ItemPageView*)parentPage
			 WithIconIndex:(NSUInteger)iconIndex
{
	PoolIcon *icon=[PoolIcon alloc];
	
	if([typeTag compare:@"task"]==0)
	{
		//run through all row and check item container  if less than 4 items then add one to it
		for(int i=0; i<[m_TaskRowContainer count]; i++)
		{
			//retrieve item container
			NSMutableArray *itemContainer=[m_TaskRowContainer objectAtIndex:i];
			
			//check if item container is less than 4 item
			if([itemContainer count]<4)
			{
				//get rect of last icon in this item container
				CGRect lastOneRect=[(PoolIcon*)[itemContainer objectAtIndex:[itemContainer count]-1] frame];
				
				//add one to it
	
				//set delegate
				[icon setMDelegate:self.mDelegate];
				[icon setM_ItemBelongPageView:parentPage];
				//initialize pool icon
				[icon InitWithIconName:iconName WithLableName:lableName WithDraggable:draggable WithDangerousTag:dangerousTag 
						   WithVisible:visible WithSortIndex:sortIndex WithTypeTag:typeTag WithBeaviour:behaviour 
							WithAction:action WithFileName:fileName WithMenuColor:menuColor WithBackgroundColor:mBackgroundColor WithWallpaper:wallpaper 
						  WithThemeSet:themeSet
					  WithCustomizeTag:customize WithFrame:CGRectMake(lastOneRect.origin.x+60, lastOneRect.origin.y, 60, 60)];
				[icon setM_IconIndex:iconIndex];
				[icon setHidden:YES];
				
				[self addSubview:icon];
				[itemContainer addObject:icon];
				
				//save icon data to database
				if([(PoolView*)[mDelegate m_PoolView] m_SavedOn])
				{
					[self SaveIconDataToPoolTableWithPoolTableName:self.m_PageName WithIconName:icon.m_Name WithIconLableName:icon.m_LableName 
													   WithTypeTag:icon.m_TypeTag WithQuantity:0];
				}

				
				//update content size
				[self UpdateContentSizeWithIconWidth:60];
				
				[self ManageVisibleIcons:icon];
				
				[(PoolView*)[mDelegate m_PoolView] ShouldShowEmpty];
				
				return;
			}
		}
		
		
		
		//all item container are full need to make a new one and add one icon to it
		NSMutableArray *itemContainer=[[NSMutableArray alloc] init];
		
		
		//get rect of icon in first place in last item container
		if([m_TaskRowContainer count]==0)
		{
			//no last icon
			
			//create icon

			//set delegate
			[icon setMDelegate:self.mDelegate];
			[icon setM_ItemBelongPageView:parentPage];
			//initialize pool icon
			[icon InitWithIconName:iconName WithLableName:lableName WithDraggable:draggable WithDangerousTag:dangerousTag 
					   WithVisible:visible WithSortIndex:sortIndex WithTypeTag:typeTag WithBeaviour:behaviour 
						WithAction:action WithFileName:fileName WithMenuColor:menuColor WithBackgroundColor:mBackgroundColor WithWallpaper:wallpaper
						 WithThemeSet:themeSet WithCustomizeTag:customize WithFrame:CGRectMake(0, 0, 60, 60)];
			[icon setM_IconIndex:iconIndex];
			[icon setHidden:YES];
			
			[self addSubview:icon];
			[itemContainer addObject:icon];
			
			//add new item container to row container
			[m_TaskRowContainer addObject:itemContainer];
			[itemContainer release];
			
			//save icon data to database
			if([(PoolView*)[mDelegate m_PoolView] m_SavedOn])
			{
				[self SaveIconDataToPoolTableWithPoolTableName:self.m_PageName WithIconName:icon.m_Name WithIconLableName:icon.m_LableName 
												   WithTypeTag:icon.m_TypeTag WithQuantity:0];
			}
		}
		else 
		{
			CGRect lastIconRect=[(PoolIcon*)[[m_TaskRowContainer objectAtIndex:[m_TaskRowContainer count]-1] objectAtIndex:0] frame];
			
			//create icon

			//set delegate
			[icon setMDelegate:self.mDelegate];
			[icon setM_ItemBelongPageView:parentPage];
			//initialize pool icon
			[icon InitWithIconName:iconName WithLableName:lableName WithDraggable:draggable WithDangerousTag:dangerousTag 
					   WithVisible:visible WithSortIndex:sortIndex WithTypeTag:typeTag WithBeaviour:behaviour 
						WithAction:action WithFileName:fileName WithMenuColor:menuColor WithBackgroundColor:mBackgroundColor WithWallpaper:wallpaper
						  WithThemeSet:themeSet WithCustomizeTag:customize WithFrame:CGRectMake(lastIconRect.origin.x, lastIconRect.origin.y+60, 60, 60)];
			[icon setM_IconIndex:iconIndex];
			[icon setHidden:YES];
			
			[self addSubview:icon];
			[itemContainer addObject:icon];
			
			//add new item container to row container
			[m_TaskRowContainer addObject:itemContainer];
			[itemContainer release];
			
			//save icon data to database
			if([(PoolView*)[mDelegate m_PoolView] m_SavedOn])
			{
				[self SaveIconDataToPoolTableWithPoolTableName:self.m_PageName WithIconName:icon.m_Name WithIconLableName:icon.m_LableName 
												   WithTypeTag:icon.m_TypeTag WithQuantity:0];
			}
		}
		
		
		
		//update content size
		[self UpdateContentSizeWithIconWidth:60];
		
		[self ManageVisibleIcons:icon];
		
		[(PoolView*)[mDelegate m_PoolView] ShouldShowEmpty];
	}
	else if([typeTag compare:@"item"]==0)
	{
		//run through all row and check item container  if less than 4 items then add one to it
		for(int i=0; i<[m_ItemRowContainer count]; i++)
		{
			//retrieve item container
			NSMutableArray *itemContainer=[m_ItemRowContainer objectAtIndex:i];
			
			//check if item container is less than 4 item
			if([itemContainer count]<4)
			{
				//get rect of last icon in this item container
				CGRect lastOneRect=[(PoolIcon*)[itemContainer objectAtIndex:[itemContainer count]-1] frame];
				
				//add one to it
	
				//set delegate
				[icon setMDelegate:self.mDelegate];
				[icon setM_ItemBelongPageView:parentPage];
				//initialize pool icon
				[icon InitWithIconName:iconName WithLableName:lableName WithDraggable:draggable WithDangerousTag:dangerousTag 
						   WithVisible:visible WithSortIndex:sortIndex WithTypeTag:typeTag WithBeaviour:behaviour 
							WithAction:action WithFileName:fileName WithMenuColor:menuColor WithBackgroundColor:mBackgroundColor WithWallpaper:wallpaper
							 WithThemeSet:themeSet WithCustomizeTag:customize WithFrame:CGRectMake(lastOneRect.origin.x+60, lastOneRect.origin.y, 60, 60)];
				[icon setM_IconIndex:iconIndex];
				[icon setHidden:YES];
				
				[self addSubview:icon];
				[itemContainer addObject:icon];
				
				//save icon data to database
				if([(PoolView*)[mDelegate m_PoolView] m_SavedOn])
				{
					[self SaveIconDataToPoolTableWithPoolTableName:self.m_PageName WithIconName:icon.m_Name WithIconLableName:icon.m_LableName 
													   WithTypeTag:icon.m_TypeTag WithQuantity:0];
				}
				
				//update content size
				[self UpdateContentSizeWithIconWidth:60];
				
				[self ManageVisibleIcons:icon];
				
				[(PoolView*)[mDelegate m_PoolView] ShouldShowEmpty];
				
				return;
			}
		}
		
		
		
		//all item container are full need to make a new one and add one icon to it
		NSMutableArray *itemContainer=[[NSMutableArray alloc] init];
		
		
		//get rect of icon in first place in last item container
		if([m_ItemRowContainer count]==0)
		{
			//no last icon
			
			//create icon

			//set delegate
			[icon setMDelegate:self.mDelegate];
			[icon setM_ItemBelongPageView:parentPage];
			//initialize pool icon
			[icon InitWithIconName:iconName WithLableName:lableName WithDraggable:draggable WithDangerousTag:dangerousTag 
					   WithVisible:visible WithSortIndex:sortIndex WithTypeTag:typeTag WithBeaviour:behaviour 
						WithAction:action WithFileName:fileName WithMenuColor:menuColor WithBackgroundColor:mBackgroundColor WithWallpaper:wallpaper
						 WithThemeSet:themeSet WithCustomizeTag:customize WithFrame:CGRectMake(0, 0, 60, 60)];
			[icon setM_IconIndex:iconIndex];
			[icon setHidden:YES];
			
			[self addSubview:icon];
			[itemContainer addObject:icon];
			
			//add new item container to row container
			[m_ItemRowContainer addObject:itemContainer];
			[itemContainer release];
			
			//save icon data to database
			if([(PoolView*)[mDelegate m_PoolView] m_SavedOn])
			{
				[self SaveIconDataToPoolTableWithPoolTableName:self.m_PageName WithIconName:icon.m_Name WithIconLableName:icon.m_LableName 
												   WithTypeTag:icon.m_TypeTag WithQuantity:0];
			}
		}
		else 
		{
			CGRect lastIconRect=[(PoolIcon*)[[m_ItemRowContainer objectAtIndex:[m_ItemRowContainer count]-1] objectAtIndex:0] frame];
			
			//create icon

			//set delegate
			[icon setMDelegate:self.mDelegate];
			[icon setM_ItemBelongPageView:parentPage];
			//initialize pool icon
			[icon InitWithIconName:iconName WithLableName:lableName WithDraggable:draggable WithDangerousTag:dangerousTag 
					   WithVisible:visible WithSortIndex:sortIndex WithTypeTag:typeTag WithBeaviour:behaviour 
						WithAction:action WithFileName:fileName WithMenuColor:menuColor WithBackgroundColor:mBackgroundColor WithWallpaper:wallpaper
						 WithThemeSet:themeSet WithCustomizeTag:customize WithFrame:CGRectMake(lastIconRect.origin.x, lastIconRect.origin.y+60, 60, 60)];
			[icon setM_IconIndex:iconIndex];
			[icon setHidden:YES];
			
			[self addSubview:icon];
			[itemContainer addObject:icon];
			
			//add new item container to row container
			[m_ItemRowContainer addObject:itemContainer];
			[itemContainer release];
			
			//save icon data to database
			if([(PoolView*)[mDelegate m_PoolView] m_SavedOn])
			{
				[self SaveIconDataToPoolTableWithPoolTableName:self.m_PageName WithIconName:icon.m_Name WithIconLableName:icon.m_LableName 
												   WithTypeTag:icon.m_TypeTag WithQuantity:0];
			}
		}
		
	
		//update content size
		[self UpdateContentSizeWithIconWidth:60];
		
		[self ManageVisibleIcons:icon];
		
		[(PoolView*)[mDelegate m_PoolView] ShouldShowEmpty];
	}

	[self RedrawPoolIcons];

}

-(void)AddIconWithIconName:(NSString*)iconName WithLableName:(NSString*)lableName WithDraggable:(BOOL)draggable WithDangerousTag:(NSString*)dangerousTag WithVisible:(BOOL)visible
			 WithSortIndex:(NSUInteger)sortIndex WithTypeTag:(NSString*)typeTag WithBehaviour:(BOOL)behaviour WithAction:(NSString*)action
			 WithImageName:(NSString*)fileName WithMenuColor:(NSString*)menuColor WithBackgroundColor:(UIColor*)mBackgroundColor 
			 WithWallpaper:(NSString*)wallpaper WithThemeSet:(NSString*)themeSet WithCustomize:(BOOL)customize WithParentPageView:(ItemPageView*)parentPage
			 WithIconIndex:(NSUInteger)iconIndex WithQuantity:(int)quantity;
{
	PoolIcon *icon=[PoolIcon alloc];
	
	if([typeTag compare:@"task"]==0)
	{
		//run through all row and check item container  if less than 4 items then add one to it
		for(int i=0; i<[m_TaskRowContainer count]; i++)
		{
			//retrieve item container
			NSMutableArray *itemContainer=[m_TaskRowContainer objectAtIndex:i];
			
			//check if item container is less than 4 item
			if([itemContainer count]<4)
			{
				//get rect of last icon in this item container
				CGRect lastOneRect=[(PoolIcon*)[itemContainer objectAtIndex:[itemContainer count]-1] frame];
				
				//add one to it
				
				//set delegate
				[icon setMDelegate:self.mDelegate];
				[icon setM_ItemBelongPageView:parentPage];
				//initialize pool icon
				[icon InitWithIconName:iconName WithLableName:lableName WithDraggable:draggable WithDangerousTag:dangerousTag 
						   WithVisible:visible WithSortIndex:sortIndex WithTypeTag:typeTag WithBeaviour:behaviour 
							WithAction:action WithFileName:fileName WithMenuColor:menuColor WithBackgroundColor:mBackgroundColor WithWallpaper:wallpaper 
						  WithThemeSet:themeSet
					  WithCustomizeTag:customize WithFrame:CGRectMake(lastOneRect.origin.x+60, lastOneRect.origin.y, 60, 60)];
				[icon setM_IconIndex:iconIndex];
				[icon SetQuantity:quantity];
				[icon setHidden:YES];
				
				[self addSubview:icon];
				[itemContainer addObject:icon];
				
				//save icon data to database
				if([(PoolView*)[mDelegate m_PoolView] m_SavedOn])
				{
					[self SaveIconDataToPoolTableWithPoolTableName:self.m_PageName WithIconName:icon.m_Name WithIconLableName:icon.m_LableName 
													   WithTypeTag:icon.m_TypeTag WithQuantity:0];
				}
				
				
				//update content size
				[self UpdateContentSizeWithIconWidth:60];
				
				[self ManageVisibleIcons:icon];
				
				[(PoolView*)[mDelegate m_PoolView] ShouldShowEmpty];
				
				return;
			}
		}
		
		
		
		//all item container are full need to make a new one and add one icon to it
		NSMutableArray *itemContainer=[[NSMutableArray alloc] init];
		
		
		//get rect of icon in first place in last item container
		if([m_TaskRowContainer count]==0)
		{
			//no last icon
			
			//create icon
			
			//set delegate
			[icon setMDelegate:self.mDelegate];
			[icon setM_ItemBelongPageView:parentPage];
			//initialize pool icon
			[icon InitWithIconName:iconName WithLableName:lableName WithDraggable:draggable WithDangerousTag:dangerousTag 
					   WithVisible:visible WithSortIndex:sortIndex WithTypeTag:typeTag WithBeaviour:behaviour 
						WithAction:action WithFileName:fileName WithMenuColor:menuColor WithBackgroundColor:mBackgroundColor WithWallpaper:wallpaper
					  WithThemeSet:themeSet WithCustomizeTag:customize WithFrame:CGRectMake(0, 0, 60, 60)];
			[icon setM_IconIndex:iconIndex];
			[icon SetQuantity:quantity];
			[icon setHidden:YES];
			
			[self addSubview:icon];
			[itemContainer addObject:icon];
			
			//add new item container to row container
			[m_TaskRowContainer addObject:itemContainer];
			[itemContainer release];
			
			//save icon data to database
			if([(PoolView*)[mDelegate m_PoolView] m_SavedOn])
			{
				[self SaveIconDataToPoolTableWithPoolTableName:self.m_PageName WithIconName:icon.m_Name WithIconLableName:icon.m_LableName 
												   WithTypeTag:icon.m_TypeTag WithQuantity:0];
			}
		}
		else 
		{
			CGRect lastIconRect=[(PoolIcon*)[[m_TaskRowContainer objectAtIndex:[m_TaskRowContainer count]-1] objectAtIndex:0] frame];
			
			//create icon
			
			//set delegate
			[icon setMDelegate:self.mDelegate];
			[icon setM_ItemBelongPageView:parentPage];
			//initialize pool icon
			[icon InitWithIconName:iconName WithLableName:lableName WithDraggable:draggable WithDangerousTag:dangerousTag 
					   WithVisible:visible WithSortIndex:sortIndex WithTypeTag:typeTag WithBeaviour:behaviour 
						WithAction:action WithFileName:fileName WithMenuColor:menuColor WithBackgroundColor:mBackgroundColor WithWallpaper:wallpaper
					  WithThemeSet:themeSet WithCustomizeTag:customize WithFrame:CGRectMake(lastIconRect.origin.x, lastIconRect.origin.y+60, 60, 60)];
			[icon setM_IconIndex:iconIndex];
			[icon SetQuantity:quantity];
			[icon setHidden:YES];
			
			[self addSubview:icon];
			[itemContainer addObject:icon];
			
			//add new item container to row container
			[m_TaskRowContainer addObject:itemContainer];
			[itemContainer release];
			
			//save icon data to database
			if([(PoolView*)[mDelegate m_PoolView] m_SavedOn])
			{
				[self SaveIconDataToPoolTableWithPoolTableName:self.m_PageName WithIconName:icon.m_Name WithIconLableName:icon.m_LableName 
												   WithTypeTag:icon.m_TypeTag WithQuantity:0];
			}
		}
		
		
		
		//update content size
		[self UpdateContentSizeWithIconWidth:60];
		
		[self ManageVisibleIcons:icon];
		
		[(PoolView*)[mDelegate m_PoolView] ShouldShowEmpty];
	}
	else if([typeTag compare:@"item"]==0)
	{
		//run through all row and check item container  if less than 4 items then add one to it
		for(int i=0; i<[m_ItemRowContainer count]; i++)
		{
			//retrieve item container
			NSMutableArray *itemContainer=[m_ItemRowContainer objectAtIndex:i];
			
			//check if item container is less than 4 item
			if([itemContainer count]<4)
			{
				//get rect of last icon in this item container
				CGRect lastOneRect=[(PoolIcon*)[itemContainer objectAtIndex:[itemContainer count]-1] frame];
				
				//add one to it
				
				//set delegate
				[icon setMDelegate:self.mDelegate];
				[icon setM_ItemBelongPageView:parentPage];
				//initialize pool icon
				[icon InitWithIconName:iconName WithLableName:lableName WithDraggable:draggable WithDangerousTag:dangerousTag 
						   WithVisible:visible WithSortIndex:sortIndex WithTypeTag:typeTag WithBeaviour:behaviour 
							WithAction:action WithFileName:fileName WithMenuColor:menuColor WithBackgroundColor:mBackgroundColor WithWallpaper:wallpaper
						  WithThemeSet:themeSet WithCustomizeTag:customize WithFrame:CGRectMake(lastOneRect.origin.x+60, lastOneRect.origin.y, 60, 60)];
				[icon setM_IconIndex:iconIndex];
				[icon SetQuantity:quantity];
				[icon setHidden:YES];
				
				[self addSubview:icon];
				[itemContainer addObject:icon];
				
				//save icon data to database
				if([(PoolView*)[mDelegate m_PoolView] m_SavedOn])
				{
					[self SaveIconDataToPoolTableWithPoolTableName:self.m_PageName WithIconName:icon.m_Name WithIconLableName:icon.m_LableName 
													   WithTypeTag:icon.m_TypeTag WithQuantity:0];
				}
				
				//update content size
				[self UpdateContentSizeWithIconWidth:60];
				
				[self ManageVisibleIcons:icon];
				
				[(PoolView*)[mDelegate m_PoolView] ShouldShowEmpty];
				
				return;
			}
		}
		
		
		
		//all item container are full need to make a new one and add one icon to it
		NSMutableArray *itemContainer=[[NSMutableArray alloc] init];
		
		
		//get rect of icon in first place in last item container
		if([m_ItemRowContainer count]==0)
		{
			//no last icon
			
			//create icon
			
			//set delegate
			[icon setMDelegate:self.mDelegate];
			[icon setM_ItemBelongPageView:parentPage];
			//initialize pool icon
			[icon InitWithIconName:iconName WithLableName:lableName WithDraggable:draggable WithDangerousTag:dangerousTag 
					   WithVisible:visible WithSortIndex:sortIndex WithTypeTag:typeTag WithBeaviour:behaviour 
						WithAction:action WithFileName:fileName WithMenuColor:menuColor WithBackgroundColor:mBackgroundColor WithWallpaper:wallpaper
					  WithThemeSet:themeSet WithCustomizeTag:customize WithFrame:CGRectMake(0, 0, 60, 60)];
			[icon setM_IconIndex:iconIndex];
			[icon SetQuantity:quantity];
			[icon setHidden:YES];
			
			[self addSubview:icon];
			[itemContainer addObject:icon];
			
			//add new item container to row container
			[m_ItemRowContainer addObject:itemContainer];
			[itemContainer release];
			
			//save icon data to database
			if([(PoolView*)[mDelegate m_PoolView] m_SavedOn])
			{
				[self SaveIconDataToPoolTableWithPoolTableName:self.m_PageName WithIconName:icon.m_Name WithIconLableName:icon.m_LableName 
												   WithTypeTag:icon.m_TypeTag WithQuantity:0];
			}
		}
		else 
		{
			CGRect lastIconRect=[(PoolIcon*)[[m_ItemRowContainer objectAtIndex:[m_ItemRowContainer count]-1] objectAtIndex:0] frame];
			
			//create icon
			
			//set delegate
			[icon setMDelegate:self.mDelegate];
			[icon setM_ItemBelongPageView:parentPage];
			//initialize pool icon
			[icon InitWithIconName:iconName WithLableName:lableName WithDraggable:draggable WithDangerousTag:dangerousTag 
					   WithVisible:visible WithSortIndex:sortIndex WithTypeTag:typeTag WithBeaviour:behaviour 
						WithAction:action WithFileName:fileName WithMenuColor:menuColor WithBackgroundColor:mBackgroundColor WithWallpaper:wallpaper
					  WithThemeSet:themeSet WithCustomizeTag:customize WithFrame:CGRectMake(lastIconRect.origin.x, lastIconRect.origin.y+60, 60, 60)];
			[icon setM_IconIndex:iconIndex];
			[icon SetQuantity:quantity];
			[icon setHidden:YES];
			
			[self addSubview:icon];
			[itemContainer addObject:icon];
			
			//add new item container to row container
			[m_ItemRowContainer addObject:itemContainer];
			[itemContainer release];
			
			//save icon data to database
			if([(PoolView*)[mDelegate m_PoolView] m_SavedOn])
			{
				[self SaveIconDataToPoolTableWithPoolTableName:self.m_PageName WithIconName:icon.m_Name WithIconLableName:icon.m_LableName 
												   WithTypeTag:icon.m_TypeTag WithQuantity:0];
			}
		}
		
		
		//update content size
		[self UpdateContentSizeWithIconWidth:60];
		
		[self ManageVisibleIcons:icon];
		
		[(PoolView*)[mDelegate m_PoolView] ShouldShowEmpty];
	}
	
	[self RedrawPoolIcons];
}

-(void)DeleteIcon:(PoolIcon*)icon
{
	//find the same icon to given one and remove it(don't delete it)
	for(int i=0; i<[m_TaskRowContainer count]; i++)
	{
		//retrieve task container
		NSMutableArray *taskContainer=[m_TaskRowContainer objectAtIndex:i];
		
		for(int j=0; j<[taskContainer count]; j++)
		{
			//check if icon in task container is as same as given one
			if(icon==[taskContainer objectAtIndex:j])
			{
				//same as given icon remove it
				[icon removeFromSuperview];
				[taskContainer removeObject:icon];
				break;
			}
		}
	}
	
	for(int i=0; i<[m_ItemRowContainer count]; i++)
	{
		//retrieve item container
		NSMutableArray *itemContainer=[m_ItemRowContainer objectAtIndex:i];
		
		for(int j=0; j<[itemContainer count]; j++)
		{
			//check if icon in item container is as same as given one
			if(icon==[itemContainer objectAtIndex:j])
			{
				//same as given icon remove it
				[icon removeFromSuperview];
				[itemContainer removeObject:icon];
				break;
			}
		}
	}
	
	//delete from database
	[self DeleteIconDataFromPoolTableWithIconName:[icon m_Name]];
	
	//clear empty item container
	[self ClearAllEmptyContainer];
	
	//once icon been deleted call SortIcons method to rearrange icon into correct container
	[self SortIcons];
	
	//update content size
	[self UpdateContentSizeWithIconWidth:60];
}

-(void)Reset
{
	for(int i=0; i<[m_TaskRowContainer count]; i++)
	{
		//retrieve task container
		NSMutableArray *taskContainer=[m_TaskRowContainer objectAtIndex:i];
		
		while([taskContainer count]!=0)
		{
			//get task icon 
			PoolIcon *icon=[taskContainer lastObject];
			
			[taskContainer removeLastObject];
			
			[icon removeFromSuperview];
			
			//tell icon to reset
			[icon Reset];
			
			
			
		}
	}
	
	for(int i=0; i<[m_ItemRowContainer count]; i++)
	{
		//retrieve item container
		NSMutableArray *itemContainer=[m_ItemRowContainer objectAtIndex:i];
		
		while([itemContainer count]!=0)
		{
			//get item icon 
			PoolIcon *icon=[itemContainer lastObject];
			
			[itemContainer removeLastObject];
			
			[icon removeFromSuperview];
			
			//tell icon to reset
			[icon Reset];
			
			
		}
		
	}
	
	[m_TaskRowContainer removeAllObjects];
	[m_ItemRowContainer removeAllObjects];
	
	//update content size
	[self UpdateContentSizeWithIconWidth:60];
}

-(void)ClearAllEmptyContainer
{
	//editable
	if([m_TaskRowContainer count]!=0)
	{
		if([[m_TaskRowContainer lastObject] count]==0)
		{
			[m_TaskRowContainer removeLastObject];
			
		}
	}

	
	if([m_ItemRowContainer count]!=0)
	{
		if([[m_ItemRowContainer lastObject] count]==0)
		{
			[m_ItemRowContainer removeLastObject];
			
		}
	}

}

-(void)SortIcons
{
	for(int i=0; i<[m_TaskRowContainer count]; i++)
	{
		//retrieve item container
		NSMutableArray *itemContainer=[m_TaskRowContainer objectAtIndex:i];
		
		//check if item container is less than 4
		if([itemContainer count]<4)
		{
			//get first icon in next item container and put in this item container
			//but need to check there has next item container
			int val=i+1;
			if(val>[m_TaskRowContainer count]-1)
			{
				//don't have next item container break from loop
				break;
			}
			else
			{
				//has next item container
				//get first icon 
				PoolIcon *icon=[[m_TaskRowContainer objectAtIndex:i+1] objectAtIndex:0];
				
				//remove form next item container(don't delete it)
				[[m_TaskRowContainer objectAtIndex:i+1] removeObjectAtIndex:0];
				
				//add icon to this item container
				[itemContainer addObject:icon];
				
				//clear empty item container otherwise cause crash
				[self ClearAllEmptyContainer];
			}

		}
	}
	
	for(int i=0; i<[m_ItemRowContainer count]; i++)
	{
		//retrieve item container
		NSMutableArray *itemContainer=[m_ItemRowContainer objectAtIndex:i];
		
		//check if item container is less than 4
		if([itemContainer count]<4)
		{
			//get first icon in next item container and put in this item container
			//but need to check there has next item container
			int val=i+1;
			if(val>[m_ItemRowContainer count]-1)
			{
				//don't have next item container break from loop
				break;
			}
			else
			{
				//has next item container
				//get first icon 
				PoolIcon *icon=[[m_ItemRowContainer objectAtIndex:i+1] objectAtIndex:0];
				
				//remove form next item container(don't delete it)
				[[m_ItemRowContainer objectAtIndex:i+1] removeObjectAtIndex:0];
				
				//add icon to this item container
				[itemContainer addObject:icon];
				
				//clear empty item container otherwise cause crash
				[self ClearAllEmptyContainer];
			}
			
		}
	}
	
	//call RedrawPoolIcons to make each icons to be reposition into new position
	[self RedrawPoolIcons];
	
	//Update content size
	[self UpdateContentSizeWithIconWidth:60];
}

-(void)RedrawPoolIcons
{
	[UIView beginAnimations:@"back" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	for(int i=0; i<[m_TaskRowContainer count]; i++)
	{
		//retrieve item container
		NSMutableArray *itemContainer=[m_TaskRowContainer objectAtIndex:i];
		
		//reposition icons 
		for(int j=0; j<[itemContainer count]; j++)
		{
			//get icon 
			PoolIcon *icon=[itemContainer objectAtIndex:j];
			
			//set icon into correct position
			[icon setFrame:CGRectMake(j*60, i*60, 60, 60)];
			
			//must update origin rect it self
			[icon setM_OriginRect:icon.frame];
		}
	}
	
	//get total task icons height
	int taskHeight=[m_TaskRowContainer count]*60;
	
	for(int i=0; i<[m_ItemRowContainer count]; i++)
	{
		//retrieve item container
		NSMutableArray *itemContainer=[m_ItemRowContainer objectAtIndex:i];
		
		//reposition icons 
		for(int j=0; j<[itemContainer count]; j++)
		{
			//get icon 
			PoolIcon *icon=[itemContainer objectAtIndex:j];
			
			//set icon into correct position
			[icon setFrame:CGRectMake(j*60, i*60+taskHeight, 60, 60)];
			
			//must update origin rect it self
			[icon setM_OriginRect:icon.frame];
		}
	}

	
	[UIView commitAnimations];
	
	[self ManageVisibleIcons];
}

-(void)UpdateContentSizeWithIconWidth:(int)iconWidth;
{
	CGSize mSize=CGSizeMake(self.frame.size.width, [m_TaskRowContainer count]*iconWidth + [m_ItemRowContainer count]*iconWidth);
	
	[self setContentSize:mSize];
	
}

-(void)SwapIconByFirstIconRowIndex:(NSUInteger)firstRowIndex WithFirstIconColoumnIndex:(NSUInteger)
												firstColoumnIndex WithSecondIconRowIndex:(NSUInteger)secondRowIndex 
												WithSecondIconColoumnIndex:(NSUInteger)secondColoumnIndex
												WithPoolPageRowContainer:(NSMutableArray*)container
{
	//change icon pointer in container
	PoolIcon *firstIcon=[[container objectAtIndex:firstRowIndex] objectAtIndex:firstColoumnIndex];
	PoolIcon *secondIcon=[[container objectAtIndex:secondRowIndex] objectAtIndex:secondColoumnIndex];
	PoolIcon *temp=firstIcon;
	
	//replace first by second
	[[container objectAtIndex:firstRowIndex] replaceObjectAtIndex:firstColoumnIndex withObject:secondIcon];
	//replace second by temp which is first
	[[container objectAtIndex:secondRowIndex] replaceObjectAtIndex:secondColoumnIndex withObject:temp];
	
	
	//change both icons original rect to each other
	CGRect tempRect=[firstIcon m_OriginRect];
	[firstIcon setM_OriginRect:[secondIcon m_OriginRect]];
	[secondIcon setM_OriginRect:tempRect];
	
}

-(void)InitRowContainer;
{
	//init row container
	NSMutableArray *taskRowContainer=[[NSMutableArray alloc] init];
	self.m_TaskRowContainer=taskRowContainer;
	[taskRowContainer release];
	
	NSMutableArray *itemRowContainer=[[NSMutableArray alloc] init];
	self.m_ItemRowContainer=itemRowContainer;
	[itemRowContainer release];
	
	/*
	//add some item for test
	for(int i=0; i<10; i++)
	{
		NSMutableArray *itemContainer=[[NSMutableArray alloc] init];
		
		for(int j=0; j<4; j++)
		{
			PoolIcon *icon=[PoolIcon alloc];
			[icon setMDelegate:self.mDelegate];
			[icon InitWithImage:[UIImage imageNamed:@"Cap.png"] WithRect:CGRectMake(j*60, i*60, 60, 60)];
			[icon setM_Draggable:YES];
			[itemContainer addObject:icon];
			
			[self addSubview:icon];
		}
		
		[m_PageRowContainer addObject:itemContainer];
	}
	 */
	 
}

-(void)Sort
{
	//sort task
	NSMutableArray *taskIconsContainer=[[NSMutableArray alloc] init];
	NSMutableArray *customTaskIconsContainer=[[NSMutableArray alloc] init];
	NSMutableArray *itemIconsContainer=[[NSMutableArray alloc] init];
	NSMutableArray *customItemIconsContainer=[[NSMutableArray alloc] init];
	
	//categories icons task
	for(int i=0; i<[m_TaskRowContainer count]; i++)
	{
		NSMutableArray *taskContainer=[m_TaskRowContainer objectAtIndex:i];
		
		for(int j=0; j<[taskContainer count]; j++)
		{
			PoolIcon *icon=[taskContainer objectAtIndex:j];
			
			if([icon m_Customize])
			{
				//icon is custom
				[customTaskIconsContainer addObject:icon];
			}
			else 
			{
				//icon is not custom
				[taskIconsContainer addObject:icon];
			}

		}
	}
	
	//categories icons item
	for(int i=0; i<[m_ItemRowContainer count]; i++)
	{
		NSMutableArray *itemContainer=[m_ItemRowContainer objectAtIndex:i];
		
		for(int j=0; j<[itemContainer count]; j++)
		{
			PoolIcon *icon=[itemContainer objectAtIndex:j];
			
			if([icon m_Customize])
			{
				//icon is custom
				[customItemIconsContainer addObject:icon];
			}
			else 
			{
				//icon is not custom
				[itemIconsContainer addObject:icon];
			}
			
		}
	}
	
	//do quick sort task
	if([taskIconsContainer count]!=0)
	{
		[self QuickSort:taskIconsContainer WithLeft:0 WithRight:[taskIconsContainer count]-1];
	}
	
	//do quick sort item
	if([itemIconsContainer count]!=0)
	{
		[self QuickSort:itemIconsContainer WithLeft:0 WithRight:[itemIconsContainer count]-1];
	}
	
	
	
	//append array task icons container and custom task container
	while([customTaskIconsContainer count]!=0)
	{
		PoolIcon *customIcon=[customTaskIconsContainer objectAtIndex:0];
		
		//add to task icon container
		[taskIconsContainer addObject:customIcon];
		
		//remove icon from custom task icon container
		[customTaskIconsContainer removeObjectAtIndex:0];
	}
	
	//append array item icons container and custom item container
	while([customItemIconsContainer count]!=0)
	{
		PoolIcon *customIcon=[customItemIconsContainer objectAtIndex:0];
		
		//add to task icon container
		[itemIconsContainer	addObject:customIcon];
		
		//remove icon from custom task icon container
		[customItemIconsContainer removeObjectAtIndex:0];
	}
	
	
	[customTaskIconsContainer release];
	[customItemIconsContainer release];
	
	
	//replace icon to original array
	int k=0;
	
	for(int i=0; i<[m_TaskRowContainer count]; i++)
	{
		NSMutableArray *taskRowContainer=[m_TaskRowContainer objectAtIndex:i];
		
		for(int j=0; j<[taskRowContainer count]; j++)
		{
			[taskRowContainer replaceObjectAtIndex:j withObject:[taskIconsContainer objectAtIndex:k]];
			k++;
		}
	}
	
	k=0;
	
	for(int i=0; i<[m_ItemRowContainer count]; i++)
	{
		NSMutableArray *itemRowContainer=[m_ItemRowContainer objectAtIndex:i];
		
		for(int j=0; j<[itemRowContainer count]; j++)
		{
			[itemRowContainer replaceObjectAtIndex:j withObject:[itemIconsContainer objectAtIndex:k]];
			k++;
		}
	}

	
	[taskIconsContainer removeAllObjects];
	[taskIconsContainer release];
	[itemIconsContainer removeAllObjects];
	[itemIconsContainer release];
	
	//redraw icons
	[self RedrawPoolIcons];
}

-(void)QuickSort:(NSMutableArray*)mutableArray WithLeft:(int)left WithRight:(int)right
{
	int i=left;
	int j=right;
	PoolIcon *temp;
	int pivot=[(PoolIcon*)[mutableArray objectAtIndex:(left+right)/2] m_SortIndex];
	
	//partition
	while(i<=j) 
	{
		int sortIndex;
		
		//left
		while(TRUE) 
		{
			sortIndex=[(PoolIcon*)[mutableArray objectAtIndex:i] m_SortIndex];
			
			if(sortIndex<pivot)
			{
				i++;
			}
			else 
			{
				break;
			}
		}
		

		
		//right
		while(TRUE)
		{
			sortIndex=[(PoolIcon*)[mutableArray objectAtIndex:j] m_SortIndex];
			
			if(sortIndex>pivot)
			{
				j--;
			}
			else 
			{
				break;
			}
		}
		
		if(i<=j)
		{
			temp=[mutableArray objectAtIndex:i];
			[mutableArray replaceObjectAtIndex:i withObject:[mutableArray objectAtIndex:j]];
			[mutableArray replaceObjectAtIndex:j withObject:temp];
			i++;
			j--;
		}
		
	}
	
	if(left<j)
	{
		[self QuickSort:mutableArray WithLeft:left WithRight:j];
	}
	
	if(right>i)
	{
		[self QuickSort:mutableArray WithLeft:i WithRight:right];
	}
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

-(id)InitWithPageNumber:(int)pageNum WithPageName:(NSString*)pageName WithFrame:(CGRect)viewFrame;
{
	if(self=[super initWithFrame:viewFrame])
	{
		m_OriginRect=viewFrame;
		
		m_PageNumber=pageNum;
		
		self.m_PageName=pageName;
		
		//set background color
		[self setBackgroundColor:[UIColor clearColor]];
		
		//init row container
		[self InitRowContainer];
		
		//set page scrollview view's properties	
		[self setDelaysContentTouches:NO];
		[self setDirectionalLockEnabled:YES];
		[self setShowsHorizontalScrollIndicator:NO];
		[self setShowsVerticalScrollIndicator:YES];
		[self setDelegate:self];
		[self setOpaque:YES];
		
		//update content size
		[self UpdateContentSizeWithIconWidth:60];
	}
	
	return self;
}

-(void)ManageVisibleIcons
{
	CGRect visibleRect=CGRectMake(0, [self contentOffset].y, self.frame.size.width, self.frame.size.height);
	
	for(int i=0; i<[m_TaskRowContainer count]; i++)
	{
		NSMutableArray *taskRow=[m_TaskRowContainer objectAtIndex:i];
		
		for(int j=0; j<[taskRow count]; j++)
		{
			PoolIcon *icon=[taskRow objectAtIndex:j];
			
			if(CGRectIntersectsRect(visibleRect, [icon m_OriginRect]))
			{
				[icon setHidden:NO];
			}
			else 
			{
				[icon setHidden:YES];
			}

		}
	}
	
	for(int i=0; i<[m_ItemRowContainer count]; i++)
	{
		NSMutableArray *itemRow=[m_ItemRowContainer objectAtIndex:i];
		
		for(int j=0; j<[itemRow count]; j++)
		{
			PoolIcon *icon=[itemRow objectAtIndex:j];
			
			if(CGRectIntersectsRect(visibleRect, [icon m_OriginRect]))
			{
				[icon setHidden:NO];
			}
			else 
			{
				[icon setHidden:YES];
			}
			
		}
	}
}

-(void)ManageVisibleIcons:(PoolIcon*)icon
{
	CGRect visibleRect=CGRectMake(0, [self contentOffset].y, self.frame.size.width, self.frame.size.height);
	
	if(CGRectIntersectsRect(visibleRect, [icon m_OriginRect]))
	{
		[icon setHidden:NO];
	}
	else 
	{
		[icon setHidden:YES];
	}
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	//[(PoolIcon*)[(PoolView*)[mDelegate m_PoolView] m_PoolIcon] TakeFrameBackToOrigin];
	//[NSObject cancelPreviousPerformRequestsWithTarget:[(PoolView*)[mDelegate m_PoolView] m_PoolIcon]];
	[self ManageVisibleIcons];
	NSLog(@"scrollViewDidScroll");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	
	[(PoolIcon*)[(PoolView*)[mDelegate m_PoolView] m_PoolIcon] TakeFrameBackToOrigin];
	[NSObject cancelPreviousPerformRequestsWithTarget:[(PoolView*)[mDelegate m_PoolView] m_PoolIcon]];
	NSLog(@"scrollViewWillBeginDragging");
	
	/*
	if([(PoolView*)[mDelegate m_PoolView] m_PoolIcon])
	{
		[(PoolIcon*)[(PoolView*)[mDelegate m_PoolView] m_PoolIcon] ClearTimer];
	}
	 */
}



- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	if(m_TaskRowContainer!=nil)
	{
		for(int i=0; i<[m_TaskRowContainer count]; i++)
		{
			NSMutableArray * rowContainer=[m_TaskRowContainer objectAtIndex:i];
			
			for(int j=0; j<[rowContainer count]; j++)
			{
				[(PoolIcon*)[rowContainer objectAtIndex:j] removeFromSuperview];
			}
		}
		
		[m_TaskRowContainer removeAllObjects];
		self.m_TaskRowContainer=nil;
	}
	
	if(m_ItemRowContainer!=nil)
	{
		
		for(int i=0; i<[m_ItemRowContainer count]; i++)
		{
			NSMutableArray * rowContainer=[m_ItemRowContainer objectAtIndex:i];
			
			for(int j=0; j<[rowContainer count]; j++)
			{
				[(PoolIcon*)[rowContainer objectAtIndex:j] removeFromSuperview];
			}
		}
		
		[m_ItemRowContainer removeAllObjects];
		self.m_ItemRowContainer=nil;
	}
	
	if(m_PageName!=nil)
	{
		self.m_PageName=nil;
	}
	
    [super dealloc];
}


@end
