//
//  CatalogView.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/16.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CatalogView.h"
#import <QuartzCore/CALayer.h>

@implementation CatalogView

@synthesize m_ScrollingLable;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		[self setBackgroundColor:[UIColor clearColor]];
		[self setClipsToBounds:YES];
		[self setBounds:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		
		m_TextScrollingSpeed=5.0;
		
		UILabel *scrollingLable=[[UILabel alloc] initWithFrame:CGRectZero];
		self.m_ScrollingLable=scrollingLable;
		[scrollingLable release];
		[m_ScrollingLable setBackgroundColor:[UIColor clearColor]];
		
		[self addSubview:m_ScrollingLable];
		
    }
    return self;
}

-(void)Reboot:(NSString*)text
{
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[m_ScrollingLable.layer removeAllAnimations];
	
	
	NSUInteger textLength=[text sizeWithFont:[UIFont systemFontOfSize:self.frame.size.height-6]].width;
	
	[m_ScrollingLable setText:text];
	
	[m_ScrollingLable setTextColor:[UIColor whiteColor]];
	
	[m_ScrollingLable setTextAlignment:UITextAlignmentCenter];
	
	[m_ScrollingLable setFont:[UIFont systemFontOfSize:self.frame.size.height-8]];
	
	[m_ScrollingLable setFrame:CGRectMake(4, 0, textLength, self.frame.size.height)];
	
	if(textLength>[self frame].size.width-8)
	{
		[self ScrollLable];
	}
	else 
	{
		[m_ScrollingLable setFrame:CGRectMake((80/2)-(textLength/2), m_ScrollingLable.frame.origin.y, m_ScrollingLable.frame.size.width, m_ScrollingLable.frame.size.height)];
	}

}

-(void)StartAnimation
{
	[self Reboot:[m_ScrollingLable text]];
}

-(void)ScrollLable
{
	
	
	[UIView beginAnimations:@"catalog" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:m_TextScrollingSpeed];
	[UIView setAnimationDelegate:self];
	
	
	[m_ScrollingLable setFrame:CGRectMake(-[m_ScrollingLable frame].size.width, [m_ScrollingLable frame].origin.y, m_ScrollingLable.frame.size.width, m_ScrollingLable.frame.size.height)];
	
	
	[UIView commitAnimations];
}

-(void)KeepScrollingLable
{
	[m_ScrollingLable setFrame:CGRectMake(self.frame.size.width, [m_ScrollingLable frame].origin.y, [m_ScrollingLable frame].size.width, [m_ScrollingLable frame].size.height)];
	
	[UIView beginAnimations:@"catalog" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:m_TextScrollingSpeed];
	[UIView setAnimationDelegate:self];
	
	
	[m_ScrollingLable setFrame:CGRectMake(-[m_ScrollingLable frame].size.width, [m_ScrollingLable frame].origin.y, m_ScrollingLable.frame.size.width, m_ScrollingLable.frame.size.height)];
	
	
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([finished boolValue]) {
        [self performSelector:@selector(KeepScrollingLable) withObject:nil afterDelay:0.2];
    }
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {

	if(m_ScrollingLable!=nil)
	{
		[m_ScrollingLable removeFromSuperview];
		self.m_ScrollingLable=nil;
	}
	

	
	
    [super dealloc];
}


@end
