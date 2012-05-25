//
//  MenuPageView.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MenuPageView.h"
#import "PackingCheckListAppDelegate.h"
#import "MenuIcon.h"
#import "ItemView.h"
#import "MenuView.h"
#import "ImportPhotoImageView.h"
#import "InformationBar.h"
#import "FileSystemBar.h"

@implementation MenuPageView

@synthesize mDelegate;
@synthesize m_PageController;
@synthesize m_PageName;
@synthesize m_PageIconContainer;

-(void)InitPageIconContainer
{
	//init icon container
	NSMutableArray *pageIconContainer=[[NSMutableArray alloc] init];
	self.m_PageIconContainer=pageIconContainer;
	[pageIconContainer release];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

//new
-(id)InitWithPageNumber:(int)pageNum WithName:(NSString*)pageName WithFrame:(CGRect)viewFrame WithDelegate:(PackingCheckListAppDelegate*)delegate
{
	if(self=[super initWithFrame:viewFrame])
	{
		self.mDelegate=delegate;
		m_PageNumber=pageNum;
		self.m_PageName=pageName;
		
		[self setBackgroundColor:[UIColor clearColor]];
		
		//init icon container
		[self InitPageIconContainer]; 
		
		//set page scrollview view's properties		
		[self setShowsHorizontalScrollIndicator:NO];
		[self setShowsVerticalScrollIndicator:NO];
		[self setBounces:NO];
		[self setPagingEnabled:NO];
		[self setDecelerationRate:0];
		[self setDelegate:self];
		[self setScrollEnabled:NO];
		
		
		//init page controller
		UIPageControl *pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, 60, 320, 20)];
		self.m_PageController=pageControl;
		
		//hide page controller
		m_PageController.hidden=YES;
		
		//add page controller view to pool view
		[self addSubview:m_PageController];
		
		//add three no image icon first
		for(int i=0; i<3; i++)
		{
			MenuIcon *icon=[[MenuIcon alloc] initWithFrame:CGRectMake(i*80, 0, 80, 80)];
			[icon setMDelegate:self.mDelegate];
			[icon setHidden:YES];
			
			[self addSubview:icon];
			
			[m_PageIconContainer addObject:icon];
		}
		
		//setup page controller number of page
		[m_PageController setNumberOfPages:[m_PageIconContainer count]];
		
		//update content size
		[self UpdateContentSize];
		
		//set content offset
		m_ContentOffsetBegin=[self contentOffset];
	}
	
	return self;
}
//new
-(void)AddIconWithIconName:(NSString*)iconName WithImageFileName:(NSString*)fileName
{
	
	//get offset of this icon
	int offset=[m_PageIconContainer count]*80;
	
	//add a icon by given file name
	MenuIcon *icon=[[MenuIcon alloc] InitWithIconName:iconName WithImage:fileName WithFrame:CGRectMake(offset, 0, 80, 80)];
	[icon setMDelegate:self.mDelegate];
	[icon setM_Index:[m_PageIconContainer count]-3];
	

	
	//add icon to this menu page view
	[self addSubview:icon];
	
	//also add this icon object to page icon container
	[m_PageIconContainer addObject:icon];
	
	//setup page controller number of page
	[m_PageController setNumberOfPages:[m_PageIconContainer count]];
	
	//update content size
	[self UpdateContentSize];
	//set content offset
	//m_ContentOffsetBegin=[self contentOffset];
}
//new
-(void)Finish
{
	//setup current page index
	int val=[m_PageIconContainer count]-3;
	if(val>=4)
	{
		[m_PageController setCurrentPage:3];
		//m_LastPageIndex=3;
	}
	else
	{
		[m_PageController setCurrentPage:([m_PageIconContainer count]-3)-1];
		//m_LastPageIndex=([m_PageIconContainer count]-3)-1;
	}
	

	[self setContentOffset:CGPointMake(0, 0)];
	
	//setup correct icon to right
	if(val==2)
	{
		[self setContentOffset:CGPointMake(self.contentOffset.x+(1*80), 0)];
	}
	else if(val==3)
	{
		[self setContentOffset:CGPointMake(self.contentOffset.x+(2*80), 0)];
	}
	else if(val>=4) 
	{
		[self setContentOffset:CGPointMake(self.contentOffset.x+(3*80), 0)];
	}

	
	if([m_PageName compare:@"Item"]==0)
	{
		[self setContentOffset:CGPointMake([m_PageIconContainer count]*80, 0)];

	}


	
	
	//update content size
	//[self UpdateContentSize];
	
	//set content offset
	m_ContentOffsetBegin=[self contentOffset];
}

-(void)UpdateContentSize
{
	CGSize mSize=CGSizeMake([m_PageIconContainer count]*80, 1*80);
	
	[self setContentSize:mSize];
}

-(NSUInteger)GetCurrentPageIndex
{
	return m_PageController.currentPage;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	m_ContentOffsetBegin=[self contentOffset];
}

-(void)Presentation:(NSUInteger)endSubIndex
{
	[self setContentOffset:CGPointMake([m_PageIconContainer count]*80, 0)];
	
	int subIndex=endSubIndex;
	CGPoint widthOffset=CGPointMake(subIndex*80, [self contentOffset].y);
	
	//Animation
	[UIView beginAnimations:@"back" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.6f];
	[UIView setAnimationDelegate:self];
	
	[self setContentOffset:widthOffset];
	
	[UIView commitAnimations];
	
}


-(void)ScrollToBySubIndex:(NSUInteger)subIndex
{	
	int realIndex=subIndex;
	CGPoint widthOffset=CGPointMake(realIndex*80, [self contentOffset].y);
	
	
	//Animation
	[UIView beginAnimations:@"back" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	
	[self setContentOffset:widthOffset];
	
	[UIView commitAnimations];
}

-(void)ApaulScrollToBySubIndex:(NSUInteger)subIndex
{
	int realIndex=subIndex;
	CGPoint widthOffset=CGPointMake(realIndex*80, [self contentOffset].y);
	
	//Animation
	[UIView beginAnimations:@"back" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	
	[self setContentOffset:widthOffset];
	
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
	
	if ([finished boolValue]) {
        [self scrollViewDidEndDecelerating:self];
		[(FileSystemBar*)[(InformationBar*)[mDelegate m_InfoBar] m_FileSystemBar] ShowFileSystemButton];
		[self setScrollEnabled:YES];
		[(MenuView*)[mDelegate m_MenuView] UpdateNarrow];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[self scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	//get current contentoffset
	CGPoint contentoffset=[self contentOffset];
	
	/*
	//new current page index
	int newPageIndex=0;
	

	
	CGFloat swip=contentoffset.x-m_ContentOffsetBegin.x;

	
	int numberPage=abs((swip/80));
	int rest=fmod(swip, 80);
	
	if(rest>=40 )
	{
		numberPage++;
	}
	else if(rest<=-40 )
	{
		numberPage++;
	}
	
	*/
	
	
	
	int index=contentoffset.x/80;
	int rest=fmod(contentoffset.x, 80);
	
	if(rest>=40)
	{
		index++;
	}
	
	[UIView beginAnimations:@"swipe down" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[self setContentOffset:CGPointMake(index*80, 0)];
	
	[UIView commitAnimations];
	
	m_PageController.currentPage=index;
	
	if(index!=m_LastPageIndex)
	{
		[(ItemView*)[mDelegate m_ItemView] UpdateItemView];
		
		[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] Hide];
		
		MenuIcon *icon=[m_PageIconContainer objectAtIndex:m_PageController.currentPage+3];
		[(InformationBar*)[mDelegate m_InfoBar] SetMenuNameBarWithMainText:m_PageName WithSubText:[icon m_IconName]];
		
		NSLog(@"current page number:%d", m_PageController.currentPage);
		
		m_LastPageIndex=index;
	}
	

	/*
	//left swip
	if(swip!=0 && swip>0)
	{
		m_ContentOffsetBegin=CGPointMake(m_ContentOffsetBegin.x+(numberPage*80), 0);
		
		[UIView beginAnimations:@"swipe down" context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:0.3f];
		 
		[self setContentOffset:CGPointMake(m_ContentOffsetBegin.x, 0)];
		
		[UIView commitAnimations];
		
		m_PageController.currentPage=m_PageController.currentPage+numberPage;
		
		newPageIndex=m_PageController.currentPage;
		
		NSLog(@"left swip");
	}
	else if(swip!=0 && swip<0)
	{
		//right swip
		m_ContentOffsetBegin=CGPointMake(m_ContentOffsetBegin.x-(numberPage*80), 0);
		
		[UIView beginAnimations:@"swipe down" context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:0.3f];
		
		[self setContentOffset:CGPointMake(m_ContentOffsetBegin.x, 0)];
		
		[UIView commitAnimations];
		
		m_PageController.currentPage=m_PageController.currentPage-numberPage;
		
		newPageIndex=m_PageController.currentPage;
		
		NSLog(@"right swip");
	}
	
	
	if(newPageIndex!=m_LastPageIndex)
	{
		[(ItemView*)[mDelegate m_ItemView] UpdateItemView];
		
		[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] Hide];
		
		NSLog(@"current page number:%d", m_PageController.currentPage);
		
		m_LastPageIndex=newPageIndex;
	}
	*/
	

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
	
	if(m_PageIconContainer!=nil)
	{
		for(int i=0; i<[m_PageIconContainer count]; i++)
		{
			[(MenuIcon*)[m_PageIconContainer objectAtIndex:i] removeFromSuperview];
		}
		
		[m_PageIconContainer removeAllObjects];
		self.m_PageIconContainer=nil;
	}
	
	if(m_PageName!=nil)
	{
		m_PageName=nil;
	}
	
    [super dealloc];
}


@end
