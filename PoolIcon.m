//
//  PoolIcon.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define PoolIconEnlargeScale 20
#define LableHeight 27

#import "PoolIcon.h"
#import "PackingCheckListAppDelegate.h"
#import "PoolView.h"
#import "PoolPageView.h"
#import "ItemView.h"
#import "ItemPageView.h"
#import "InformationBar.h"
#import "PoolBackground.h"
#import "MenuBackground.h"
#import "Utility.h"

@implementation PoolIcon

@synthesize mDelegate;
@synthesize m_OriginRect;
@synthesize m_ItemBelongPageView;
@synthesize m_ImageView;
@synthesize m_WarningImage;
@synthesize m_Name;
@synthesize m_LableName;
@synthesize m_Draggable;
@synthesize m_DangerousTag;
@synthesize m_Visible;
@synthesize m_SortIndex;
@synthesize m_TypeTag;
@synthesize m_Behaviour;
@synthesize m_Action;
@synthesize m_ImageFileName;
@synthesize m_MenuColor;
@synthesize m_BackgroundColor;
@synthesize m_Wallpaper;
@synthesize m_ThemeSet;
@synthesize m_Lable;
@synthesize m_Customize;
@synthesize m_IconIndex;
@synthesize m_CheckImage;
@synthesize m_Quantity;
@synthesize m_QuantityImage;
@synthesize m_QuantityNumberLable;

-(void)ZoomInSubView
{
	[UIView beginAnimations:@"Zoom in" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[m_CheckImage setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	[m_ImageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	
	[UIView commitAnimations];
}

-(void)ZoomOutSubView
{
	[UIView beginAnimations:@"Zoom in" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	[m_CheckImage setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	[m_ImageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	
	[UIView commitAnimations];
}

-(void)HoldingCheck
{
	/*
	if([m_Timer timeInterval]>=0.5)
	{
		m_Drag=YES;
		
		self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, 100, 110);
	}
	else
	{
		m_Drag=NO;
	}
	 */
	
	m_Drag=YES;
	
	m_Enlarge=YES;
	
	self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, 80, 110);
	
	//enlarge imageview
	[m_ImageView setFrame:CGRectMake([m_ImageView frame].origin.x, [m_ImageView frame].origin.y, 80, 110-27)];
	
	//enlagre lable
	[m_Lable setFrame:CGRectMake(0, 110-27, [m_Lable frame].size.width, [m_Lable frame].size.height)];
	
	//enlarge check
	[m_CheckImage setFrame:CGRectMake(m_CheckImage.frame.origin.x, m_CheckImage.frame.origin.y, 80, 110)];
	
	//adjust quantity position
	[m_QuantityImage setFrame:CGRectMake(m_QuantityImage.frame.origin.x+20, m_QuantityImage.frame.origin.y, m_QuantityImage.frame.size.width, m_QuantityImage.frame.size.height)];
	
	[self StartLableAnimation:nil];
} 

-(void)ClearTimer
{
	//not use yet
	if(m_Timer)
	{
		[m_Timer release];
		m_Timer=nil;
		
		[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 60, 60)];
		
		[(PoolView*)[mDelegate m_PoolView] setAvaliableToDrag:YES];
		m_Drag=NO;
	}
}

-(void)TakeFrameBackToOrigin
{
	//since user drag image around, it needed to be set back to original position once user release mouse(touchedEnd)
	//and icon is not dragging into item view
	//By assign original rect to self frame
	
	//Animation
	[UIView beginAnimations:@"back" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	self.frame=m_OriginRect;
	
	if(m_Enlarge)
	{
		[m_CheckImage setFrame:CGRectMake(0, 0, m_OriginRect.size.width, m_OriginRect.size.height)];
		
		//also imageview
		[m_ImageView setFrame:CGRectMake([m_ImageView frame].origin.x, [m_ImageView frame].origin.y, self.frame.size.width, self.frame.size.height)];
		[m_Lable setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, LableHeight)];
		
		//adjust quantity position
		[m_QuantityImage setFrame:CGRectMake(m_QuantityImage.frame.origin.x-20, m_QuantityImage.frame.origin.y, m_QuantityImage.frame.size.width, m_QuantityImage.frame.size.height)];
	}

	
	[UIView commitAnimations];
	
	[self StopLableAnimation];
	
	m_Enlarge=NO;
}

-(void)CheckIcon
{
	if(m_Drag!=YES && isChecked==YES)
	{
		[m_CheckImage setHidden:YES];
		isChecked=NO;
	}
	else if(m_Drag!=YES && isChecked==NO)
	{
		[m_CheckImage setHidden:NO];
		isChecked=YES;
	}
}

-(void)HideCheck
{
	[m_CheckImage setHidden:YES];
	isChecked=NO;
}

-(void)StartLableAnimation:(NSString*)lableName
{
	[m_Lable setHidden:NO];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	//[m_Lable.layer removeAllAnimations];
	
	NSString *mText;
	
	if(lableName==nil)
	{
		mText=m_LableName;
	}
	else 
	{
		m_LableName=[lableName retain];
		mText=m_LableName;
	}
	
	
	
	NSUInteger textLength=[mText sizeWithFont:[UIFont systemFontOfSize:13]].width;
	
	//[m_ScrollingLable setFont:[UIFont systemFontOfSize:self.frame.size.height-6]];
	
	//adjust lable to fit text length
	[m_Lable setFrame:CGRectMake(0, m_Lable.frame.origin.y, textLength, m_Lable.frame.size.height)];
	
	
	if(m_Enlarge)
	{
		//icon has been enlarge
		if(m_Lable.frame.size.width+27>=self.frame.size.width)
		{
			
			[self ScrollLable];
			
		}
		else 
		{
			[m_Lable setFrame:CGRectMake((self.frame.size.width/2)-(m_Lable.frame.size.width/2), m_Lable.frame.origin.y, m_Lable.frame.size.width, m_Lable.frame.size.height)];
		}
	}
	else
	{
		//icon hasn't been enlarge
		if(m_Lable.frame.size.width>self.frame.size.width)
		{
			
			[self ScrollLable];
			
		}
		else 
		{
			[m_Lable setFrame:CGRectMake((self.frame.size.width/2)-(m_Lable.frame.size.width/2), m_Lable.frame.origin.y, m_Lable.frame.size.width, m_Lable.frame.size.height)];
		}
	}
	
	m_LableGoScroll=YES;
}

-(void)StopLableAnimation
{
	m_LableGoScroll=NO;
	
	[m_Lable setHidden:YES];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	//[m_Lable.layer removeAllAnimations];
	
	//[m_Lable setFrame:CGRectMake(0, self.frame.size.height-27, self.frame.size.width, 27)];
	[m_Lable setText:m_LableName];
	[m_Lable setFont:[UIFont systemFontOfSize:13]];
	[m_Lable setTextColor:[UIColor whiteColor]];
	[m_Lable setTextAlignment:UITextAlignmentCenter];
	[m_Lable setBackgroundColor:[UIColor clearColor]];
}

-(void)ScrollLable
{
	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:5.0];
	[UIView setAnimationDelegate:self];
	
	
	[m_Lable setFrame:CGRectMake(-[m_Lable frame].size.width, [m_Lable frame].origin.y, m_Lable.frame.size.width, m_Lable.frame.size.height)];
	
	
	[UIView commitAnimations];
	
	NSLog(@"scroll");
}

-(void)KeepScrollingLable
{
	if(m_LableGoScroll)
	{
		[m_Lable setFrame:CGRectMake(m_Lable.frame.size.width, [m_Lable frame].origin.y, [m_Lable frame].size.width, [m_Lable frame].size.height)];
		
		[UIView beginAnimations:nil  context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDuration:5.0];
		[UIView setAnimationDelegate:self];
		
		
		[m_Lable setFrame:CGRectMake(-[m_Lable frame].size.width, [m_Lable frame].origin.y, m_Lable.frame.size.width, m_Lable.frame.size.height)];
		
		
		[UIView commitAnimations];
		
		NSLog(@"keep scrolling");
	}
	
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([finished boolValue] && m_LableGoScroll) 
	{
        [self performSelector:@selector(KeepScrollingLable) withObject:nil afterDelay:0.2];
    }
	else 
	{
		m_LableGoScroll=NO;
		[self StopLableAnimation];
	}
	
	
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

-(id)InitWithImage:(UIImage*)mImage WithRect:(CGRect)rect
{
	if(self=[super initWithFrame:rect])
	{
		//self.image=mImage;
		
		m_OriginRect=rect;
		
		[self setUserInteractionEnabled:YES];
		//[self setMultipleTouchEnabled:YES];
		
		//setup check image
		UIImageView *checkImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
		self.m_CheckImage=checkImage;
		[checkImage release];
		[m_CheckImage setBackgroundColor:[UIColor clearColor]];
		[m_CheckImage setImage:[UIImage imageNamed:@"Check.png"]];
		
		[self addSubview:m_CheckImage];
		
		//set check image to hidden first
		[m_CheckImage setHidden:YES];
		
		isChecked=NO;
		
		m_Drag=NO;
	}
	
	return self;
}

-(void)InitImage
{
	if([UIImage imageNamed:m_ImageFileName]==nil)
	{
		//image in iphone
		
		//image in iphone
		NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDir=[documentPaths objectAtIndex:0];
		NSString *imagePath=[documentDir stringByAppendingPathComponent:m_ImageFileName];
		
		[m_ImageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
	}
	else 
	{
		//image in bundle
		[m_ImageView setImage:[UIImage imageNamed:m_ImageFileName]];
	}
	
}

//new
-(id)InitWithIconName:(NSString*)iconName WithLableName:(NSString*)lableName WithDraggable:(BOOL)draggable WithDangerousTag:(NSString*)dangerousTag
		  WithVisible:(BOOL)visible WithSortIndex:(NSUInteger)sortIndex WithTypeTag:(NSString*)typeTag WithBeaviour:(BOOL)behaviour 
		   WithAction:(NSString*)action WithFileName:(NSString*)imageFileName WithMenuColor:(NSString*)menuColor WithBackgroundColor:(UIColor*)mBackgroundColor 
		WithWallpaper:(NSString*)wallpaper WithThemeSet:(NSString*)themeSet WithCustomizeTag:(BOOL)customize WithFrame:(CGRect)viewFrame
{
	if(self=[super initWithFrame:viewFrame])
	{
		self.m_Name=iconName;
		self.m_LableName=lableName;
		m_Draggable=draggable;
		self.m_DangerousTag=dangerousTag;
		m_Visible=visible;
		m_SortIndex=sortIndex;
		self.m_TypeTag=typeTag;
		m_Behaviour=behaviour;
		self.m_Action=action;
		self.m_ImageFileName=imageFileName;
		self.m_MenuColor=menuColor;
		self.m_BackgroundColor=mBackgroundColor;
		self.m_Wallpaper=wallpaper;
		self.m_ThemeSet=themeSet;
		m_Customize=customize;
		
		
		//init image view
		UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		self.m_ImageView=imageView;
		[imageView release];
		[self InitImage];
		
		[self addSubview:m_ImageView];
		
		[self setHidden:!m_Visible];
		
		m_OriginRect=viewFrame;
		
		[self setBackgroundColor:[UIColor clearColor]];
		[self setUserInteractionEnabled:YES];
		//[self setMultipleTouchEnabled:YES];
		[self setBounds:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		[self setClipsToBounds:YES];
		
		
		//init waring image
		if([m_DangerousTag compare:@"Dangerous"]==0)
		{
			UIImageView *waringImage=[[UIImageView alloc] initWithFrame:CGRectMake(3, 0, 18, 18)];
			self.m_WarningImage=waringImage;
			[waringImage release];
			[m_WarningImage setImage:[UIImage imageNamed:@"Warning icon 18x18.png"]];
			
			[self addSubview:m_WarningImage];
		}
		
		//setup check image
		UIImageView *checkImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height)];
		self.m_CheckImage=checkImage;
		[checkImage release];
		[m_CheckImage setBackgroundColor:[UIColor clearColor]];
		[m_CheckImage setImage:[UIImage imageNamed:@"Check.png"]];

		[self addSubview:m_CheckImage];

		
		//set check image to hidden first
		[m_CheckImage setHidden:YES];
		
		//init lable
		UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, LableHeight)];
		self.m_Lable=lable;
		[lable release];
		[m_Lable setText:m_LableName];
		[m_Lable setFont:[UIFont systemFontOfSize:13]];
		[m_Lable setTextColor:[UIColor whiteColor]];
		[m_Lable setTextAlignment:UITextAlignmentCenter];
		[m_Lable setBackgroundColor:[UIColor clearColor]];
		[m_Lable setHidden:YES];

		[self addSubview:m_Lable];
		
		
		if([m_TypeTag compare:@"item"]==0)
		{
			//setup quantity background image
			UIImageView *quantityBackground=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-20, 0, 18, 18)];
			self.m_QuantityImage=quantityBackground;
			[quantityBackground release];
			[m_QuantityImage setBackgroundColor:[UIColor clearColor]];
			[m_QuantityImage setImage:[UIImage imageNamed:@"quantity-small.png"]];
			
			[self addSubview:m_QuantityImage];
			
			//set quantity
			m_Quantity=1;
			
			//setup quantity number lable
			UILabel *quantityNumberLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
			self.m_QuantityNumberLable=quantityNumberLable;
			[quantityNumberLable release];
			[m_QuantityNumberLable setText:[NSString stringWithFormat:@"%d", m_Quantity]];
			[m_QuantityNumberLable setFont:[UIFont systemFontOfSize:13]];
			[m_QuantityNumberLable setTextColor:[UIColor whiteColor]];
			[m_QuantityNumberLable setTextAlignment:UITextAlignmentCenter];
			[m_QuantityNumberLable setBackgroundColor:[UIColor clearColor]];
			
			[m_QuantityImage addSubview:m_QuantityNumberLable];
			
			[self UpdateQuantity];
		}

		
		isChecked=NO;
		
		m_Drag=NO;
	}
	
	return self;
}

-(void)SetQuantity:(int)number;
{
	m_Quantity=number;
	[m_QuantityNumberLable setText:[NSString stringWithFormat:@"%d", m_Quantity]];
	[self UpdateQuantity];
}

-(void)UpdateQuantity
{
	if(m_Quantity==1)
	{
		[m_QuantityImage setHidden:YES];
		[m_QuantityImage setFrame:CGRectMake(self.frame.size.width-20, 0, 18, 18)];
		[m_QuantityNumberLable setFrame:CGRectMake(0, 0, 18, 18)];
		[m_QuantityImage setImage:[UIImage imageNamed:@"quantity-small.png"]];
	}
	else if(m_Quantity>1 && m_Quantity<=9)
	{
		[m_QuantityImage setHidden:NO];
		[m_QuantityImage setFrame:CGRectMake(self.frame.size.width-24, 0, 18, 18)];
		[m_QuantityNumberLable setFrame:CGRectMake(0, 0, 18, 18)];
		[m_QuantityImage setImage:[UIImage imageNamed:@"quantity-small.png"]];
	}
	else if(m_Quantity>9)
	{
		[m_QuantityImage setHidden:NO];
		[m_QuantityImage setFrame:CGRectMake(self.frame.size.width-24, 0, 24, 18)];
		[m_QuantityNumberLable setFrame:CGRectMake(0, 0, 24, 18)];
		[m_QuantityImage setImage:[UIImage imageNamed:@"quantity-large.png"]];
	}
	
}

-(NSUInteger)GetPageRowContainerIndex
{
	if([self.m_TypeTag compare:@"task"]==0)
	{
		return m_OriginRect.origin.y/m_OriginRect.size.height;
	}
	else 
	{
		return (m_OriginRect.origin.y-[[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] m_TaskRowContainer]count]*m_OriginRect.size.height)/m_OriginRect.size.height;
	}

	
	return 0;
	
}

-(NSUInteger)GetColoumnIndex
{
	if([self.m_TypeTag compare:@"task"]==0)
	{
		return m_OriginRect.origin.x/m_OriginRect.size.width;
	}
	else 
	{
		return m_OriginRect.origin.x/m_OriginRect.size.width;
	}

	
	return 0;
}

-(void)InsertLeft:(PoolIcon*)icon
{
	NSMutableArray *poolPageRowContainer;
	
	if([self.m_TypeTag compare:@"task"]==0)
	{
		poolPageRowContainer=[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] m_TaskRowContainer];
		
		//get last icon
		PoolIcon *lastIcon=nil;
		if([self GetColoumnIndex]==0)
		{
			//check if has last row container
			int value=[self GetPageRowContainerIndex]-1;
			
			if(value>=0)
			{
				lastIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]-1] objectAtIndex:3];
			}
			
		}
		else 
		{
			//check if has last icon
			int value=[self GetColoumnIndex]-1;
			
			if(value>=0)
			{
				//has next icon
				lastIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]] objectAtIndex:[self GetColoumnIndex]-1];
			}
			
		}
		
		
		[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] SwapIconByFirstIconRowIndex:[icon GetPageRowContainerIndex] 
																			WithFirstIconColoumnIndex:[icon GetColoumnIndex] 
																			   WithSecondIconRowIndex:[self GetPageRowContainerIndex] 
																		   WithSecondIconColoumnIndex:[self GetColoumnIndex] 
																			 WithPoolPageRowContainer:poolPageRowContainer];
		
		//check if reach end
		if([(PoolView*)[mDelegate m_PoolView] m_InsertEndIcon]==self)
		{
			[self TakeFrameBackToOrigin];
			return;
		}
		else 
		{
			//tell next icon to do in sert right
			[lastIcon InsertLeft:icon];
			[self TakeFrameBackToOrigin];
		}
		
	}
	else 
	{
		poolPageRowContainer=[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] m_ItemRowContainer];
		
		//get last icon
		PoolIcon *lastIcon=nil;
		if([self GetColoumnIndex]==0)
		{
			//check if has last row container
			int value=[self GetPageRowContainerIndex]-1;
			
			if(value>=0)
			{
				lastIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]-1] objectAtIndex:3];
			}
			
		}
		else 
		{
			//check if has last icon
			int value=[self GetColoumnIndex]-1;
			
			if(value>=0)
			{
				//has next icon
				lastIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]] objectAtIndex:[self GetColoumnIndex]-1];
			}
			
		}
		
		
		[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] SwapIconByFirstIconRowIndex:[icon GetPageRowContainerIndex] 
																			WithFirstIconColoumnIndex:[icon GetColoumnIndex] 
																			   WithSecondIconRowIndex:[self GetPageRowContainerIndex] 
																		   WithSecondIconColoumnIndex:[self GetColoumnIndex] 
																			 WithPoolPageRowContainer:poolPageRowContainer];
		
		//check if reach end
		if([(PoolView*)[mDelegate m_PoolView] m_InsertEndIcon]==self)
		{
			[self TakeFrameBackToOrigin];
			return;
		}
		else 
		{
			//tell next icon to do in sert right
			[lastIcon InsertLeft:icon];
			[self TakeFrameBackToOrigin];
		}
	}

}

-(void)InsertRight:(PoolIcon*)icon
{
	NSMutableArray *poolPageRowContainer;
	
	if([self.m_TypeTag compare:@"task"]==0)
	{
		poolPageRowContainer=[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] m_TaskRowContainer];
		
		//get next icon
		PoolIcon *nextIcon=nil;
		if([self GetColoumnIndex]==3)
		{
			//check if has next row container
			int value=[self GetPageRowContainerIndex]+1;
			
			if(value<=[poolPageRowContainer count]-1)
			{
				nextIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]+1] objectAtIndex:0];
			}
			
		}
		else 
		{
			//check if has next icon
			int value=[self GetColoumnIndex]+1;
			
			if(value<=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]] count]-1 )
			{
				//has next icon
				nextIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]] objectAtIndex:[self GetColoumnIndex]+1];
			}
			
		}

		
		[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] SwapIconByFirstIconRowIndex:[icon GetPageRowContainerIndex] 
																			WithFirstIconColoumnIndex:[icon GetColoumnIndex] 
																			   WithSecondIconRowIndex:[self GetPageRowContainerIndex] 
																		   WithSecondIconColoumnIndex:[self GetColoumnIndex] 
																			 WithPoolPageRowContainer:poolPageRowContainer];
		
		//check if reach end
		if([(PoolView*)[mDelegate m_PoolView] m_InsertEndIcon]==self)
		{
			[self TakeFrameBackToOrigin];
			return;
		}
		else 
		{
			//tell next icon to do in sert right
			[nextIcon InsertRight:icon];
			[self TakeFrameBackToOrigin];
		}
		
	}
	else
	{
		poolPageRowContainer=[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] m_ItemRowContainer];
		
		//get next icon
		PoolIcon *nextIcon=nil;
		if([self GetColoumnIndex]==3)
		{
			//check if has next row container
			int value=[self GetPageRowContainerIndex]+1;
			
			if(value<=[poolPageRowContainer count]-1)
			{
				nextIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]+1] objectAtIndex:0];
			}
			
		}
		else 
		{
			//check if has next icon
			int value=[self GetColoumnIndex]+1;
			
			if(value<=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]] count]-1 )
			{
				//has next icon
				nextIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]] objectAtIndex:[self GetColoumnIndex]+1];
			}
			
		}
		
		
		[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] SwapIconByFirstIconRowIndex:[icon GetPageRowContainerIndex] 
																			WithFirstIconColoumnIndex:[icon GetColoumnIndex] 
																			   WithSecondIconRowIndex:[self GetPageRowContainerIndex] 
																		   WithSecondIconColoumnIndex:[self GetColoumnIndex] 
																			 WithPoolPageRowContainer:poolPageRowContainer];
		
		//check if reach end
		if([(PoolView*)[mDelegate m_PoolView] m_InsertEndIcon]==self)
		{
			[self TakeFrameBackToOrigin];
			return;
		}
		else 
		{
			//tell next icon to do in sert right
			[nextIcon InsertRight:icon];
			[self TakeFrameBackToOrigin];
		}
	}

}

-(void)SwapIcon:(CGPoint)touchPoint
{
	//convert touch point to rect
	CGRect touchRect=CGRectMake(touchPoint.x, touchPoint.y, 0, 0);
	
	//first check if touch rect intersect with any icon at same row container
	//get row container which self belong to
	NSMutableArray *poolPageRowContainer;
	NSMutableArray *rowContainer;
	
	if([self.m_TypeTag compare:@"task"]==0)
	{
		poolPageRowContainer=[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] m_TaskRowContainer];
		rowContainer=[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]];
		
		//run through each icon check if has intersection with same level
		for(int i=0; i<[rowContainer count]; i++)
		{
			//do intersection check only if icon is not equal to self
			PoolIcon *icon=[rowContainer objectAtIndex:i];
			BOOL intersect=NO;
			
			if(icon!=self)
			{
				intersect=CGRectIntersectsRect(touchRect, [icon m_OriginRect]);
				
				if(intersect)
				{
					//intersect with other icon
					[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] SwapIconByFirstIconRowIndex:[self GetPageRowContainerIndex] 
																						WithFirstIconColoumnIndex:[self GetColoumnIndex] 
																						   WithSecondIconRowIndex:[icon GetPageRowContainerIndex] 
																					   WithSecondIconColoumnIndex:[icon GetColoumnIndex] 
																						 WithPoolPageRowContainer:poolPageRowContainer];					
					//tell icon to TakeFrameBackToOrigin only the icon that intersect with this
					[icon TakeFrameBackToOrigin];
					
					return;
				}
			}
		}
		
		if((touchPoint.y-m_LastTouchPoint.y)>0)
		{
			int value=[self GetPageRowContainerIndex]+1;
			
			if(value<=[poolPageRowContainer count]-1)
			{
				rowContainer=[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]+1];
				
				//run through each icon check if has intersection with next level
				for(int i=0; i<[rowContainer count]; i++)
				{
					//do intersection check
					PoolIcon *icon=[rowContainer objectAtIndex:i];
					BOOL intersect=CGRectIntersectsRect(touchRect, [icon m_OriginRect]);
					
					if(intersect)
					{
						//intersect with other icon
						[(PoolView*)[mDelegate m_PoolView] setM_InsertEndIcon:icon];
						
						//get next icon
						PoolIcon *nextIcon=nil;
						if([self GetColoumnIndex]==3)
						{
							//check if has next row container
							int value=[self GetPageRowContainerIndex]+1;
							
							if(value<=[poolPageRowContainer count]-1)
							{
								nextIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]+1] objectAtIndex:0];
							}
							
						}
						else 
						{
							//check if has next icon
							int value=[self GetColoumnIndex]+1;
							
							if(value<=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]] count]-1 )
							{
								//has next icon
								nextIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]] objectAtIndex:[self GetColoumnIndex]+1];
							}
							
						}
						
						//tell next icon to do in sert right
						[nextIcon InsertRight:self];
					}
					
				}
				
			}
			
		}
		else if((touchPoint.y-m_LastTouchPoint.y)<0)
		{
			int value=[self GetPageRowContainerIndex]-1;
			
			if(value>=0)
			{
				rowContainer=[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]-1];
				
				//run through each icon check if has intersection with last level
				for(int i=0; i<[rowContainer count]; i++)
				{
					//do intersection check 
					PoolIcon *icon=[rowContainer objectAtIndex:i];
					BOOL intersect=CGRectIntersectsRect(touchRect, [icon m_OriginRect]);
					
					if(intersect)
					{
						//intersect with other icon
						[(PoolView*)[mDelegate m_PoolView] setM_InsertEndIcon:icon];
						
						//get next icon
						PoolIcon *nextIcon=nil;
						if([self GetColoumnIndex]==0)
						{
							//check if has next row container
							int value=[self GetPageRowContainerIndex]-1;
							
							if(value>=0)
							{
								nextIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]-1] objectAtIndex:3];
							}
							
						}
						else 
						{
							//check if has next icon
							int value=[self GetColoumnIndex]-1;
							
							if(value>=0 )
							{
								//has next icon
								nextIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]] objectAtIndex:[self GetColoumnIndex]-1];
							}
							
						}
						
						//tell next icon to do in sert right
						[nextIcon InsertLeft:self];
					}
						
				}
				
				

			}
		}

		
		
	}
	else 
	{
		poolPageRowContainer=[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] m_ItemRowContainer];
		rowContainer=[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]];
		
		//run through each icon check if has intersection with same level
		for(int i=0; i<[rowContainer count]; i++)
		{
			//do intersection check only if icon is not equal to self
			PoolIcon *icon=[rowContainer objectAtIndex:i];
			BOOL intersect=NO;
			
			if(icon!=self)
			{
				intersect=CGRectIntersectsRect(touchRect, [icon m_OriginRect]);
				
				if(intersect)
				{
					//intersect with other icon
					[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] SwapIconByFirstIconRowIndex:[self GetPageRowContainerIndex] 
																						WithFirstIconColoumnIndex:[self GetColoumnIndex] 
																						   WithSecondIconRowIndex:[icon GetPageRowContainerIndex] 
																					   WithSecondIconColoumnIndex:[icon GetColoumnIndex] 
																						 WithPoolPageRowContainer:poolPageRowContainer];					
					//tell icon to TakeFrameBackToOrigin only the icon that intersect with this
					[icon TakeFrameBackToOrigin];
					
					return;
				}
			}
		}
		
		if((touchPoint.y-m_LastTouchPoint.y)>0)
		{
			int value=[self GetPageRowContainerIndex]+1;
			
			if(value<=[poolPageRowContainer count]-1)
			{
				rowContainer=[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]+1];
				
				//run through each icon check if has intersection with next level
				for(int i=0; i<[rowContainer count]; i++)
				{
					//do intersection check
					PoolIcon *icon=[rowContainer objectAtIndex:i];
					BOOL intersect=CGRectIntersectsRect(touchRect, [icon m_OriginRect]);
					
					if(intersect)
					{
						//intersect with other icon
						[(PoolView*)[mDelegate m_PoolView] setM_InsertEndIcon:icon];
						
						//get next icon
						PoolIcon *nextIcon=nil;
						if([self GetColoumnIndex]==3)
						{
							//check if has next row container
							int value=[self GetPageRowContainerIndex]+1;
							
							if(value<=[poolPageRowContainer count]-1)
							{
								nextIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]+1] objectAtIndex:0];
							}
							
						}
						else 
						{
							//check if has next icon
							int value=[self GetColoumnIndex]+1;
							
							if(value<=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]] count]-1 )
							{
								//has next icon
								nextIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]] objectAtIndex:[self GetColoumnIndex]+1];
							}
							
						}
						
						//tell next icon to do in sert right
						[nextIcon InsertRight:self];
					}
					
				}
				
			}
			
		}
		else if((touchPoint.y-m_LastTouchPoint.y)<0)
		{
			int value=[self GetPageRowContainerIndex]-1;
			
			if(value>=0)
			{
				rowContainer=[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]-1];
				
				//run through each icon check if has intersection with last level
				for(int i=0; i<[rowContainer count]; i++)
				{
					//do intersection check 
					PoolIcon *icon=[rowContainer objectAtIndex:i];
					BOOL intersect=CGRectIntersectsRect(touchRect, [icon m_OriginRect]);
					
					if(intersect)
					{
						//intersect with other icon
						[(PoolView*)[mDelegate m_PoolView] setM_InsertEndIcon:icon];
						
						//get next icon
						PoolIcon *nextIcon=nil;
						if([self GetColoumnIndex]==0)
						{
							//check if has next row container
							int value=[self GetPageRowContainerIndex]-1;
							
							if(value>=0)
							{
								nextIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]-1] objectAtIndex:3];
							}
							
						}
						else 
						{
							//check if has next icon
							int value=[self GetColoumnIndex]-1;
							
							if(value>=0 )
							{
								//has next icon
								nextIcon=[[poolPageRowContainer objectAtIndex:[self GetPageRowContainerIndex]] objectAtIndex:[self GetColoumnIndex]-1];
							}
							
						}
						
						//tell next icon to do in sert right
						[nextIcon InsertLeft:self];
					}
					
				}
				
				
				
			}
		}
	}
	


	
}

-(void)Reset
{
	
	[(ItemPageView*)[self m_ItemBelongPageView] AddIconWithIconName:self.m_Name WithLableName:self.m_LableName 
													  WithDraggable:self.m_Draggable 
												   WithDangerousTag:self.m_DangerousTag WithVisible:self.m_Visible 
													  WithSortIndex:self.m_SortIndex WithTypeTag:self.m_TypeTag 
													  WithBehaviour:self.m_Behaviour WithAction:self.m_Action 
													  WithImageName:self.m_ImageFileName WithMenuColor:self.m_MenuColor 
												WithBackgroundColor:self.m_BackgroundColor WithWallpaper:self.m_Wallpaper 
													   WithThemeSet:self.m_ThemeSet WithCustomize:self.m_Customize 
												  WithItemIconIndex:self.m_IconIndex];
	
	
	[[mDelegate m_PoolView] setM_PoolIcon:nil];
	
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{	
	if([[touches allObjects] count]==1 &&[[mDelegate m_PoolView] avaliableToDrag])
	{
		m_LastTouchPoint=[[touches anyObject] locationInView:self.superview];
		
		//[[mDelegate m_PoolView] setM_Image:self.m_ImageView.image];
		[[mDelegate m_PoolView] setM_PoolIcon:self];
		
		[self.superview bringSubviewToFront:self];
		
		[[mDelegate m_PoolBackground].superview bringSubviewToFront:[mDelegate m_PoolBackground]];
		
		//bring to third layer by put info bar to second and menu to top
		[mDelegate BringInformationBarToTop];
		[mDelegate BringMenuToTop];
		
		//m_Timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(HoldingCheck) userInfo:nil repeats:YES];
		
		[self performSelector:@selector(HoldingCheck) withObject:nil afterDelay:DragDelayTime];
		
		[[mDelegate m_PoolView] setAvaliableToDrag:NO];
		
		//[[self nextResponder] touchesBegan:touches withEvent:event];
		
		NSLog(@"icon touched began");
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if([[touches allObjects] count]==1)
	{
		CGPoint currentPoint=[[touches anyObject] locationInView:self.superview];
		CGPoint dist;
		dist.x=currentPoint.x-m_LastTouchPoint.x;
		dist.y=currentPoint.y-m_LastTouchPoint.y;
		
		if(m_Drag)
		{
			self.frame=CGRectMake(self.frame.origin.x+dist.x, self.frame.origin.y+dist.y, self.frame.size.width, self.frame.size.height);
			
			//disable updown scroll superview
			[(PoolPageView*)self.superview setScrollEnabled:NO];
			
			//disable left right scroll superview's superview
			[(PoolView*)[mDelegate m_PoolView] setScrollEnabled:NO];
			
			//since user might drag icon to item view, pool view clip should be off otherwsie icon will be cuted
			[(PoolPageView*)self.superview setClipsToBounds:NO];
			[(PoolView*)[mDelegate m_PoolView] setClipsToBounds:NO];
			
			//dut to clip is off page on right side of current page will appear and overlap other view so make those page to invisible
			[(PoolView*)[mDelegate m_PoolView] HidePageStartIndex:[(PoolView*)[mDelegate m_PoolView] m_PageController].currentPage];
			
			//do swap icon
			[self SwapIcon:currentPoint];
			[(PoolPageView*)self.superview ManageVisibleIcons];
		}
		else
		{
			/*
			if(m_Timer)
			{
				[m_Timer invalidate];
				m_Timer=nil;
			}
			 */
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(HoldingCheck) object:nil];
			
			//[[self nextResponder] touchesMoved:touches withEvent:event];
		}
		
		m_LastTouchPoint=currentPoint;
		
		NSLog(@"icon touched move");
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	BOOL deleteSelf=NO;
	
	if([[touches allObjects] count]==1)
	{
		CGPoint endPoint=[[touches anyObject] locationInView:self.superview];
		
		if(m_Drag)
		{
			//if user not drag in to item view
			if(endPoint.x<[(PoolView*)[mDelegate m_PoolView] frame].size.width || endPoint.y<0)
			{
				[self TakeFrameBackToOrigin];
			}
			else
			{
				//user drag into item view
				//remove from pool view and container
				//get back current page it is working on
				PoolPageView *currentPage=[(PoolView*)[mDelegate m_PoolView] m_CurrentPage];
				
				//call DeleteIcon to remove this icon from container and pool view
				[currentPage DeleteIcon:self];
				
				//tell item view to add a new icon same as this one by given a image that take from PoolView class
				//the item page which is working on
				if(self.m_ItemBelongPageView!=nil)
				{
					[(ItemPageView*)[self m_ItemBelongPageView] AddIconWithIconName:self.m_Name WithLableName:self.m_LableName 
													   WithDraggable:self.m_Draggable 
													WithDangerousTag:self.m_DangerousTag WithVisible:self.m_Visible 
													   WithSortIndex:self.m_SortIndex WithTypeTag:self.m_TypeTag 
													   WithBehaviour:self.m_Behaviour WithAction:self.m_Action 
														WithImageName:self.m_ImageFileName WithMenuColor:self.m_MenuColor 
																WithBackgroundColor:self.m_BackgroundColor WithWallpaper:self.m_Wallpaper 
																	   WithThemeSet:self.m_ThemeSet WithCustomize:self.m_Customize 
																  WithItemIconIndex:self.m_IconIndex];
				}
				else 
				{
					[(ItemPageView*)[(ItemView*)[mDelegate m_ItemView] m_CurrentPage] AddIconWithIconName:self.m_Name WithLableName:self.m_LableName 
																							WithDraggable:self.m_Draggable 
																						 WithDangerousTag:self.m_DangerousTag WithVisible:self.m_Visible 
																							WithSortIndex:self.m_SortIndex WithTypeTag:self.m_TypeTag 
																							WithBehaviour:self.m_Behaviour WithAction:self.m_Action 
																							WithImageName:self.m_ImageFileName WithMenuColor:self.m_MenuColor 
																					  WithBackgroundColor:self.m_BackgroundColor WithWallpaper:self.m_Wallpaper 
																							 WithThemeSet:self.m_ThemeSet WithCustomize:self.m_Customize 
																						WithItemIconIndex:self.m_IconIndex];
				}

				deleteSelf=YES;
				
			}
			
		}
		else 
		{
			//[[self nextResponder] touchesEnded:touches withEvent:event];
		}
		
		
		[[mDelegate m_PoolView] setAvaliableToDrag:YES];
		
		//enable up down scroll superview since the this imageview has unlinked form it's superview it have to enable it's superview 
		//scrolling through mDelegate
		[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] setScrollEnabled:YES];;
		
		//enable left right scroll superview's superview
		[(PoolView*)[mDelegate m_PoolView] setScrollEnabled:YES];
		
		//since user finish drag icon, pool view clip should be on otherwsie page will not able to be seen
		[(PoolPageView*)self.superview setClipsToBounds:YES];
		[(PoolView*)[mDelegate m_PoolView] setClipsToBounds:YES];
		
		//dut to clip is on page on right side of current page should be visible
		[(PoolView*)[mDelegate m_PoolView] UnhidePageStartIndex:[(PoolView*)[mDelegate m_PoolView] m_PageController].currentPage];
		
		m_Drag=NO;
		
		[(PoolView*)[mDelegate m_PoolView] CheckEmpty];
		
		/*
		if(m_Timer)
		{
			[m_Timer invalidate];
			m_Timer=nil;
		}
		*/
		
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(HoldingCheck) object:nil];
		
		NSLog(@"touch end");
	}
	
	
	//active quantity
	if([[touches anyObject] tapCount]==2)
	{
		if([m_TypeTag compare:@"item"]==0)
		{
			[NSObject cancelPreviousPerformRequestsWithTarget:self];
			
			[(Utility*)[mDelegate m_Utility] StartUtilityWithCommand:@"Quantity" WithObject:self];
		}

	}
	//check
	if([[touches anyObject] tapCount]==1)
	{
		[self performSelector:@selector(CheckIcon) withObject:nil afterDelay:0.2];
	}
	
	if(deleteSelf)
	{
		[[mDelegate m_PoolView] setM_PoolIcon:nil];
		//delete self
		//[self release];
	}
	
	NSLog(@"touch end outside");
	
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{

	
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
	
	if(m_WarningImage!=nil)
	{
		[m_WarningImage removeFromSuperview];
		self.m_WarningImage=nil;
	}
	
	if(m_CheckImage!=nil)
	{
		[m_CheckImage removeFromSuperview];
		self.m_CheckImage=nil;
	}
	
	if(m_ItemBelongPageView!=nil)
	{
		self.m_ItemBelongPageView=nil;
	}
	
	if(m_Lable!=nil)
	{
		[m_Lable removeFromSuperview];
		self.m_Lable=nil;
	}
	
	if(m_Name!=nil)
	{
		self.m_Name=nil;
	}
	
	if(m_LableName!=nil)
	{
		self.m_LableName=nil;
	}
	
	if(m_DangerousTag!=nil)
	{
		self.m_DangerousTag=nil;
	}
	
	if(m_TypeTag!=nil)
	{
		self.m_TypeTag=nil;
	}
	
	if(m_Action!=nil)
	{
		self.m_Action=nil;
	}
	if(m_ImageFileName!=nil)
	{
		self.m_ImageFileName=nil;
	}
	
	if(m_MenuColor!=nil)
	{
		self.m_MenuColor=nil;
	}
	
	if(m_BackgroundColor!=nil)
	{
		self.m_BackgroundColor=nil;
	}
	
	
	if(m_Wallpaper!=nil)
	{
		self.m_Wallpaper=nil;
	}
	
	if(m_ThemeSet!=nil)
	{
		self.m_ThemeSet=nil;
	}
	
	if(m_QuantityImage!=nil)
	{
		self.m_QuantityImage=nil;
	}
	
	if(m_QuantityNumberLable!=nil)
	{
		self.m_QuantityNumberLable=nil;
	}
	
    [super dealloc];
}


@end
