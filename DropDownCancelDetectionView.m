//
//  DropDownCancelDetectionView.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PackingCheckListAppDelegate.h"
#import "DropDownCancelDetectionView.h"
#import "MenuBackground.h"
#import "ItemBackground.h"
#import "PoolBackground.h"
#import "Utility.h"
#import "FileSystemBar.h"
#import "InformationBar.h"


@implementation DropDownCancelDetectionView

@synthesize mDelegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[(MenuBackground*)[mDelegate m_MenuBackground] BringDropDownDetectionViewtoBack];
	[(ItemBackground*)[mDelegate m_ItemBackground] BringDropDownDetectionViewtoBack];
	[(PoolBackground*)[mDelegate m_PoolBackground] BringDropDownDetectionViewtoBack];
	
	[(Utility*)[mDelegate m_Utility] ClearDropDownMenu];
	
	[(FileSystemBar*)[(InformationBar*)[mDelegate m_InfoBar] m_FileSystemBar] UnClickedButton];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
