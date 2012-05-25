//
//  LoadIconDataPackage.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/6/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoadIconDataPackage.h"


@implementation LoadIconDataPackage

@synthesize m_Name;
@synthesize m_Quantity;


-(id)InitPackage
{
	if(self=[super init])
	{
		
	}
	
	return self;
}


- (void)dealloc {
	
	if(m_Name!=nil)
	{
		self.m_Name=nil;
	}
	
    [super dealloc];
}

@end
