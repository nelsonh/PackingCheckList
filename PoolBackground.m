//
//  PoolBackground.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/6.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PoolBackground.h"
#import "PackingCheckListAppDelegate.h"
#import "PoolView.h"
#import "DropDownCancelDetectionView.h"

@implementation PoolBackground

@synthesize mDelegate;
@synthesize m_DropDownDetectionView;
@synthesize m_Red;
@synthesize m_Green;
@synthesize m_Blue;
@synthesize m_Alpha;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		m_OriginRect=frame;
		
		[self setBackgroundColor:[UIColor colorWithRed:166.0f/255.0f green:166.0f/255.0f blue:166.0f/255.0f alpha:1.0f]];
		
		self.m_Red=166.0f/255.0f;
		self.m_Green=166.0f/255.0f;
		self.m_Blue=166.0f/255.0f;
		self.m_Alpha=1.0f;
		
		//init drop down cancel detection view
		DropDownCancelDetectionView *dropDownCancelDetectionView=[[DropDownCancelDetectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		self.m_DropDownDetectionView=dropDownCancelDetectionView;
		[dropDownCancelDetectionView release];
		[m_DropDownDetectionView setMDelegate:self.mDelegate];
		[m_DropDownDetectionView setHidden:YES];
		[self addSubview:m_DropDownDetectionView];

		
		//bring it to back
		[self sendSubviewToBack:m_DropDownDetectionView];
		
    }
    return self;
}

-(void)ZoomIn
{

	
	[UIView beginAnimations:@"Zoom in" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[self setFrame:CGRectMake(0, 0, 320, 480)];
	[(PoolView*)[mDelegate m_PoolView] ZoomIn];
	[(WallpaperView*)[mDelegate m_WallpaperView] ZoomIn];
	
	[UIView commitAnimations];
}

-(void)ZoomOut
{
	[UIView beginAnimations:@"Zoom out" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[self setFrame:CGRectMake(m_OriginRect.origin.x, m_OriginRect.origin.y, m_OriginRect.size.width, m_OriginRect.size.height)];
	[(PoolView*)[mDelegate m_PoolView] ZoomOut];
	[(WallpaperView*)[mDelegate m_WallpaperView] ZoomOut];
	
	[UIView commitAnimations];
}

-(void)ChangeBackgroundColor:(UIColor*)color
{
	const CGFloat *backColor=CGColorGetComponents(color.CGColor);
	self.m_Red=backColor[0];
	self.m_Green=backColor[1];
	self.m_Blue=backColor[2];
	self.m_Alpha=CGColorGetAlpha(color.CGColor);
	
	[self setBackgroundColor:color];
	
}

-(void)BringDropDownDetectionViewtoTop
{
	[m_DropDownDetectionView setHidden:NO];
	[self bringSubviewToFront:m_DropDownDetectionView];
}

-(void)BringDropDownDetectionViewtoBack
{
	[m_DropDownDetectionView setHidden:YES];
	[self sendSubviewToBack:m_DropDownDetectionView];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	if(m_DropDownDetectionView!=nil)
	{
		[m_DropDownDetectionView removeFromSuperview];
		self.m_DropDownDetectionView=nil;
	}
	
    [super dealloc];
}


@end
