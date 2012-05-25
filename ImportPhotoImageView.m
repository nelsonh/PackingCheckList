//
//  ImportPhotoImageView.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImportPhotoImageView.h"
#import "PackingCheckListAppDelegate.h"
#import "ItemPageView.h"
#import "ItemView.h"

@implementation ImportPhotoImageView

@synthesize mDelegate;
@synthesize m_ImageView;
@synthesize m_ImageName;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		self.m_ImageView=imageView;
		[imageView release];
		[self addSubview:m_ImageView];
		
		[self setHidden:YES];
		m_Hide=YES;
    }
    return self;
}

-(void)ShowWithImage:(UIImage*)mImage WithImageName:(NSString*)imageName
{
	m_ImageName=[imageName retain];
	
	//show
	
	//check image orientation
	UIImageOrientation orient=[mImage imageOrientation];
	
	if(orient==UIImageOrientationRight || orient==UIImageOrientationLeft)
	{
		[m_ImageView setContentMode:UIViewContentModeScaleToFill];
		[m_ImageView setFrame:CGRectMake(0, 0, 240, 360)];
		[m_ImageView setImage:mImage];
	}
	else if(orient==UIImageOrientationUp || orient==UIImageOrientationDown)
	{
		[m_ImageView setContentMode:UIViewContentModeScaleAspectFit];
		[m_ImageView setImage:mImage];
	}
	
	//bring this view to top
	[self.superview bringSubviewToFront:self];
	
	[self setHidden:NO];
	m_Hide=NO;
	
	//tell import photo item page view to show icons wallpaper task and item
	[(ItemPageView*)[(ItemView*)[mDelegate m_ItemView] m_CurrentPage] ShowIcons];
}

-(void)Hide
{
	//hide
	
	//bring this view to back
	[self.superview sendSubviewToBack:self];
	
	[self setHidden:YES];
	m_Hide=YES;
	
	//tell import photo item page view to hide icons wallpaper task and item
	[(ItemPageView*)[(ItemView*)[mDelegate m_ItemView] m_CurrentPage] HideIcons];
	
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	if(m_ImageView!=nil)
	{
		[m_ImageView removeFromSuperview];
		self.m_ImageView=nil;
	}
	
	if(m_ImageName!=nil)
	{
		self.m_ImageName=nil;
	}
	
    [super dealloc];
}


@end
