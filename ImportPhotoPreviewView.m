//
//  ImportPhotoPreviewView.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImportPhotoPreviewView.h"


@implementation ImportPhotoPreviewView

@synthesize m_PreviewImage;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		UIImageView *previewImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		self.m_PreviewImage=previewImage;
		[previewImage release];
		[self addSubview:m_PreviewImage];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	if(m_PreviewImage!=nil)
	{
		[m_PreviewImage removeFromSuperview];
		self.m_PreviewImage=nil;
	}
	
    [super dealloc];
}


@end
