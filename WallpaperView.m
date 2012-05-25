//
//  WallpaperView.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WallpaperView.h"
#import "PackingCheckListAppDelegate.h"

@implementation WallpaperView

@synthesize mDelegate;
@synthesize m_BackgroundImage;
@synthesize m_ImageFileName;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		m_OriginRect=frame;
		
		[self setBackgroundColor:[UIColor clearColor]];
		
		//init image
		UIImageView *backgroundImage=[[UIImageView alloc] initWithFrame:frame];
		self.m_BackgroundImage=backgroundImage;
		[backgroundImage release];
		[m_BackgroundImage setContentMode:UIViewContentModeScaleAspectFit];
		[m_BackgroundImage setAlpha:0.5];
		[m_BackgroundImage setHidden:NO];
		[m_BackgroundImage setImage:[UIImage imageNamed:@"Wallpaper_backpacker.png"]];
		
		[self addSubview:m_BackgroundImage];
		
		self.m_ImageFileName=@"none";
		
    }
    return self;
}

-(void)ZoomIn
{
	
	
	[UIView beginAnimations:@"Zoom in" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[self setFrame:CGRectMake(0, 0, 320, 480)];
	[m_BackgroundImage setFrame:CGRectMake(0, 0, 320, 480)];
	
	[UIView commitAnimations];
}

-(void)ZoomOut
{
	[UIView beginAnimations:@"Zoom out" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[self setFrame:m_OriginRect];
	[m_BackgroundImage setFrame:m_OriginRect];
	
	
	[UIView commitAnimations];
}

-(void)ChangeWallpaperSystem:(NSString*)fileName
{
	self.m_ImageFileName=fileName;
	
	if([fileName compare:@"none"]==0)
	{
		[m_BackgroundImage setHidden:YES];
	}
	else 
	{
		[m_BackgroundImage setHidden:NO];
	}

	[m_BackgroundImage setContentMode:UIViewContentModeScaleToFill];
	[m_BackgroundImage setFrame:CGRectMake(0, 0, 240, 360)];
	
	//wallpaper in bundle
	[m_BackgroundImage setImage:[UIImage imageNamed:fileName]];
	[m_BackgroundImage setAlpha:0.0];
	
	[UIView beginAnimations:@"Zoom out" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:1.0f];
	
	[m_BackgroundImage setAlpha:0.5];
	
	[UIView commitAnimations];
}

-(void)ChangeWallpaperCustomize:(UIImage*)mImage WithFileName:(NSString*)fileName;
{
	self.m_ImageFileName=fileName;
	
	if([fileName compare:@"none"]==0)
	{
		[m_BackgroundImage setHidden:YES];
	}
	else 
	{
		[m_BackgroundImage setHidden:NO];
	}
	
	[m_BackgroundImage setContentMode:UIViewContentModeScaleAspectFit];
	
	//customize
	[m_BackgroundImage setImage:mImage];
	[m_BackgroundImage setAlpha:0.0];
	
	[UIView beginAnimations:@"Zoom out" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:1.0f];
	
	[m_BackgroundImage setAlpha:0.5];
	
	[UIView commitAnimations];
	
}

-(void)RemoveWallpaperAnimation;
{
	
	
	[UIView beginAnimations:@"Zoom out" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(RemoveWallpaper)];
	
	[m_BackgroundImage setAlpha:0.0];
	
	[UIView commitAnimations];
}

-(void)RemoveWallpaper
{
	self.m_ImageFileName=@"none";
	
	[m_BackgroundImage setHidden:YES];
	[m_BackgroundImage setImage:nil];
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
	
    [super dealloc];
}


@end
