//
//  MenuBackground.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/6.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MenuBackground.h"
#import "PackingCheckListAppDelegate.h"
#import "InformationBar.h"
#import "DropDownCancelDetectionView.h"


@implementation MenuBackground

@synthesize mDelegate;
@synthesize m_DropDownDetectionView;
@synthesize m_BackgroundImage;
@synthesize m_MenuUpNarrow;
@synthesize m_MenuDownNarrow;
@synthesize m_ImageFileName;



- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		m_OriginRect=frame;
		[self setBackgroundColor:[UIColor clearColor]];
		
		UIImageView *backgroundImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		self.m_BackgroundImage=backgroundImage;
		[backgroundImage release];
		[m_BackgroundImage setImage:[UIImage imageNamed:@"menuset8_02.png"]];
		[self addSubview:m_BackgroundImage];
		
		self.m_ImageFileName=@"menuset8_02.png";
		

		
		//init narrow
		UIImageView *menuUpNarrow=[[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width/2)-(50/2), 0+5, 50, 5)];
		self.m_MenuUpNarrow=menuUpNarrow;
		[menuUpNarrow release];
		[m_MenuUpNarrow setImage:[UIImage imageNamed:@"Narrow-up.png"]];
		[m_MenuUpNarrow setHidden:YES];
		[self addSubview:m_MenuUpNarrow];

		
		UIImageView *menuDownNarrow=[[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width/2)-(50/2), 80-12, 50, 5)];
		self.m_MenuDownNarrow=menuDownNarrow;
		[menuDownNarrow release];
		[m_MenuDownNarrow setImage:[UIImage imageNamed:@"Narrow-down.png"]];
		[m_MenuDownNarrow setHidden:YES];
		[self addSubview:m_MenuDownNarrow];

		
		
		//init drop down cancel detection view
		DropDownCancelDetectionView *dropDownDetectionView=[[DropDownCancelDetectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		self.m_DropDownDetectionView=dropDownDetectionView;
		[dropDownDetectionView release];
		[m_DropDownDetectionView setMDelegate:self.mDelegate];
		[m_DropDownDetectionView setHidden:YES];
		[self addSubview:m_DropDownDetectionView];
		
		//bring it to back
		[self sendSubviewToBack:m_DropDownDetectionView];
		
		[self bringSubviewToFront:m_MenuDownNarrow];
		[self bringSubviewToFront:m_MenuUpNarrow];
		
		
		
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

-(void)ShowUpNarrow
{
	[self bringSubviewToFront:m_MenuUpNarrow];
	[self bringSubviewToFront:m_MenuDownNarrow];
	
	[m_MenuUpNarrow setHidden:NO];
	[m_MenuDownNarrow setHidden:YES];
	
}

-(void)ShowDownNarrow
{
	[self bringSubviewToFront:m_MenuDownNarrow];
	[self bringSubviewToFront:m_MenuUpNarrow];
	
	[m_MenuDownNarrow setHidden:NO];
	[m_MenuUpNarrow setHidden:YES];

}

-(void)ShowBothNarrow
{
	[self bringSubviewToFront:m_MenuDownNarrow];
	[self bringSubviewToFront:m_MenuUpNarrow];
	
	[m_MenuDownNarrow setHidden:NO];
	[m_MenuUpNarrow setHidden:NO];

}

-(void)EaseOut
{
	[UIView beginAnimations:@"Ease out" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[self setFrame:CGRectMake(0, -100, self.frame.size.width, self.frame.size.height)];
	
	//also make information bar ease out
	[(InformationBar*)[mDelegate m_InfoBar] EaseOut];
	
	[UIView commitAnimations];
	
}

-(void)EaseIn
{
	[UIView beginAnimations:@"Ease in" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[self setFrame:CGRectMake(m_OriginRect.origin.x, m_OriginRect.origin.y, m_OriginRect.size.width, m_OriginRect.size.height)];
	
	//also make information bar ease in
	[(InformationBar*)[mDelegate m_InfoBar] EaseIn];
	
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

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	if(m_BackgroundImage!=nil)
	{
		[m_BackgroundImage removeFromSuperview];
		self.m_BackgroundImage=nil;
	}
	
	if(m_MenuUpNarrow!=nil)
	{
		[m_MenuUpNarrow removeFromSuperview];
		self.m_MenuUpNarrow=nil;
	}
	
	if(m_MenuDownNarrow!=nil)
	{
		[m_MenuDownNarrow removeFromSuperview];
		self.m_MenuDownNarrow=nil;
	}
	
	if(m_DropDownDetectionView!=nil)
	{
		[m_DropDownDetectionView removeFromSuperview];
		self.m_DropDownDetectionView=nil;
	}
	
    [super dealloc];
}


@end
