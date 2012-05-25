//
//  InformationBar.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InformationBar.h"
#import "CatalogView.h"
#import "FileSystemBar.h"
#import "DropDownCancelDetectionView.h"

@implementation InformationBar

@synthesize mDelegate;
@synthesize m_MenuNameBar;
@synthesize m_CatalogView;
@synthesize m_FileSystemBar;
@synthesize m_BackgroundImage;
@synthesize m_ImageFileName;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		m_OriginRect=frame;
		
		
		//background image default
		UIImageView *backgroundImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		self.m_BackgroundImage=backgroundImage;
		[backgroundImage release];
		[m_BackgroundImage setImage:[UIImage imageNamed:@"menuset8_03.png"]];
		[self addSubview:m_BackgroundImage];
		
		self.m_ImageFileName=@"menuset8_03.png";
		
		//init menu name bar
		UILabel *menuBar=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 20)];
		self.m_MenuNameBar=menuBar;
		[menuBar release];
		[m_MenuNameBar setBackgroundColor:[UIColor clearColor]];
		
		//test
		[m_MenuNameBar setTextColor:[UIColor whiteColor]];
		[m_MenuNameBar setFont:[UIFont systemFontOfSize:12]];
		//[m_MenuNameBar setText:@"Setting: Wallpaper"];
		
		[self addSubview:m_MenuNameBar];
		
		//init catalog view
		CatalogView *catalogView=[[CatalogView alloc] initWithFrame:CGRectMake(240, 0, 80, 20)];
		self.m_CatalogView=catalogView;
		[catalogView release];
		//[m_CatalogView Reboot:@"This is scrolling text"];
		
		[self addSubview:m_CatalogView];
		
		//init file system bar
		FileSystemBar *fileSystemBar=[[FileSystemBar alloc] InitWithFrame:CGRectMake(240-90, 0, 90, 20) WithDelegate:(PackingCheckListAppDelegate*)self.mDelegate];
		[m_FileSystemBar setMDelegate:self.mDelegate];
		self.m_FileSystemBar=fileSystemBar;
		[fileSystemBar release];
		
		[self addSubview:m_FileSystemBar];
		
		
    }
    return self;
}

-(void)EaseOut
{
	[UIView beginAnimations:@"Ease out" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[self setFrame:CGRectMake(0, -20, self.frame.size.width, self.frame.size.height)];
	
	[UIView commitAnimations];
	
}

-(void)EaseIn
{
	[UIView beginAnimations:@"Ease in" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[self setFrame:CGRectMake(m_OriginRect.origin.x, m_OriginRect.origin.y, m_OriginRect.size.width, m_OriginRect.size.height)];
	
	[UIView commitAnimations];
}

/*
-(void)SetMenuNameBarText:(NSString*)text
{
	[m_MenuNameBar setText:text];
}
*/

-(void)Reset
{
	[self ChangeBackgroundImage:@"menuset8_03.png"];
}

-(void)SetMenuNameBarWithMainText:(NSString*)text WithSubText:(NSString*)subText;
{
	NSString *fullText=[[text stringByAppendingString:@": "] stringByAppendingString:subText];
	[m_MenuNameBar setText:fullText];
}

-(void)SetCatalogBarText:(NSString*)text
{
	if([text compare:@"no name"]==0)
	{
		[m_CatalogView Reboot:@""];
		return;
	}
	
	[m_CatalogView Reboot:text];
}

-(void)ChangeBackgroundImage:(NSString*)fileName
{
	self.m_ImageFileName=fileName;
	[m_BackgroundImage setImage:[UIImage imageNamed:fileName]];
}



- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	if(m_MenuNameBar!=nil)
	{
		[m_MenuNameBar removeFromSuperview];
		self.m_MenuNameBar=nil;
	}
	
	if(m_CatalogView!=nil)
	{
		[m_CatalogView removeFromSuperview];
		self.m_CatalogView=nil;
	}
	
	if(m_BackgroundImage!=nil)
	{
		[m_BackgroundImage removeFromSuperview];
		self.m_BackgroundImage=nil;
	}
	
	if(m_FileSystemBar!=nil)
	{
		[m_FileSystemBar removeFromSuperview];
		self.m_FileSystemBar=nil;
	}
	
    [super dealloc];
}


@end
