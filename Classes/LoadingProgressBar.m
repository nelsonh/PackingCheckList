//
//  LoadingProgressBar.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoadingProgressBar.h"


@implementation LoadingProgressBar


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		m_StatusLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
		[m_StatusLable setTextColor:[UIColor whiteColor]];
		[m_StatusLable setBackgroundColor:[UIColor clearColor]];
		[m_StatusLable setTextAlignment:UITextAlignmentCenter];
		[m_StatusLable setText:@""];
		[self addSubview:m_StatusLable];
		[m_StatusLable release];
		
		m_ProgressView=[[UIProgressView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, self.frame.size.height-20)];
		[m_ProgressView setProgressViewStyle:UIProgressViewStyleBar];
		[m_ProgressView setProgress:0.0];
		[self addSubview:m_ProgressView];
		[m_ProgressView release];
		
		m_ProgressValue=0.0;
		
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)SetProgress:(float)value
{
	m_ProgressValue+=value;
}

-(void)UpdateProgress
{
	[m_ProgressView setProgress:m_ProgressValue];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	[m_StatusLable release];
	[m_ProgressView release];
	
    [super dealloc];
}


@end
