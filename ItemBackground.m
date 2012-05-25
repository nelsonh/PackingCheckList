//
//  ItemBackground.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/6.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemBackground.h"
#import "PackingCheckListAppDelegate.h"
#import "TopRightBorder.h"
#import "TopRightBorder2.h"
#import "DropDownCancelDetectionView.h"


@implementation ItemBackground

@synthesize mDelegate;
@synthesize m_DropDownDetectionView;
@synthesize m_BackgroundImage;
@synthesize m_ImageFileName;
@synthesize m_ItemLeftNarrow;
@synthesize m_ItemRightNarrow;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		m_OriginRect=frame;
		
		[self setBackgroundColor:[UIColor clearColor]];
		
		//background image
		UIImageView *backgroundImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		self.m_BackgroundImage=backgroundImage;
		[backgroundImage release];
		[m_BackgroundImage setImage:[UIImage imageNamed:@"menuset8_05.png"]];
		
		[self addSubview:m_BackgroundImage];
		
		self.m_ImageFileName=@"menuset8_05.png";
		

		
		//init drop down cancel detection view
		DropDownCancelDetectionView *dropDownDetectionView=[[DropDownCancelDetectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		self.m_DropDownDetectionView=dropDownDetectionView;
		[dropDownDetectionView release];
		[m_DropDownDetectionView setMDelegate:self.mDelegate];
		[m_DropDownDetectionView setHidden:YES];
		[self addSubview:m_DropDownDetectionView];

		
		//bring it to back
		[self sendSubviewToBack:m_DropDownDetectionView];
		
		//init narrow
		UIImageView *itemLeftNarrow=[[UIImageView alloc] initWithFrame:CGRectMake(0+5, (self.frame.size.height/2), 5, 50)];
		self.m_ItemLeftNarrow=itemLeftNarrow;
		[itemLeftNarrow release];
		[m_ItemLeftNarrow setImage:[UIImage imageNamed:@"Narrow-left.png"]];
		[m_ItemLeftNarrow setHidden:YES];
		[self addSubview:m_ItemLeftNarrow];
		
		UIImageView *itemRightNarrow=[[UIImageView alloc] initWithFrame:CGRectMake(80-10, (self.frame.size.height/2), 5, 50)];
		self.m_ItemRightNarrow=itemRightNarrow;
		[itemRightNarrow release];
		[m_ItemRightNarrow setImage:[UIImage imageNamed:@"Narrow-right.png"]];
		[m_ItemRightNarrow setHidden:YES];
		[self addSubview:m_ItemRightNarrow];
		
		[self bringSubviewToFront:m_ItemLeftNarrow];
		[self bringSubviewToFront:m_ItemRightNarrow];
		
    }
    return self;
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



-(void)EaseOut
{
	[UIView beginAnimations:@"Ease out" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[self setFrame:CGRectMake(320, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
	
	//also make top right border ease out
	[(TopRightBorder*)[mDelegate m_TopRightBorder] EaseOut];
	[(TopRightBorder2*)[mDelegate m_TopRightBorder2] EaseOut];
	
	[UIView commitAnimations];
	
}

-(void)EaseIn
{
	[UIView beginAnimations:@"Ease in" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[self setFrame:CGRectMake(m_OriginRect.origin.x, m_OriginRect.origin.y, m_OriginRect.size.width, m_OriginRect.size.height)];
	
	//also make top right border ease in
	[(TopRightBorder*)[mDelegate m_TopRightBorder] EaseIn];
	[(TopRightBorder2*)[mDelegate m_TopRightBorder2] EaseIn];
	
	[UIView commitAnimations];
}

-(void)ChangeBackgroundImage:(NSString*)fileName
{
	self.m_ImageFileName=fileName;
	
	[m_BackgroundImage setImage:[UIImage imageNamed:fileName]];
	[m_BackgroundImage setAlpha:0.0f];
	
	[UIView beginAnimations:@"Zoom out" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:1.0f];
	
	[m_BackgroundImage setAlpha:1.0f];
	
	[UIView commitAnimations];
}

-(void)ShowLeftNarrow
{
	[m_ItemLeftNarrow setHidden:NO];
	[m_ItemRightNarrow setHidden:YES];
}

-(void)ShowRightNarrow
{
	[m_ItemRightNarrow setHidden:NO];
	[m_ItemLeftNarrow setHidden:YES];
}

-(void)ShowBothNarrow
{
	[m_ItemRightNarrow setHidden:NO];
	[m_ItemLeftNarrow setHidden:NO];
}

-(void)HideBothNarrow
{
	[m_ItemRightNarrow setHidden:YES];
	[m_ItemLeftNarrow setHidden:YES];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	if(m_BackgroundImage!=nil)
	{
		[m_BackgroundImage removeFromSuperview];
		self.m_BackgroundImage=nil;
	}
	
	if(m_DropDownDetectionView!=nil)
	{
		[m_DropDownDetectionView removeFromSuperview];
		self.m_DropDownDetectionView=nil;
	}
	
	if(m_ItemLeftNarrow!=nil)
	{
		[m_ItemLeftNarrow removeFromSuperview];
		self.m_ItemLeftNarrow=nil;
	}
	
	if(m_ItemRightNarrow!=nil)
	{
		[m_ItemRightNarrow removeFromSuperview];
		self.m_ItemRightNarrow=nil;
	}
	
	
    [super dealloc];
}


@end
