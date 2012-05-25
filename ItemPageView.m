//
//  ItemPageView.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemPageView.h"
#import "PackingCheckListAppDelegate.h"
#import "ItemIcon.h"
#import "ItemView.h"
#import "DataController.h"
#import "PoolIcon.h"

@implementation ItemPageView

@synthesize mDelegate;
@synthesize m_PageName;
@synthesize m_PageLableName;
@synthesize m_EmptyIcon;
@synthesize m_PageColumnContainer;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

//new
-(id)InitWithPageNumber:(int)pageNum WithPageName:(NSString*)pageName WithPageLableName:(NSString*)pageLableName WithDelegate:(PackingCheckListAppDelegate*)delegate
{
	if(self=[super initWithFrame:CGRectMake(pageNum*(80-8), 0, 80-8, 360-4)])
	{
		self.mDelegate=delegate;
		m_PageNumber=pageNum;
		self.m_PageName=pageName;
		self.m_PageLableName=pageLableName;
		
		//set background color for page
		[self setBackgroundColor:[UIColor clearColor]];
		
		//init row container
		[self InitPageColumnContainer];
		
		//set page scrollview view's properties		
		[self setShowsHorizontalScrollIndicator:NO];
		[self setShowsVerticalScrollIndicator:NO];
		[self setDelegate:self];
		
		if([m_PageLableName compare:@"Wallpaper"]==0)
		{
			[self AddIconWithIconName:@"Remove wallpaper" WithLableName:@"None" WithDraggable:NO WithDangerousTag:@"no" WithVisible:YES 
						WithSortIndex:0 WithTypeTag:@"item" WithBehaviour:YES WithAction:@"removewallpaper" WithImageName:@"No wallpaper.png" 
						WithMenuColor:@"no" WithBackgroundColor:[UIColor clearColor] WithWallpaper:@"no" WithThemeSet:@"no" WithCustomize:NO WithItemIconIndex:0];
		}
		else  if([m_PageLableName compare:@"Luggage setting"]==0)
		{
			[self AddIconWithIconName:@"Remove luggage" WithLableName:@"No luggage" WithDraggable:NO WithDangerousTag:@"no" WithVisible:YES 
						WithSortIndex:0 WithTypeTag:@"item" WithBehaviour:YES WithAction:@"removeluggage" WithImageName:@"No luggage.png" 
						WithMenuColor:@"no" WithBackgroundColor:[UIColor clearColor] WithWallpaper:@"no" WithThemeSet:@"no" WithCustomize:NO WithItemIconIndex:0];
		}
		
		[self CheckEmpty];

	}
	return self;
}

//new
-(void)AddIconWithIconName:(NSString*)iconName WithLableName:(NSString*)lableName WithDraggable:(BOOL)draggable WithDangerousTag:(NSString*)dangerousTag WithVisible:(BOOL)visible
			 WithSortIndex:(NSUInteger)sortIndex WithTypeTag:(NSString*)typeTag WithBehaviour:(BOOL)behaviour WithAction:(NSString*)action
			 WithImageName:(NSString*)fileName WithMenuColor:(NSString*)menuColor WithBackgroundColor:(UIColor*)mBackgroundColor WithWallpaper:(NSString*)wallpaper 
			  WithThemeSet:(NSString*)themeSet WithCustomize:(BOOL)customize WithItemIconIndex:(NSUInteger)itemIconIndex
{
	
	//add one icon
	//get last one rect of icon in this container 
	if([m_PageColumnContainer count]==0)
	{
		//no last icon add new one
		//creat a icon
		//initialize icon
		ItemIcon *icon=[[ItemIcon alloc] InitWithIconName:iconName WithLableName:lableName WithDraggable:draggable WithDangerousTag:dangerousTag 
											  WithVisible:visible WithSortIndex:sortIndex WithTypeTag:typeTag WithBeaviour:behaviour 
											   WithAction:action WithFileName:fileName WithMenuColor:menuColor WithBackgroundColor:mBackgroundColor WithWallpaper:wallpaper 
											 WithThemeSet:themeSet WithCustomizeTag:customize WithFrame:CGRectMake(0, 0, 80-8, 90) WithDelegate:self.mDelegate];
		
		
		//set delegate
		[icon setM_ParentPageView:self];
		[icon setM_ItemIconIndex:itemIconIndex];
		
		
		[self addSubview:icon];
		
		//add icon to container
		[m_PageColumnContainer addObject:icon];
		
		
		[icon StartLableAnimation:nil];
		
		//[icon StartLableAnimation:nil];
	}
	else 
	{
		for(int i=0; i<[m_PageColumnContainer count]; i++)
		{
			//compare icon find out where should it be
			ItemIcon *mIcon=[m_PageColumnContainer objectAtIndex:i];
			
			if(itemIconIndex<[mIcon m_ItemIconIndex])
			{
				//insert this icon 
				//create icon first
				//creat a icon
				//initialize icon
				ItemIcon *newIcon=[[ItemIcon alloc] InitWithIconName:iconName WithLableName:lableName WithDraggable:draggable WithDangerousTag:dangerousTag 
														 WithVisible:visible WithSortIndex:sortIndex WithTypeTag:typeTag WithBeaviour:behaviour 
														  WithAction:action WithFileName:fileName WithMenuColor:menuColor 
												           WithBackgroundColor:mBackgroundColor WithWallpaper:wallpaper WithThemeSet:themeSet WithCustomizeTag:customize
														   WithFrame:[mIcon frame] WithDelegate:self.mDelegate];
				
				//set delegate
				[newIcon setM_ParentPageView:self];
				[newIcon setM_ItemIconIndex:itemIconIndex];
				
				[m_PageColumnContainer insertObject:newIcon atIndex:mIcon.frame.origin.y/mIcon.frame.size.height];
				
				[self addSubview:newIcon];
				
				[newIcon StartLableAnimation:nil];
				
				[self RedrawItemIcons];
				
				//update content size
				[self UpdateContentSize];
				
				return;
			}
		}
		
		//has last icon
		//get last one rect of icon in this container 
		CGRect lastOneRect=[(ItemIcon*)[m_PageColumnContainer lastObject] frame];
		
		//creat a icon
		//initialize icon
		ItemIcon *icon=[[ItemIcon alloc] InitWithIconName:iconName WithLableName:lableName WithDraggable:draggable WithDangerousTag:dangerousTag 
											  WithVisible:visible WithSortIndex:sortIndex WithTypeTag:typeTag WithBeaviour:behaviour 
											   WithAction:action WithFileName:fileName WithMenuColor:menuColor 
									            WithBackgroundColor:mBackgroundColor WithWallpaper:wallpaper WithThemeSet:themeSet WithCustomizeTag:customize
												WithFrame:CGRectMake(0, lastOneRect.origin.y+90, 80-8, 90) WithDelegate:self.mDelegate];
		
		//set delegate
		[icon setM_ParentPageView:self];
		[icon setM_ItemIconIndex:itemIconIndex];
		
		
		[self addSubview:icon];
		
		
		//add icon to container
		[m_PageColumnContainer addObject:icon];

		[icon StartLableAnimation:nil];
		
		//[icon StartLableAnimation:nil];
	}
	
	
	
	[self CheckEmpty];
	
	//update content size
	[self UpdateContentSize];
}

-(void)CheckEmpty
{
	if([m_PageColumnContainer count]==0)
	{
		if(m_EmptyIcon!=nil)
		{
			[m_EmptyIcon removeFromSuperview];
		}
		
		ItemIcon *empty=[[ItemIcon alloc] InitWithIconName:@"Empty" WithLableName:@"Empty" WithDraggable:NO WithDangerousTag:@"no" WithVisible:YES WithSortIndex:0 
											   WithTypeTag:@"item" WithBeaviour:NO	WithAction:@"no action" WithFileName:@"Empty.png" WithMenuColor:@"no" 
									   WithBackgroundColor:[UIColor clearColor] WithWallpaper:@"no" WithThemeSet:@"no" WithCustomizeTag:NO 
												 WithFrame:CGRectMake(0+4, 0, 80-8, 90) WithDelegate:self.mDelegate];
		
		
		self.m_EmptyIcon=empty;
		[empty release];
		
		[self addSubview:m_EmptyIcon];
		
		[m_EmptyIcon StartLableAnimation:nil];
	}
	else 
	{
		if(m_EmptyIcon!=nil)
		{
			[m_EmptyIcon removeFromSuperview];
			self.m_EmptyIcon=nil;
		}
		
	}

}

-(void)InitPageColumnContainer
{
	//init column container
	NSMutableArray *pageColoumnContainer=[[NSMutableArray alloc] init];
	self.m_PageColumnContainer=pageColoumnContainer;
	[pageColoumnContainer release];
	
	/*
	//add one item for test
	for(int i=0; i<20; i++)
	{
		ItemIcon *icon=[ItemIcon alloc];
		[icon setMDelegate:self.mDelegate];
		[icon InitWithImage:[UIImage imageNamed:@"Dress Shoes.png"] WithRect:CGRectMake(0, i*90, 80, 90)];
			
		[self addSubview:icon];
		[m_PageColumnContainer addObject:icon]; 
	}
   */
}

-(BOOL)HasSameIconWithName:(NSString*)iconName
{
	for(int i=0; i<[m_PageColumnContainer count]; i++)
	{
		ItemIcon *icon=[m_PageColumnContainer objectAtIndex:i];
		NSString *name=[icon m_Name];
		
		if([name compare:iconName]==0)
		{
			return YES;
		}
	}
	
	return NO;
}

-(void)DeleteIcon:(ItemIcon*)icon
{
	//remove icon from container
	[icon removeFromSuperview];
	[m_PageColumnContainer removeObject:icon];
	
	//call RedrawItemIcons
	[self RedrawItemIcons];
	
	//update content size
	[self UpdateContentSize];
}

-(void)HideIcons
{
	if([[self m_PageLableName] compare:@"Import photo"]==0)
	{
		//tell import photo item page view to hide icons wallpaper task and item
		for(int i=1; i<[m_PageColumnContainer count]; i++)
		{
			ItemIcon *icon=[m_PageColumnContainer objectAtIndex:i];
			[icon setHidden:YES];
		}
	}

}

-(void)ShowIcons
{
	if([[self m_PageLableName] compare:@"Import photo"]==0)
	{
		//tell import photo item page view to show icons wallpaper task and item
		for(int i=1; i<[m_PageColumnContainer count]; i++)
		{
			ItemIcon *icon=[m_PageColumnContainer objectAtIndex:i];
			[icon setHidden:NO];
		}
	}

}

-(void)RedrawItemIcons
{
	[UIView beginAnimations:@"back" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	for(int i=0; i<[m_PageColumnContainer count]; i++)
	{
		
		//get icon
		ItemIcon *icon=[m_PageColumnContainer objectAtIndex:i];
		
		//set icon into correct position
		[icon setFrame:CGRectMake(icon.frame.origin.x, i*icon.frame.size.height, icon.frame.size.width, icon.frame.size.height)];
		
		//update origin rect
		[icon setM_OriginRect:icon.frame];
	}
	
	[UIView commitAnimations];
}

-(void)UpdateContentSize
{
	CGSize mSize=CGSizeMake(1*80-8, [m_PageColumnContainer count]*90);
	
	[self setContentSize:mSize];
}

-(void)TransferIconsToPool
{
	while([m_PageColumnContainer count]!=0) 
	{
		//get icon
		ItemIcon *icon=[m_PageColumnContainer objectAtIndex:0];
		
		//tell icon to tansfer it self to pool
		[icon TransferSelfToPool];
	}
}

-(BOOL)TansferSampleIconToPool:(NSString*)sampleIconName
{
	BOOL success=NO;
	
	for(int i=0; i<[m_PageColumnContainer count]; i++)
	{
		ItemIcon *icon=[m_PageColumnContainer objectAtIndex:i];
		
		if([sampleIconName compare:[icon m_Name]]==0)
		{
			[icon TransferSelfToPool];
			success=YES;
			break;
		}
	}
	
	return success;
}

-(BOOL)TansferSampleIconToPool:(NSString*)sampleIconName WithQuantity:(int)number
{
	BOOL success=NO;
	
	for(int i=0; i<[m_PageColumnContainer count]; i++)
	{
		ItemIcon *icon=[m_PageColumnContainer objectAtIndex:i];
		
		if([sampleIconName compare:[icon m_Name]]==0)
		{
			if([[icon m_TypeTag] compare:@"item"]==0)
			{
				[icon TransferSelfToPoolWithQuantity:number];
				success=YES;
				break;
			}
			else 
			{
				[icon TransferSelfToPool];
				success=YES;
				break;
			}


		}
	}
	
	return success;
}

-(void)StartAnimation
{
	for(int i=0; i<[m_PageColumnContainer count]; i++)
	{
		ItemIcon *icon=[m_PageColumnContainer objectAtIndex:i];
		[icon StartLableAnimation:nil];
	}
}

-(void)StopAnimation
{
	for(int i=0; i<[m_PageColumnContainer count]; i++)
	{
		ItemIcon *icon=[m_PageColumnContainer objectAtIndex:i];
		[icon StopLableAnimation];
	}
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[(ItemIcon*)[(ItemView*)[mDelegate m_ItemView] m_ItemIcon] TakeFrameBackToOrigin];
	[NSObject cancelPreviousPerformRequestsWithTarget:[(ItemView*)[mDelegate m_ItemView] m_ItemIcon]];
	NSLog(@"scrollViewDidScroll");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[(ItemIcon*)[(ItemView*)[mDelegate m_ItemView] m_ItemIcon] TakeFrameBackToOrigin];
	[NSObject cancelPreviousPerformRequestsWithTarget:[(ItemView*)[mDelegate m_ItemView] m_ItemIcon]];
	NSLog(@"scrollViewDidScroll");
	

	
	/*
	if([(ItemView*)[mDelegate m_ItemView] m_ItemIcon])
	{
		[[(ItemView*)[mDelegate m_ItemView] m_ItemIcon]  ClearTimer];
	}
	 */
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	if(m_EmptyIcon!=nil)
	{
		self.m_EmptyIcon=nil;
	}

	
	if(m_PageName!=nil)
	{
		self.m_PageName=nil;
	}
	
	if(m_PageLableName!=nil)
	{
		self.m_PageLableName=nil;
	}
	
	if(m_PageColumnContainer!=nil)
	{
		for(int i=0; i<[m_PageColumnContainer count]; i++)
		{
			[(ItemIcon*)[m_PageColumnContainer objectAtIndex:i] removeFromSuperview];
		}
		
		[m_PageColumnContainer removeAllObjects];
		self.m_PageColumnContainer=nil;
	}

	
    [super dealloc];
}


@end
