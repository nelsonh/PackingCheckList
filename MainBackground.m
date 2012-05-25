//
//  MainBackground.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "PackingCheckListAppDelegate.h"
#import "MainBackground.h"
#import "Utility.h"
#import "FileSystemBar.h"
#import "InformationBar.h"

@implementation MainBackground

@synthesize mDelegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		[self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
