//
//  PoolView.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PoolView.h"
#import "PackingCheckListAppDelegate.h"
#import "PoolPageView.h"
#import "PoolIcon.h"
#import "WallpaperView.h"
#import "PoolBackground.h"
#import "DataController.h"


@implementation PoolView

@synthesize mDelegate;
@synthesize avaliableToDrag;
@synthesize m_CurrentPage;
@synthesize m_Image;
@synthesize m_PoolIcon;
@synthesize m_InsertEndIcon;
@synthesize m_PageController;
@synthesize m_PageContainer;
@synthesize m_PoolEmpty;
@synthesize m_SavedOn;

-(void)ZoomIn
{
	[UIView beginAnimations:@"Ease out" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 320, 480)];
	
	
	//make each page zoom in
	for(int i=0; i<[m_PageContainer count]; i++)
	{
		[(PoolPageView*)[m_PageContainer objectAtIndex:i] ZoomIn];
	}
	
	//update content size
	[self UpdateContentSize];
	
	[UIView commitAnimations];
	
	if(m_PageController.currentPage==1)
	{
		
		[self setContentOffset:CGPointMake(320, 0)];
	
	}
}

-(void)ZoomOut
{
	[UIView beginAnimations:@"Ease out" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[self setFrame:CGRectMake(m_OriginRect.origin.x, m_OriginRect.origin.y, m_OriginRect.size.width, m_OriginRect.size.height)];
	
	//make each page zoom out
	for(int i=0; i<[m_PageContainer count]; i++)
	{
		[(PoolPageView*)[m_PageContainer objectAtIndex:i] ZoomOut];
	}
	
	//update content size
	[self UpdateContentSize];
	
	[UIView commitAnimations];

}

-(void)UnCheckAllIconsInPageView
{
	for(int i=0; i<[m_PageContainer count]; i++)
	{
		PoolPageView *pageView=[m_PageContainer objectAtIndex:i];
		
		[pageView UnCheckAllIcons];
	}
}

-(PoolPageView*)CreatePoolPageViewByPageNumber:(int)PageNum WithTypeName:(NSString*)typeName
{
	if(PageNum<0)
	{
		NSLog(@"Unable to create new page in pool due to page number < 0");
		return nil;
	}
	
	//create a page
	PoolPageView *newPage=[[PoolPageView alloc] InitWithPageNumber:PageNum WithPageName:typeName 
														 WithFrame:CGRectMake(self.frame.size.width*PageNum, 0, self.frame.size.width, self.frame.size.height)];
	
	//setDelegate for newPage
	[newPage setMDelegate:self.mDelegate];
	
	
	//add newPage to page container
	[m_PageContainer addObject:newPage];
	
	//add newPage to pool scrollview
	[self addSubview:newPage];
	
	//return this page
	return newPage;
}



-(void)InitPageContainer
{
	//init page container with none object
	NSMutableArray *pageContainer=[[NSMutableArray alloc] init];
	self.m_PageContainer=pageContainer;
	[pageContainer release];
}

-(void)HidePageStartIndex:(int)index
{
	if(index<=[m_PageContainer count]-1 && index>=0)
	{
		for(int i=index+1; i<[m_PageContainer count]; i++)
		{
			[(PoolPageView*)[m_PageContainer objectAtIndex:i] setHidden:YES];
		}
	}
	else
	{
		NSLog(@"index out of range");
		return;
	}
}

-(void)UnhidePageStartIndex:(int)index
{
	if(index<=[m_PageContainer count]-1 && index>=0)
	{
		for(int i=index+1; i<[m_PageContainer count]; i++)
		{
			[(PoolPageView*)[m_PageContainer objectAtIndex:i] setHidden:NO];
		}
	}
	else 
	{
		NSLog(@"index out of range");
		return;
	}
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		m_OriginRect=frame;
		
		//background color
		[self setBackgroundColor:[UIColor clearColor]];
		
		//init empty lable
		UIImageView *emptyView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-10, 360)];
		self.m_PoolEmpty=emptyView;
		[emptyView release];
		
		[m_PoolEmpty setBackgroundColor:[UIColor clearColor]];
		[m_PoolEmpty setImage:[UIImage imageNamed:@"pool empty image.png"]];
		
		[self addSubview:m_PoolEmpty];
		
		//init page container with none object
		[self InitPageContainer];
		
		//add item pool and task view to pool view
		//also set current working page
		//self.m_CurrentPage=[self CreatePoolPageViewByPageNumber:0 WithTypeName:@"DefaultPool"];
				
		//set pool scrollview view's properties
		[self setPagingEnabled:YES];
		[self setShowsHorizontalScrollIndicator:NO];
		[self setShowsVerticalScrollIndicator:NO];
		[self setDelegate:self];
		[self setScrollEnabled:NO];
		self.avaliableToDrag=YES;
		
		//init page controller
		UIPageControl *pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, 340, 240, 20)];
		self.m_PageController=pageControl;
		[pageControl release];
		
		//hide page controller
		m_PageController.hidden=YES;
		
		//set page controller's properties
		[m_PageController setNumberOfPages:[m_PageContainer count]];
		[m_PageController setCurrentPage:0]; 
		
		//add page controller view to pool view
		[self addSubview:m_PageController];
		
		m_SavedOn=YES;
		
		//updeate content size
		[self UpdateContentSize];
		
		[self ShouldShowEmpty];
		
    }
    return self;
}

-(void)UpdateContentSize
{
	[self setContentSize:CGSizeMake(self.frame.size.width*[m_PageContainer count], self.frame.size.height)];
}

-(void)Reset
{
	
	[(PoolBackground*)[mDelegate m_PoolBackground] ChangeBackgroundColor:[UIColor colorWithRed:166.0f/255.0f green:166.0f/255.0f blue:166.0f/255.0f alpha:1.0f]];
	[(WallpaperView*)[mDelegate m_WallpaperView] ChangeWallpaperSystem:@"Wallpaper_backpacker.png"];
	
}

-(void)CheckEmpty
{
	NSMutableArray *taskContainer=[self.m_CurrentPage m_TaskRowContainer];
	NSMutableArray *itemContainer=[self.m_CurrentPage m_ItemRowContainer];
	
	if([taskContainer count]==0 && [itemContainer count]==0)
	{
		[m_PoolEmpty setHidden:NO];
		
		return;
	}
	
	[m_PoolEmpty setHidden:YES];
	
}

-(void)ShouldShowEmpty
{
	if(self.m_CurrentPage!=nil)
	{
		[self CheckEmpty];
	}
	else 
	{
		[m_PoolEmpty setHidden:YES];
	}

}

-(void)CloseCurrentPool
{
	if(m_CurrentPage!=nil)
	{
		[self UpdateIcon];
		//reset first
		for(int i=0; i<[m_PageContainer count]; i++)
		{
			PoolPageView *page=[m_PageContainer objectAtIndex:i];
			[page Reset];
		}
		
		[m_CurrentPage removeFromSuperview];
		//remove from container
		//since pool page has only one
		[m_PageContainer removeAllObjects];
		self.m_CurrentPage=nil;
	}
}

-(void)CloseCurrentPoolWithoutUpdateIcon
{
	if(m_CurrentPage!=nil)
	{
		//reset first
		for(int i=0; i<[m_PageContainer count]; i++)
		{
			PoolPageView *page=[m_PageContainer objectAtIndex:i];
			[page Reset];
		}
		
		[m_CurrentPage removeFromSuperview];
		//remove from container
		//since pool page has only one
		[m_PageContainer removeAllObjects];
		self.m_CurrentPage=nil;
	}
}

-(void)UpdateIcon
{
	[(DataController*)[mDelegate m_DataController] DeleteAllRows:[m_CurrentPage m_PageName]];
	
	NSMutableArray *sourceArray=[[NSMutableArray alloc] init];
	
	for(int i=0; i<[[m_CurrentPage m_TaskRowContainer] count]; i++)
	{
		NSMutableArray *array=[[m_CurrentPage m_TaskRowContainer] objectAtIndex:i];
		
		for(int j=0; j<[array count]; j++)
		{
			PoolIcon *icon=[array objectAtIndex:j];
			
			[sourceArray addObject:icon];
		}
	}
	
	for(int i=0; i<[[m_CurrentPage m_ItemRowContainer] count]; i++)
	{
		NSMutableArray *array=[[m_CurrentPage m_ItemRowContainer] objectAtIndex:i];
		
		for(int j=0; j<[array count]; j++)
		{
			PoolIcon *icon=[array objectAtIndex:j];
			
			[sourceArray addObject:icon];
		}
	}

	for(int i=0; i<[sourceArray count]; i++)
	{
		PoolIcon *icon=[sourceArray objectAtIndex:i];
		
		[(DataController*)[mDelegate m_DataController] SaveIconDataToPoolTable:[m_CurrentPage m_PageName] WithIconName:[icon m_Name] WithIconLableName:[icon m_LableName] WithTypeTag:[icon m_TypeTag] WithQuantity:[icon m_Quantity]];
	}
	
}

-(void)CreateNewPoolWithName:(NSString*)pageName
{
	//first close current page if has one
	[self CloseCurrentPool];
	
	//call create page function to create new page
	//since pool has only one page always so given 0 to number
	//also set current page
	self.m_CurrentPage=[self CreatePoolPageViewByPageNumber:0 WithTypeName:pageName];
	
	//call should show empty function to determind the empty message should should be showed or not
	[self ShouldShowEmpty];
	
}

-(void)SortCurrentPool
{
	[m_CurrentPage Sort];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[(PoolIcon*)[(PoolView*)[mDelegate m_PoolView] m_PoolIcon] TakeFrameBackToOrigin];
	[NSObject cancelPreviousPerformRequestsWithTarget:[(PoolView*)[mDelegate m_PoolView] m_PoolIcon]];
	
	// Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.frame.size.width;
    int page = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	if([m_PageContainer count]!=0 && page>=0 && page<[m_PageContainer count])
	{
		m_PageController.currentPage = page;
		self.m_CurrentPage=[m_PageContainer objectAtIndex:page];
		//NSLog(@"current page number:%d", m_PageController.currentPage);
	}
	
	if(m_PoolIcon)
	{
		[m_PoolIcon ClearTimer];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	
	[(PoolIcon*)[(PoolView*)[mDelegate m_PoolView] m_PoolIcon] TakeFrameBackToOrigin];
	[NSObject cancelPreviousPerformRequestsWithTarget:[(PoolView*)[mDelegate m_PoolView] m_PoolIcon]];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	if(m_PageController!=nil)
	{
		[m_PageController removeFromSuperview];
		self.m_PageController=nil;
	}
	
	if(m_PageContainer!=nil)
	{
		for(int i=0; i<[m_PageContainer count]; i++)
		{
			[(PoolPageView*)[m_PageContainer objectAtIndex:i] removeFromSuperview];
		}
		
		[m_PageContainer removeAllObjects];
		self.m_PageContainer=nil;
	}
	
	if(m_CurrentPage!=nil)
	{
		self.m_CurrentPage=nil;
	}
	
	if(m_PoolIcon!=nil)
	{
		self.m_PoolIcon=nil;
	}
	
	if(m_Image!=nil)
	{
		self.m_Image=nil;
	}
	
	if(m_InsertEndIcon!=nil)
	{
		self.m_InsertEndIcon=nil;
	}
	
    [super dealloc];
}


@end
