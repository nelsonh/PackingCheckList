//
//  DropDownMenu.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DropDownMenu.h"
#import "DropDownMenuButton.h"

@implementation DropDownMenu

@synthesize mDelegate;
@synthesize m_OriginRect;
@synthesize m_MenuName;
@synthesize m_Title;
@synthesize m_TitleLable;
@synthesize m_ButtonArray;
@synthesize m_ImageView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

-(id)InitWithMenuName:(NSString*)menuName WithTitle:(NSString*)title WithButtonArray:(NSMutableArray*)buttonArray WithFrame:(CGRect)viewFrame
{
	
	if (self = [super initWithFrame:viewFrame]) 
	{
        // Initialization code
		
		CGFloat menuHeight=72+(Between*2)+1;
		CGFloat menuWidth=230-5;
		CGFloat x=8;
		CGFloat y=0;
		
		[self setFrame:CGRectMake(x, y, menuWidth, menuHeight)];
		m_OriginRect=self.frame;
		
		[self setBackgroundColor:[UIColor clearColor]];
		
		if([menuName compare:@"CreateNew"]==0)
		{
			UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, m_OriginRect.size.width, m_OriginRect.size.height)];
			self.m_ImageView=imageView;
			[imageView release];
			[m_ImageView setImage:[UIImage imageNamed:@"Dropdown-menu.png"]];
			[m_ImageView setBackgroundColor:[UIColor clearColor]];
			[self addSubview:m_ImageView];
			
		}
		else if([menuName compare:@"ManageList"]==0)
		{
			UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, m_OriginRect.size.width, m_OriginRect.size.height)];
			self.m_ImageView=imageView;
			[imageView release];
			[m_ImageView setImage:[UIImage imageNamed:@"dropdownMenu-manageList.png"]];
			[m_ImageView setBackgroundColor:[UIColor clearColor]];
			[self addSubview:m_ImageView];
			
		}
		else if([menuName compare:@"Sort"]==0)
		{
			UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, m_OriginRect.size.width, m_OriginRect.size.height)];
			self.m_ImageView=imageView;
			[imageView release];
			[m_ImageView setImage:[UIImage imageNamed:@"dropdownMenu-sort.png"]];
			[m_ImageView setBackgroundColor:[UIColor clearColor]];
			[self addSubview:m_ImageView];
			
		}

		
		self.m_MenuName=menuName;
		self.m_Title=title;
		self.m_ButtonArray=buttonArray;
		
		/*
		//init title lable
		UILabel *titleLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, 90, 20)];
		self.m_TitleLable=titleLable;
		[m_TitleLable setText:m_Title];
		[m_TitleLable setTextColor:[UIColor whiteColor]];
		[m_TitleLable setFont:[UIFont systemFontOfSize:12]];
		[m_TitleLable setTextAlignment:UITextAlignmentCenter];
		[m_TitleLable setBackgroundColor:[UIColor clearColor]];
		[self addSubview:m_TitleLable];
		 */
		
		//[m_TitleLable setHidden:YES];
		
		//attach each button
		CGFloat startWidth=Between;
		
		for(int i=0; i<[buttonArray count]; i++)
		{
			DropDownMenuButton *button=[m_ButtonArray objectAtIndex:i];
			
			[button setFrame:CGRectMake(startWidth, 14, 72, 60)];
			[button setM_OriginRect:CGRectMake(startWidth, 14, 72, 60)];
			[self addSubview:button];
			
			/*
			[button setFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
			*/
			
			startWidth=startWidth+72+Between;
		}
		
		[self setHidden:YES];
		
		/*
		[self setFrame:CGRectMake(self.frame.origin.x, 0, self.frame.size.width, 0)];
		*/

    }
    return self;
}

-(void)ShowMenu
{
	[self setHidden:NO];
	
	[UIView beginAnimations:@"back" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[self setFrame:m_OriginRect];
	
	for(int i=0; i<[m_ButtonArray count]; i++)
	{
		DropDownMenuButton *button=[m_ButtonArray objectAtIndex:i];
		[button setFrame:[button m_OriginRect]];
	}
	[UIView commitAnimations];
}

-(void)HideMenu
{
	[UIView beginAnimations:@"back" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDidStopSelector:@selector(ReleaseSelf)];
	[UIView setAnimationDuration:0.3f];
	
	[self setAlpha:0.0];
	
	[UIView commitAnimations];
}

-(void)ReleaseSelf
{
	if(m_MenuName!=nil)
	{
		self.m_MenuName=nil;
	}
	
	if(m_Title!=nil)
	{
		
		self.m_Title=nil;
	}
	
	if(m_TitleLable!=nil)
	{
		[m_TitleLable removeFromSuperview];
		self.m_TitleLable=nil;
	}
	
	if(m_ButtonArray!=nil)
	{
		for(int i=0; i<[m_ButtonArray count]; i++)
		{
			[(DropDownMenuButton*)[m_ButtonArray objectAtIndex:i] removeFromSuperview];
		}
		
		[m_ButtonArray removeAllObjects];
		self.m_ButtonArray=nil;
	}
	
	if(m_ImageView!=nil)
	{
		[m_ImageView removeFromSuperview];
		self.m_ImageView=nil;
	}
	
	[self setHidden:YES];
	[self removeFromSuperview];
	[self release];
	
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	
}


- (void)dealloc {
	
	if(m_MenuName!=nil)
	{
		self.m_MenuName=nil;
	}
	
	if(m_Title!=nil)
	{
		
		self.m_Title=nil;
	}
	
	if(m_TitleLable!=nil)
	{
		[m_TitleLable removeFromSuperview];
		self.m_TitleLable=nil;
	}
	
	if(m_ButtonArray!=nil)
	{
		for(int i=0; i<[m_ButtonArray count]; i++)
		{
			[(DropDownMenuButton*)[m_ButtonArray objectAtIndex:i] removeFromSuperview];
		}
		
		[m_ButtonArray removeAllObjects];
		self.m_ButtonArray=nil;
	}
	
	if(m_ImageView!=nil)
	{
		[m_ImageView removeFromSuperview];
		self.m_ImageView=nil;
	}
	
    [super dealloc];
}


@end
