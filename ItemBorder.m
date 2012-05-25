//
//  ItemBorder.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/6.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemBorder.h"
#import "PackingCheckListAppDelegate.h"

@implementation ItemBorder

@synthesize mDelegate;
@synthesize m_Border;
@synthesize m_ImageFileName;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		[self setBackgroundColor:[UIColor clearColor]];
		
		//setup border
		UIImageView *border=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 360)];
		self.m_Border=border;
		[border release];
		[m_Border setImage:[UIImage imageNamed:@"menuset8_04.png"]];
		[m_Border setContentMode:UIViewContentModeCenter];
		
		[self addSubview:m_Border];
		
		self.m_ImageFileName=@"menuset8_04.png";
    }
    return self;
}

-(void)ChangeBorderImage:(NSString*)fileName
{
	self.m_ImageFileName=fileName;
	
	[m_Border setImage:[UIImage imageNamed:fileName]];
	[m_Border setAlpha:0.0f];
	
	[UIView beginAnimations:@"Zoom out" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:1.0f];
	
	[m_Border setAlpha:1.0f];
	
	[UIView commitAnimations];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	if(m_Border!=nil)
	{
		[m_Border removeFromSuperview];
		self.m_Border=nil;
	}
	
	
    [super dealloc];
}


@end
