//
//  MenuIcon.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MenuIcon.h"
#import "PackingCheckListAppDelegate.h"
#import "Utility.h"
#import "MenuPageView.h"

@implementation MenuIcon

@synthesize mDelegate;
@synthesize m_IconName;
@synthesize m_ImageFileName;
@synthesize m_Index;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		[self setBounds:frame];
    }
    return self;
}

-(void)InitImage
{
	//check if image is in app bundle or in device
	if([UIImage imageNamed:m_ImageFileName]==nil)
	{
		//image in device
		
		NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDir=[documentPaths objectAtIndex:0];
		NSString *imagePath=[documentDir stringByAppendingPathComponent:m_ImageFileName];
		
		NSFileManager *fileManager=[NSFileManager defaultManager];
		
		//check image is exist
		if(![fileManager fileExistsAtPath:imagePath])
		{
			//image file does not exist
			NSLog(@"image file does not exist at path: %@", imagePath);
			return;
		}
		
		//image file exist then load it 
		[self setImage:[UIImage imageWithContentsOfFile:imagePath]];
	}
	else 
	{
		//image in app bundle
		[self setImage:[UIImage imageNamed:m_ImageFileName]];
	}
	
}

-(id)InitWithIconName:(NSString*)iconName WithImage:(NSString*)imageFileName WithFrame:(CGRect)viewFrame;
{
	if (self = [super initWithFrame:viewFrame]) {
        // Initialization code
		
		self.m_IconName=iconName;
		self.m_ImageFileName=imageFileName;
		
		[self InitImage];
		
		[self setBounds:viewFrame];
		[self setUserInteractionEnabled:YES];
		
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(![self isHidden])
	{
		[(MenuPageView*)self.superview ScrollToBySubIndex:m_Index];
	}
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	if(m_IconName!=nil)
	{
		self.m_IconName=nil;
	}
	
	if(m_ImageFileName!=nil)
	{
		self.m_ImageFileName=nil;
	}
	
    [super dealloc];
}


@end
