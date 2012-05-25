//
//  MenuView.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MenuView.h"
#import "PackingCheckListAppDelegate.h"
#import "MenuPageView.h"
#import "ItemView.h"
#import "InformationBar.h"
#import "ImportPhotoImageView.h"
#import "DataController.h"
#import "MenuBackground.h"
#import "MenuIcon.h"
#import "MenuBorder.h"

@implementation MenuView

@synthesize mDelegate;
@synthesize m_PageController;
@synthesize m_CurrentPage;
@synthesize m_PageContainer;


-(void)InitPageContainer
{
	//init page container with none object
	NSMutableArray *pageContainer=[[NSMutableArray alloc] init];
	self.m_PageContainer=pageContainer;
	[pageContainer release];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		[self setBackgroundColor:[UIColor clearColor]];
		
		//init page container with none object
		[self InitPageContainer];
		
		//add page to menu view
		//can be change
		
		/*
		[self CreateItemPageViewByPageNumber:0 WithNumberOfIcon:5 WithImageName:@"Umbrella.png"];
		[self CreateItemPageViewByPageNumber:1 WithNumberOfIcon:6 WithImageName:@"Theme.png"];
		[self CreateItemPageViewByPageNumber:2 WithNumberOfIcon:3 WithImageName:@"Body Wash.png"];
		[self CreateItemPageViewByPageNumber:3 WithNumberOfIcon:7 WithImageName:@"Medication.png"];
		*/
		
		/*
		[self CreateItemPageViewByPageNumber:0];
		[self CreateItemPageViewByPageNumber:1];
		[self CreateItemPageViewByPageNumber:2];
		*/
		
		for(int i=0; i<3; i++)
		{
			MenuPageView *mpv=[(DataController*)[mDelegate m_DataController] GetMenuPageViewByMenuIndex:i];
			[self addSubview:mpv];
			
			[m_PageContainer addObject:mpv];
		}
		
		
		
		
		
		//set menu scrollview view's properties
		[self setPagingEnabled:YES];
		[self setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height*[m_PageContainer count])];
		[self setShowsHorizontalScrollIndicator:NO];
		[self setShowsVerticalScrollIndicator:NO];
		[self setDelegate:self];
		
		//init page controller
		UIPageControl *pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, 60, 360, 20)];
		self.m_PageController=pageControl;
		[pageControl release];
		
		//hide page controller
		m_PageController.hidden=YES;
		
		//set page controller's properties
		[m_PageController setNumberOfPages:[m_PageContainer count]];
		[m_PageController setCurrentPage:2];
		m_LastPageIndex=m_PageController.currentPage;
		
		//add page controller view to pool view
		[self addSubview:m_PageController];
		
		//set current working page
		self.m_CurrentPage=[m_PageContainer objectAtIndex:2];
		
		[self setContentOffset:CGPointMake(0.0f, 80*2)];
		
    }
    return self;
}

-(void)Reset
{
	[(MenuBackground*)[mDelegate m_MenuBackground] ChangeBackgroundImage:@"menuset8_02.png"];
	[(MenuBorder*)[mDelegate m_MenuBorder] ChangeBorderImage:@"menuset8_01.png"];
}

-(void)ScrollMenuByMenuIndex:(NSUInteger)menuIndex
{
	CGPoint heightOffset=CGPointMake([self contentOffset].x, menuIndex*self.frame.size.height) ;
	
	
	//Animation
	[UIView beginAnimations:@"back" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	
	[self setContentOffset:heightOffset];
	
	[UIView commitAnimations];
	
}

-(void)ApaulScrollMenuByMenuIndex:(NSUInteger)menuIndex
{
	MenuPageView *page=[m_PageContainer objectAtIndex:m_TempMenuIndex];
	[page setContentOffset:CGPointMake(-80, [page contentOffset].y)];
	
	CGPoint heightOffset=CGPointMake([self contentOffset].x, menuIndex*self.frame.size.height) ;
	
	
	//Animation
	[UIView beginAnimations:@"back" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	
	[self setContentOffset:heightOffset];
	
	[UIView commitAnimations];
	

}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
	
	
	if ([finished boolValue]) {
        [self scrollViewDidEndDecelerating:self];
		
		MenuPageView *page=[m_PageContainer objectAtIndex:m_TempMenuIndex];
		//[page ScrollToBySubIndex:m_TempSubIndex];
		[page ApaulScrollToBySubIndex:m_TempSubIndex];
    }
}

-(void)ScrollToByMenuIndex:(NSUInteger)menuIndex WithSubMenuIndex:(NSUInteger)subIndex
{
	if(m_PageController.currentPage!=2)
	{
		m_TempSubIndex=subIndex;
		m_TempMenuIndex=menuIndex;
		
		//[self ScrollMenuByMenuIndex:menuIndex];
		[self ApaulScrollMenuByMenuIndex:menuIndex];
	}
	else if(m_CurrentPage.contentOffset.x!=240)
	{
			m_TempSubIndex=subIndex;
			m_TempMenuIndex=menuIndex;
			
			[self ApaulScrollMenuByMenuIndex:menuIndex];
	}


}

-(void)ScrollToHelp:(NSUInteger)menuIndex
{
	[self setContentOffset:CGPointMake(self.contentOffset.x, menuIndex)];
	
	m_PageController.currentPage = menuIndex;
	self.m_CurrentPage=[m_PageContainer objectAtIndex:menuIndex];
	
	m_LastPageIndex=menuIndex;
	
	MenuPageView *pageView=[m_PageContainer objectAtIndex:menuIndex];
	[pageView Presentation:6];
	
	for(int i=1; i<[m_PageContainer count]; i++)
	{
		MenuPageView *page=[m_PageContainer objectAtIndex:i];
		
		[page Presentation:3];
	}

}

-(void)UpdateNarrow
{
	//deal with narrow
	if(m_PageController.currentPage==0)
	{
		[[mDelegate m_MenuBackground] ShowDownNarrow];
	}
	else if(m_PageController.currentPage>0 && m_PageController.currentPage<[m_PageContainer count]-1)
	{
		[[mDelegate m_MenuBackground] ShowBothNarrow];
	}
	else if(m_PageController.currentPage==[m_PageContainer count]-1)
	{
		[[mDelegate m_MenuBackground] ShowUpNarrow];
	}
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	// Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageHeight = self.frame.size.height;
    int page = floor((self.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
	
	if([m_PageContainer count]!=0 && page>=0 && page<[m_PageContainer count])
	{
		if(page!=m_LastPageIndex)
		{
			m_PageController.currentPage = page;
			self.m_CurrentPage=[m_PageContainer objectAtIndex:page];
			NSLog(@"current page number:%d", m_PageController.currentPage);
			
			
			//set information menu name bar text to current page name
			//[(InformationBar*)[mDelegate m_InfoBar] SetMenuNameBarText:[m_CurrentPage m_PageName]];
			
			[(InformationBar*)[mDelegate m_InfoBar] SetMenuNameBarWithMainText:[m_CurrentPage m_PageName] WithSubText:[(MenuIcon*)[[m_CurrentPage m_PageIconContainer] objectAtIndex:[m_CurrentPage m_PageController].currentPage+3] m_IconName]];
			
			[(ItemView*)[mDelegate m_ItemView] UpdateItemView];
			
			[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] Hide];
			
			[self UpdateNarrow];

			
			m_LastPageIndex=page;
		}
	}

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
			[(MenuPageView*)[m_PageContainer objectAtIndex:i] removeFromSuperview];
		}
		
		[m_PageContainer removeAllObjects];
		self.m_PageContainer=nil;
	}
	
	if(m_CurrentPage!=nil)
	{
		self.m_CurrentPage=nil;
	}

	
    [super dealloc];
}


@end
