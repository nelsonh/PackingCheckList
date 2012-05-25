//
//  HUDView.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/6/14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HUDView.h"


@implementation HUDView

@synthesize m_ActivityBackView;
@synthesize m_MsgLable;;
@synthesize m_Activity;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

-(id)InitWithWindow:(UIView*)window
{
	if (self = [super initWithFrame:CGRectMake(0, 0, 320, 480)]) {
       
		//init activity back view
		UIView *activityBackView=[[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-200/2, self.frame.size.height/2-100/2, 200, 100)];
		self.m_ActivityBackView=activityBackView;
		[activityBackView release];
		[m_ActivityBackView setBackgroundColor:[UIColor blackColor]];
		[m_ActivityBackView setAlpha:0.8];
		[self addSubview:m_ActivityBackView];
		
		//init message lable
		UILabel *msgLable=[[UILabel alloc] initWithFrame:CGRectMake(0, abs(m_ActivityBackView.frame.size.height/3)*2, m_ActivityBackView.frame.size.width, abs(m_ActivityBackView.frame.size.height/3))];
		self.m_MsgLable=msgLable;
		[msgLable release];
		[m_MsgLable setBackgroundColor:[UIColor clearColor]];
		[m_MsgLable setTextColor:[UIColor whiteColor]];
		[m_MsgLable setTextAlignment:UITextAlignmentCenter];
		[m_MsgLable setFont:[UIFont systemFontOfSize:abs(m_ActivityBackView.frame.size.width/3)*0.5]];
		[m_ActivityBackView addSubview:m_MsgLable];
		
		//init activity indicator
		UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(abs(m_ActivityBackView.frame.size.width/2)-25, 2, 50, 50)];
		self.m_Activity=activityIndicator;
		[activityIndicator release];
		[m_Activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[activityBackView addSubview:m_Activity];
		
		
		[self setBackgroundColor:[UIColor clearColor]];
		[self setHidden:YES];
		
		[window addSubview:self];
		
    }
    return self;
}

-(void)SetText:(NSString*)text
{
	[m_MsgLable setText:text];
}

-(void)Show:(BOOL)yes;
{
	if(yes==YES)
	{
		[self setHidden:NO];
		[m_Activity startAnimating];
	}
	else 
	{
		[self setHidden:YES];
		[m_Activity stopAnimating];
	}


}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	if(m_ActivityBackView!=nil)
	{
		[m_ActivityBackView removeFromSuperview];
		self.m_ActivityBackView=nil;
	}
	
	if(m_MsgLable!=nil)
	{
		[m_MsgLable removeFromSuperview];
		self.m_MsgLable=nil;
	}
	
	if(m_Activity!=nil)
	{
		[m_Activity removeFromSuperview];
		self.m_Activity=nil;
	}
	
    [super dealloc];
}


@end
