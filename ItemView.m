//
//  ItemView.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemView.h"
#import "PackingCheckListAppDelegate.h"
#import "ItemPageView.h"
#import "ItemIcon.h"
#import "DataController.h"
#import "MenuView.h"
#import "MenuPageView.h"
#import "InformationBar.h"
#import "ItemBackground.h"
#import "MenuData.h"
#import "CatalogData.h"
#import "ItemBorder.h"
#import "LoadIconDataPackage.h"


@implementation ItemView
@synthesize avaliableToDrag;
@synthesize mDelegate;
@synthesize m_CurrentPage;
@synthesize m_ItemIcon;
@synthesize m_Image;
@synthesize m_PageController;
@synthesize m_PageContainer;


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
		for(int i=index-1; i>=0; i--)
		{
			[(ItemPageView*)[m_PageContainer objectAtIndex:i] setHidden:YES];
		}
		
		for(int i=index+1; i<[m_PageContainer count]; i++)
		{
			[(ItemPageView*)[m_PageContainer objectAtIndex:i] setHidden:YES];
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
		for(int i=index-1; i>=0; i--)
		{
			[(ItemPageView*)[m_PageContainer objectAtIndex:i] setHidden:NO];
		}
		
		for(int i=index+1; i<[m_PageContainer count]; i++)
		{
			[(ItemPageView*)[m_PageContainer objectAtIndex:i] setHidden:NO];
		}
	}
	else
	{
		NSLog(@"index out of range");
		return;
	}
}

-(void)UpdateItemView
{
	[m_ItemIcon BackToDefault];
	
	//unload previous item view
	
	//set current page to nil
	self.m_CurrentPage=nil;
	
	//set current icon to nil
	self.m_ItemIcon=nil;
	
	//set page controller current page index to 0
	m_PageController.currentPage=0;
	
	//set page controller number of page to 0;
	[m_PageController setNumberOfPages:0];
	
	//unlink each page from item view
	for(int i=0; i<[m_PageContainer count]; i++)
	{
		ItemPageView *pageView=[m_PageContainer objectAtIndex:i];
		[pageView StopAnimation];
		[pageView removeFromSuperview];
	}
	//clear page container
	[m_PageContainer removeAllObjects];
	
	//update content size
	[self UpdateContentSize];
	
	
	//load new item view
	DataController *dataHandler=[mDelegate m_DataController];
	
	
	//get item view page data
	NSMutableArray *pageData=[dataHandler GetItemPageViewArrayByMenuIndex:[(MenuView*)[mDelegate m_MenuView] m_PageController].currentPage 
													WithSubMenuIndex:[(MenuPageView*)[(MenuView*)[mDelegate m_MenuView] m_CurrentPage] GetCurrentPageIndex]];
	
	if(pageData!=nil)
	{
		//add page to this item view
		for(int i=0; i<[pageData count]; i++)
		{
			ItemPageView *pageView=(ItemPageView*)[pageData objectAtIndex:i];
			
			[self addSubview:pageView];
			
			[m_PageContainer addObject:pageView];
			
			[pageView StartAnimation];
		}
		
		//set current page
		self.m_CurrentPage=[m_PageContainer objectAtIndex:0];
		
		//set number of page 
		[m_PageController setNumberOfPages:[m_PageContainer count]];
		
		//update content size
		[self UpdateContentSize];
	}
	
	[(InformationBar*)[mDelegate m_InfoBar] SetCatalogBarText:[m_CurrentPage m_PageName]];
	
	//deal with narrow
	if([m_PageContainer count]>1)
	{

		[self ShowRightNarrow];
	}
	else if([m_PageContainer count]==1)
	{
		[self HideBothNarrow];
	}
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		
		//background color
		[self setBackgroundColor:[UIColor clearColor]];
		
		//init page container with none object
		[self InitPageContainer];
		
		/*
		//add page to item view
		[self CreateItemPageViewByPageNumber:0];
		[self CreateItemPageViewByPageNumber:1];
		[self CreateItemPageViewByPageNumber:2];
		*/
		
		//set item scrollview view's properties
		[self setPagingEnabled:YES];
		[self setContentSize:CGSizeMake(self.frame.size.width*[m_PageContainer count], self.frame.size.height)];
		[self setShowsHorizontalScrollIndicator:NO];
		[self setShowsVerticalScrollIndicator:NO];
		[self setDelegate:self];
		self.avaliableToDrag=YES;
		
		//init page controller
		UIPageControl *pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, 340, 80, 20)];
		self.m_PageController=pageControl;
		[pageControl release];
		
		//hide page controller
		m_PageController.hidden=YES;
		
		//set page controller's properties
		[m_PageController setNumberOfPages:[m_PageContainer count]];
		[m_PageController setCurrentPage:0];
		
		//add page controller view to pool view
		[self addSubview:m_PageController];
		
		//set current working page
		//m_CurrentPage=[m_PageContainer objectAtIndex:0];
		
    }
    return self;
}

-(void)UpdateContentSize
{
	[self setContentSize:CGSizeMake(self.frame.size.width*[m_PageContainer count], self.frame.size.height)];
}

-(void)Reset
{
	[(ItemBackground*)[mDelegate m_ItemBackground] ChangeBackgroundImage:@"menuset8_05.png"];
	[(ItemBorder*)[mDelegate m_ItemBorder] ChangeBorderImage:@"menuset8_04.png"];
}

-(void)TransferAllIconsToPool
{
	MenuData *task=[[(DataController*)[mDelegate m_DataController] m_PageViewData] objectAtIndex:1];
	MenuData *item=[[(DataController*)[mDelegate m_DataController] m_PageViewData] objectAtIndex:2];
	NSMutableArray *taskCatalogArray=[task m_MainCatalogArray];
	NSMutableArray *itemCatalogArray=[item m_MainCatalogArray];
	
	//run through task
	for(int i=0; i<[taskCatalogArray count]; i++)
	{
		//get catalog from array
		CatalogData *catalogData=[taskCatalogArray objectAtIndex:i];
		//get item page view array form catalog data
		NSMutableArray *itemPageViewArray=[catalogData m_ItemPageViewArray];
		
		//run through page view array
		for(int j=0; j<[itemPageViewArray count]; j++)
		{
			//get page
			ItemPageView *page=[itemPageViewArray objectAtIndex:j];
			
			//tell this page to transfer icons to pool
			[page TransferIconsToPool];
		}
	}
	
	//run through item
	for(int i=0; i<[itemCatalogArray count]; i++)
	{
		//get catalog from array
		CatalogData *catalogData=[itemCatalogArray objectAtIndex:i];
		//get item page view array form catalog data
		NSMutableArray *itemPageViewArray=[catalogData m_ItemPageViewArray];
		
		//run through page view array
		for(int j=0; j<[itemPageViewArray count]; j++)
		{
			//get page
			ItemPageView *page=[itemPageViewArray objectAtIndex:j];
			
			//tell this page to transfer icons to pool
			[page TransferIconsToPool];
		}
	}
	
}

-(void)TransferSampleToPoolWithSampleTableName:(NSString*)tableName
{
	//ask data to get a sample list return an array
	NSMutableArray *sampleList=[(DataController*)[mDelegate m_DataController] GetSampleList:tableName];
	
	//hold several item page view
	NSMutableArray *pageArray=[[NSMutableArray alloc] init];
	
	MenuData *task=[[(DataController*)[mDelegate m_DataController] m_PageViewData] objectAtIndex:1];
	MenuData *item=[[(DataController*)[mDelegate m_DataController] m_PageViewData] objectAtIndex:2];
	NSMutableArray *taskCatalogArray=[task m_MainCatalogArray];
	NSMutableArray *itemCatalogArray=[item m_MainCatalogArray];
	
	//run through task
	for(int i=0; i<[taskCatalogArray count]; i++)
	{
		//get catalog from array
		CatalogData *catalogData=[taskCatalogArray objectAtIndex:i];
		//get item page view array form catalog data
		NSMutableArray *itemPageViewArray=[catalogData m_ItemPageViewArray];
		
		//run through page view array
		for(int j=0; j<[itemPageViewArray count]; j++)
		{
			//get page
			ItemPageView *page=[itemPageViewArray objectAtIndex:j];
			
			[pageArray addObject:page];
		}
	}
	
	//run through item
	for(int i=0; i<[itemCatalogArray count]; i++)
	{
		//get catalog from array
		CatalogData *catalogData=[itemCatalogArray objectAtIndex:i];
		//get item page view array form catalog data
		NSMutableArray *itemPageViewArray=[catalogData m_ItemPageViewArray];
		
		//run through page view array
		for(int j=0; j<[itemPageViewArray count]; j++)
		{
			//get page
			ItemPageView *page=[itemPageViewArray objectAtIndex:j];
			
			[pageArray addObject:page];
			
		}
	}
	
	
	for(int i=0; i<[sampleList count]; i++)
	{
		NSString *sampleName=[sampleList objectAtIndex:i];
		
		for(int j=0; j<[pageArray count]; j++)
		{
			ItemPageView *pageView=[pageArray objectAtIndex:j];
			
			if([pageView TansferSampleIconToPool:sampleName]!=NO)
			{
				NSLog(@"sample icon %@ transfer to pool", sampleName);
				break;
			}
		}
	}
	
	[sampleList removeAllObjects];
	[sampleList release];
	
	[pageArray removeAllObjects];
	[pageArray release];
	
}

-(void)TransferIconToPoolWithCustomTableName:(NSString*)tableName
{
	NSMutableArray *customList=[(DataController*)[mDelegate m_DataController] GetCustomItemListWithTableName:tableName];
	
	//hold several item page view
	NSMutableArray *pageArray=[[NSMutableArray alloc] init];
	
	MenuData *task=[[(DataController*)[mDelegate m_DataController] m_PageViewData] objectAtIndex:1];
	MenuData *item=[[(DataController*)[mDelegate m_DataController] m_PageViewData] objectAtIndex:2];
	NSMutableArray *taskCatalogArray=[task m_MainCatalogArray];
	NSMutableArray *itemCatalogArray=[item m_MainCatalogArray];
	
	//run through task
	for(int i=0; i<[taskCatalogArray count]; i++)
	{
		//get catalog from array
		CatalogData *catalogData=[taskCatalogArray objectAtIndex:i];
		//get item page view array form catalog data
		NSMutableArray *itemPageViewArray=[catalogData m_ItemPageViewArray];
		
		//run through page view array
		for(int j=0; j<[itemPageViewArray count]; j++)
		{
			//get page
			ItemPageView *page=[itemPageViewArray objectAtIndex:j];
			
			[pageArray addObject:page];
		}
	}
	
	//run through item
	for(int i=0; i<[itemCatalogArray count]; i++)
	{
		//get catalog from array
		CatalogData *catalogData=[itemCatalogArray objectAtIndex:i];
		//get item page view array form catalog data
		NSMutableArray *itemPageViewArray=[catalogData m_ItemPageViewArray];
		
		//run through page view array
		for(int j=0; j<[itemPageViewArray count]; j++)
		{
			//get page
			ItemPageView *page=[itemPageViewArray objectAtIndex:j];
			
			[pageArray addObject:page];
			
		}
	}
	
	for(int i=0; i<[customList count]; i++)
	{
		LoadIconDataPackage *customPackage=[customList objectAtIndex:i];
		NSString *customIconName=[customPackage m_Name];
		int customIconQuantity=[customPackage m_Quantity];
		
		for(int j=0; j<[pageArray count]; j++)
		{
			ItemPageView *pageView=[pageArray objectAtIndex:j];
			
			if([pageView TansferSampleIconToPool:customIconName WithQuantity:customIconQuantity]!=NO)
			{
				NSLog(@"custom icon %@ transfer to pool", customIconName);
				break;
			}
		}
	}
	
	[customList removeAllObjects];
	[customList release];
	
	[pageArray removeAllObjects];
	[pageArray release];
	
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[(ItemIcon*)[(ItemView*)[mDelegate m_ItemView] m_ItemIcon] TakeFrameBackToOrigin];
	[NSObject cancelPreviousPerformRequestsWithTarget:[(ItemView*)[mDelegate m_ItemView] m_ItemIcon]];
	
	if(m_ItemIcon)
	{
		[m_ItemIcon ClearTimer];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[(ItemIcon*)[(ItemView*)[mDelegate m_ItemView] m_ItemIcon] TakeFrameBackToOrigin];
	[NSObject cancelPreviousPerformRequestsWithTarget:[(ItemView*)[mDelegate m_ItemView] m_ItemIcon]];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[self scrollViewDidEndDecelerating:scrollView];
}
	 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	// Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.frame.size.width;
    int page = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	
	
	if([m_PageContainer count]!=0 && page>=0 && page<[m_PageContainer count])
	{
		if(page!=m_LastPageIndex)
		{
			m_PageController.currentPage = page;
			self.m_CurrentPage=[m_PageContainer objectAtIndex:page];
			NSLog(@"current page number:%d", m_PageController.currentPage);
			
			
			
			int val=[m_PageContainer count]-1;
			
			if(page>val)
			{
				[UIView beginAnimations:@"swipe down" context:NULL];
				[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
				[UIView setAnimationDuration:0.3f];
				
				[self setContentOffset:CGPointMake(([m_PageContainer count]-1)*self.frame.size.width, 0)];
				
				[UIView commitAnimations];
				
			}
			
			[(InformationBar*)[mDelegate m_InfoBar] SetCatalogBarText:[m_CurrentPage m_PageName]];
			
			//deal with narrow
			if(m_PageController.currentPage==0 && [m_PageContainer count]>1)
			{

				[self ShowRightNarrow];
			}
			else if(m_PageController.currentPage>0 && m_PageController.currentPage<[m_PageContainer count]-1)
			{

				[self ShowBothNarrow];
			}
			else if(m_PageController.currentPage==[m_PageContainer count]-1)
			{

				[self ShowLeftNarrow];
			}
			
			m_LastPageIndex=page;
		}
	}
	
	int val=[m_PageContainer count]-1;
	
	if(page>val)
	{
		[UIView beginAnimations:@"swipe down" context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:0.3f];
		
		[self setContentOffset:CGPointMake(([m_PageContainer count]-1)*self.frame.size.width, 0)];
		
		[UIView commitAnimations];
		
	}
	

}

-(void)ShowLeftNarrow
{
	[[mDelegate m_ItemBackground] ShowLeftNarrow];
}

-(void)ShowRightNarrow
{
	[[mDelegate m_ItemBackground] ShowRightNarrow];
}

-(void)ShowBothNarrow
{
	[[mDelegate m_ItemBackground] ShowBothNarrow];
}

-(void)HideBothNarrow
{
	[[mDelegate m_ItemBackground] HideBothNarrow];
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
			[(ItemPageView*)[m_PageContainer objectAtIndex:i] removeFromSuperview];
		}
		
		[m_PageContainer removeAllObjects];
		self.m_PageContainer=nil;
	}
	
	if(m_CurrentPage!=nil)
	{
		self.m_CurrentPage=nil;
	}
	
	if(m_ItemIcon!=nil)
	{
		self.m_ItemIcon=nil;
	}
	
	if(m_Image!=nil)
	{
		self.m_Image=nil;
	}

    [super dealloc];
}


@end
