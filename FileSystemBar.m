//
//  FileSystemBar.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FileSystemBar.h"
#import "FileSystemButton.h"

@implementation FileSystemBar

@synthesize mDelegate;
@synthesize m_OriginRect;
@synthesize m_ButtonTouched;
@synthesize m_CreateNew;
@synthesize m_ManageList;
@synthesize m_Sort;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		
    }
    return self;
}

-(id)InitWithFrame:(CGRect)viewFrame WithDelegate:(PackingCheckListAppDelegate*)delegate
{
	if (self = [super initWithFrame:viewFrame]) {
        // Initialization code
		
		m_OriginRect=viewFrame;
		
		//init three button
		FileSystemButton *createNew=[[FileSystemButton alloc] InitWithButtonName:@"CreateNew" WithBehaviour:YES 
																	   WithAcion:@"dropdowncreatenewmenu" WithImageName:@"New.png" WithFrame:CGRectMake(0, 0, 30, 20)];
		self.m_CreateNew=createNew;
		[createNew release];
		[m_CreateNew setMDelegate:delegate];
		[m_CreateNew setHidden:YES];
		[self addSubview:m_CreateNew];
		
		
		FileSystemButton *sort=[[FileSystemButton alloc] InitWithButtonName:@"Sort" WithBehaviour:YES WithAcion:@"filesystemsortcategory" 
															  WithImageName:@"Sort.png" WithFrame:CGRectMake(45, 0, 30, 20)];
		self.m_Sort=sort;
		[m_Sort setMDelegate:delegate];
		[m_Sort setHidden:YES];
		[self addSubview:m_Sort];
		
		
		[self setBackgroundColor:[UIColor clearColor]];
		
		m_ButtonTouched=NO;
		
    }
    return self;
}

-(void)UnClickedButton
{
	[m_CreateNew setBackgroundColor:[UIColor clearColor]];
	//[m_ManageList setBackgroundColor:[UIColor clearColor]];
	[m_Sort setBackgroundColor:[UIColor clearColor]];
}

-(void)ShowFileSystemButton
{
	[m_CreateNew setHidden:NO];
	[m_Sort setHidden:NO];
}

-(void)HideFileSystemButton;
{
	[m_CreateNew setHidden:YES];
	[m_Sort setHidden:YES];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	if(m_CreateNew!=nil)
	{
		[m_CreateNew removeFromSuperview];
		self.m_CreateNew=nil;
	}
	
	if(m_ManageList!=nil)
	{
		[m_ManageList removeFromSuperview];
		self.m_ManageList=nil;
	}
	
	if(m_Sort!=nil)
	{
		[m_Sort removeFromSuperview];
		self.m_Sort=nil;
	}

    [super dealloc];
}


@end
