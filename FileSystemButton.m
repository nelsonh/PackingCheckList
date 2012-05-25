//
//  FileSystemButton.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PackingCheckListAppDelegate.h"
#import "FileSystemButton.h"
#import "FileSystemBar.h"
#import "Utility.h"
#import "MenuBackground.h"
#import "ItemBackground.h"
#import "PoolBackground.h"


@implementation FileSystemButton

@synthesize mDelegate;
@synthesize m_OriginRect;
@synthesize m_Name;
@synthesize m_Behaviour;
@synthesize m_ActionCommand;
@synthesize m_ImageName;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

-(id)InitWithButtonName:(NSString*)buttonName WithBehaviour:(BOOL)behaviour WithAcion:(NSString*)action WithImageName:(NSString*)imageFileName WithFrame:(CGRect)viewFrame
{
	if (self = [super initWithFrame:viewFrame]) 
	{
        // Initialization code
		
		m_OriginRect=viewFrame;
		self.m_Name=buttonName;
		m_Behaviour=behaviour;
		self.m_ActionCommand=action;
		self.m_ImageName=imageFileName;
		
		[self setUserInteractionEnabled:YES];
		
		[self setImage:[UIImage imageNamed:m_ImageName]];
		
		[self setBackgroundColor:[UIColor clearColor]];
		
		m_Touched=NO;
    }
	
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//bring each scrollview's detection view to top
	[(MenuBackground*)[mDelegate m_MenuBackground] BringDropDownDetectionViewtoTop];
	[(ItemBackground*)[mDelegate m_ItemBackground] BringDropDownDetectionViewtoTop];
	[(PoolBackground*)[mDelegate m_PoolBackground] BringDropDownDetectionViewtoTop];
	
	[(Utility*)[mDelegate m_Utility] ClearDropDownMenu];
	[(FileSystemBar*)self.superview UnClickedButton];
	
	[(Utility*)[mDelegate m_Utility] StartUtilityWithCommand:m_ActionCommand WithObject:self];
	[self setBackgroundColor:[UIColor colorWithRed:100/255 green:100/255 blue:100/255 alpha:0]];
	
	
	

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	
	if(m_Name!=nil)
	{
		self.m_Name=nil;
	}
	
	if(m_ActionCommand!=nil)
	{
		self.m_ActionCommand=nil;
	}
	
	if(m_ImageName!=nil)
	{
		self.m_ImageName=nil;
	}
	
	
    [super dealloc];
}


@end
