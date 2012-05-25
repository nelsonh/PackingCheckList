//
//  CrossImage.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PackingCheckListAppDelegate.h"
#import "DataController.h"
#import "CrossImage.h"
#import "ItemIcon.h"
#import "ItemPageView.h"


@implementation CrossImage

@synthesize mDelegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code

    }
    return self;
}

-(id)InitWithFrame:(CGRect)frame WithDelegate:(PackingCheckListAppDelegate*)delegate
{
	if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.mDelegate=delegate;
		
		[self setImage:[UIImage imageNamed:@"Delete icon 18x18.png"]];
		[self setBackgroundColor:[UIColor clearColor]];
		[self setUserInteractionEnabled:YES];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UIAlertView *deleteAlert=[[UIAlertView alloc] initWithTitle:@"Photo delete" 
														message:@"Would you like to delete this photo?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Delete", nil];
	
	[deleteAlert show];
	[deleteAlert release];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==1)
	{
		[self DeleteCustomizeIcon];
	}
}

-(void)DeleteCustomizeIcon
{
	ItemIcon *customizeIcon=(ItemIcon*)self.superview;
	ItemPageView *pageView=(ItemPageView*)[customizeIcon m_ParentPageView];
	
	//check which item page view this icon belong to
	if([[pageView m_PageLableName] compare:@"Custom Wallpaper"]==0)
	{
		//in customize wallpaper page view
		//delete data from data base and image if possible
		[[mDelegate m_DataController] DeleteCustomizeWallpaperFromDatabase:[customizeIcon m_Name]];
		
		//tell page view to remove icon
		[pageView DeleteIcon:customizeIcon];
		[pageView CheckEmpty];
		//[customizeIcon release];
	}
	else if([[pageView m_PageLableName] compare:@"Custom Task"]==0) 
	{
		//in customize task page view
		[[mDelegate m_DataController] DeleteCustomizeTaskFromDatabase:[customizeIcon m_Name]];
		
		//tell page view to remove icon
		[pageView DeleteIcon:customizeIcon];
		[pageView CheckEmpty];
		//[customizeIcon release];
	}
	else if([[pageView m_PageLableName] compare:@"Custom Item"]==0)
	{
		//in customize item page view
		[[mDelegate m_DataController] DeleteCustomizeItemFromDatabase:[customizeIcon m_Name]];
		
		//tell page view to remove icon
		[pageView DeleteIcon:customizeIcon];
		[pageView CheckEmpty];
		//[customizeIcon release];
	}

}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
