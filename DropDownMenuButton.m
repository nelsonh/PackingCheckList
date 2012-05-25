//
//  DropDownMenuButton.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "PackingCheckListAppDelegate.h"
#import "DropDownMenuButton.h"
#import "Utility.h"
#import "FileSystemBar.h"
#import "InformationBar.h"
#import "MenuBackground.h"
#import "ItemBackground.h"
#import "PoolBackground.h"


@implementation DropDownMenuButton

@synthesize mDelegate;
@synthesize m_OriginRect;
@synthesize m_ButtonName;
@synthesize m_DisplayName;
@synthesize m_Behaviour;
@synthesize m_ActionCommand;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

-(id)InitWithButtonName:(NSString*)Name WithDisplayName:(NSString*)displayName WithBehaviour:(BOOL)behaviour WithAction:(NSString*)action WithFrame:(CGRect)viewFrame 
	  WithImageFileName:(NSString*)imageFileName
{
	if (self = [super initWithFrame:viewFrame]) 
	{
        // Initialization code
		
		m_OriginRect=viewFrame;
		self.m_ButtonName=Name;
		self.m_DisplayName=displayName;
		m_Behaviour=behaviour;
		self.m_ActionCommand=action;
		
		//[self setTitle:m_DisplayName forState:UIControlStateNormal];
		[self setShowsTouchWhenHighlighted:YES];
		//[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		//[self.titleLabel setFont:[UIFont systemFontOfSize:12]];
		[self setBackgroundColor:[UIColor clearColor]];
		[self setBackgroundImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
    }
	
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//[self setBackgroundImage:[UIImage imageNamed:@"menuButton-over.png"] forState:UIControlStateNormal];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	[(MenuBackground*)[mDelegate m_MenuBackground] BringDropDownDetectionViewtoBack];
	[(ItemBackground*)[mDelegate m_ItemBackground] BringDropDownDetectionViewtoBack];
	[(PoolBackground*)[mDelegate m_PoolBackground] BringDropDownDetectionViewtoBack];
	
	//[self setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
	
	[(Utility*)[mDelegate m_Utility] ClearDropDownMenu];
	
	[(FileSystemBar*)[(InformationBar*)[mDelegate m_InfoBar] m_FileSystemBar] UnClickedButton];
	
	//if this icon has utility pass command to utility
	if([[touches anyObject] tapCount]==1 && m_Behaviour==YES)
	{
		[[mDelegate m_Utility] StartUtilityWithCommand:m_ActionCommand WithObject:nil];
	}
	
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	if(m_ButtonName!=nil)
	{
		self.m_ButtonName=nil;
	}
	
	if(m_DisplayName!=nil)
	{
		self.m_DisplayName=nil;
	}
	
	if(m_ActionCommand!=nil)
	{
		self.m_ActionCommand=nil;
	}
	
    [super dealloc];
}


@end
