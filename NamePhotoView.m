//
//  NamePhotoView.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NamePhotoView.h"


@implementation NamePhotoView

@synthesize m_ImageView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 480)];
		self.m_ImageView=imageView;
		[imageView release];
		
		[self addSubview:m_ImageView];
    }
    return self;
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
	
    [super dealloc];
}


@end
