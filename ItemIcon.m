//
//  ItemIcon.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#define ItemEnlargeScale 20
#define LableHeight 27
#define LableAdjustValue 40
#define FontSize 13

#import "ItemIcon.h"
#import "PackingCheckListAppDelegate.h"
#import "ItemView.h"
#import "ItemPageView.h"
#import "PoolView.h"
#import "PoolPageView.h"
#import "ItemBackground.h"
#import "Utility.h"
#import "CrossImage.h"
#import <QuartzCore/CALayer.h>


@implementation ItemIcon

@synthesize mDelegate;
@synthesize m_OriginRect;
@synthesize m_ParentPageView;
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
@synthesize m_ImageView;
@synthesize m_WarningImage;
@synthesize m_CrossImage;
@synthesize m_Customize;
@synthesize m_ItemIconIndex;


-(void)HoldingCheck
{
	/*
	if([m_Timer timeInterval]>=0.5)
	{
		m_Drag=YES;
		
		self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, 100, 110);
	}
	else
	{
		m_Drag=NO;
	}
	*/
	
	m_Drag=YES;
	
	m_Enlarge=YES;
	
	self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width+ItemEnlargeScale, self.frame.size.height+ItemEnlargeScale);
	
	//enlarge imageview
	[m_ImageView setFrame:CGRectMake([m_ImageView frame].origin.x, [m_ImageView frame].origin.y, [m_ImageView frame].size.width+ItemEnlargeScale, [m_ImageView frame].size.height+ItemEnlargeScale)];
	
	//enlagre lable
	[m_Lable setFrame:CGRectMake(0, [m_Lable frame].origin.y+ItemEnlargeScale, [m_Lable frame].size.width, LableHeight)];
	
	[self StartLableAnimation:nil];
	
	
}

-(void)ClearTimer
{
	//not use yet
	if(m_Timer)
	{
		[m_Timer release];
		m_Timer=nil;
		
		[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 80, 90)];
		
		[(ItemView*)[mDelegate m_ItemView] setAvaliableToDrag:YES];
		m_Drag=NO;
	}
}

-(void)TakeFrameBackToOrigin
{
	//since user drag image around, it needed to be set back to original position once user release mouse(touchedEnd)
	//and icon is not dragging into pool view
	//By assign original rect to self frame
	
	if(m_Enlarge)
	{
		m_Enlarge=NO;
		
		//Animation
		[UIView beginAnimations:@"back" context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:0.3f]; 
		
		self.frame=m_OriginRect;
		
		//also imageview
		[m_ImageView setFrame:CGRectMake([m_ImageView frame].origin.x, [m_ImageView frame].origin.y, [m_ImageView frame].size.width-ItemEnlargeScale, [m_ImageView frame].size.height-20)];
		
		[m_Lable setFrame:CGRectMake(0, [m_Lable frame].origin.y-ItemEnlargeScale, m_OriginRect.size.width, LableHeight)];
		
		[UIView commitAnimations];
		
		
		
		//also lable
		//[m_Lable setFrame:CGRectMake([m_Lable frame].origin.x, [m_Lable frame].origin.y-EnlargeScale, [m_Lable frame].size.width, [m_Lable frame].size.height)];

		[self StartLableAnimation:nil];
		//[self StopLableAnimation];
	}

}

-(void)StartLableAnimation:(NSString*)lableName
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[m_Lable.layer removeAllAnimations];
	
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
		if(m_Lable.frame.size.width+ItemEnlargeScale>=self.frame.size.width)
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
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[m_Lable.layer removeAllAnimations];
	
	
	//[m_Lable setFrame:CGRectMake(0, self.frame.size.height-27, self.frame.size.width, 27)];
	[m_Lable setText:m_LableName];
	[m_Lable setFont:[UIFont systemFontOfSize:FontSize]];
	[m_Lable setTextColor:[UIColor whiteColor]]; 
	[m_Lable setTextAlignment:UITextAlignmentCenter];
	[m_Lable setBackgroundColor:[UIColor clearColor]];
}

-(void)ScrollLable
{
	
	
	[UIView beginAnimations:m_LableName context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:5.0];
	[UIView setAnimationDelegate:self];
	
	
	[m_Lable setFrame:CGRectMake(-[m_Lable frame].size.width, [m_Lable frame].origin.y, m_Lable.frame.size.width, m_Lable.frame.size.height)];
	
	
	[UIView commitAnimations];
	
	NSLog(@"scroll");
}

-(void)KeepScrollingLable
{

	[m_Lable setFrame:CGRectMake(self.frame.size.width, [m_Lable frame].origin.y, [m_Lable frame].size.width, m_Lable.frame.size.height)];	
	
	
	[UIView beginAnimations:nil  context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:5.0];
	[UIView setAnimationDelegate:self];
	
	
	[m_Lable setFrame:CGRectMake(-[m_Lable frame].size.width, [m_Lable frame].origin.y, m_Lable.frame.size.width, m_Lable.frame.size.height)];
	
	
	[UIView commitAnimations];
	
	NSLog(@"keep scrolling");

}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    /*
	if (![finished boolValue] && m_LableGoScroll) 
	{
        [self performSelector:@selector(KeepScrollingLable) withObject:nil afterDelay:0.2];
    }
	else 
	{
		m_LableGoScroll=NO;
		[self StopLableAnimation];
	}
	 */

	if ([finished boolValue]) 
	{
        [self performSelector:@selector(KeepScrollingLable) withObject:nil afterDelay:0.2];
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
		
		m_Drag=NO;
	}
	
	return self;
}

-(void)InitImage
{
	if([UIImage imageNamed:m_ImageFileName]==nil)
	{
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
		 WithDelegate:(PackingCheckListAppDelegate*)delegate
{
	if(self=[super initWithFrame:viewFrame])
	{
		self.mDelegate=delegate;
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
		
		if(mBackgroundColor!=nil)
		{
			self.m_BackgroundColor=mBackgroundColor;
		}
		else 
		{
			self.m_BackgroundColor=nil;
		}

		
		self.m_Wallpaper=wallpaper;
		self.m_ThemeSet=themeSet;
		m_Customize=customize;
		
		
		//self.image=[UIImage imageNamed:m_ImageFileName];
		
		//init image view
		UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width-10, self.frame.size.height-30)];
		self.m_ImageView=imageView;
		[imageView release];
		[self InitImage];
		
		[self addSubview:m_ImageView];
		
		self.hidden=!m_Visible;
		
		//init cross image
		CrossImage *crossImage=[[CrossImage alloc] InitWithFrame:CGRectMake(0, -5, 18, 18) WithDelegate:self.mDelegate];
		self.m_CrossImage=crossImage;
		[crossImage release];
		
		
		if(m_Customize)
		{
			[m_CrossImage setHidden:NO];
		}
		else 
		{
			[m_CrossImage setHidden:YES];
		}
		
		
		[self addSubview:m_CrossImage];
		
		//init waring image
		if([m_DangerousTag compare:@"Dangerous"]==0)
		{
			UIImageView *waringImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, -5, 18, 18)];
			self.m_WarningImage=waringImage;
			[waringImage release];
			[m_WarningImage setImage:[UIImage imageNamed:@"Warning icon 18x18.png"]];
			
			[self addSubview:m_WarningImage];
		}
		
		m_OriginRect=viewFrame;
		
		[self setBackgroundColor:[UIColor clearColor]];
		[self setUserInteractionEnabled:YES];
		//[self setMultipleTouchEnabled:YES];
		[self setBounds:CGRectMake(0, -5, self.frame.size.width, self.frame.size.height)];
		[self setClipsToBounds:YES];
		
		
		m_Drag=NO;
		m_Enlarge=NO;
		
		//init lable
		UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-LableAdjustValue, self.frame.size.width, LableHeight)];
		self.m_Lable=lable;
		[lable release];
		[m_Lable setText:m_LableName];
		[m_Lable setFont:[UIFont systemFontOfSize:FontSize]];
		[m_Lable setTextColor:[UIColor whiteColor]];
		[m_Lable setTextAlignment:UITextAlignmentCenter];
		[m_Lable setBackgroundColor:[UIColor clearColor]];
		
		[self addSubview:m_Lable];
		
		
		//[self setBackgroundColor:[UIColor cyanColor]];
		//[m_ImageView setBackgroundColor:[UIColor redColor]];
		//[m_Lable setBackgroundColor:[UIColor yellowColor]];
		
		
	}
	
	return self;
}

-(void)TransferSelfToPool
{
	//tell icons parent page to delete this icon 
	[m_ParentPageView DeleteIcon:self];
	
	//add to correspond page in pool item view
	[(PoolPageView*)[[(PoolView*)[mDelegate m_PoolView] m_PageContainer] objectAtIndex:0] AddIconWithIconName:self.m_Name WithLableName:self.m_LableName 
																								WithDraggable:self.m_Draggable 
																							 WithDangerousTag:self.m_DangerousTag WithVisible:self.m_Visible 
																								WithSortIndex:self.m_SortIndex WithTypeTag:self.m_TypeTag 
																								WithBehaviour:self.m_Behaviour WithAction:self.m_Action 
																								WithImageName:self.m_ImageFileName WithMenuColor:self.m_MenuColor 
																						  WithBackgroundColor:self.m_BackgroundColor 
																								WithWallpaper:self.m_Wallpaper 
																								 WithThemeSet:self.m_ThemeSet
																								WithCustomize: self.m_Customize 
																						   WithParentPageView:self.m_ParentPageView 
																								WithIconIndex:self.m_ItemIconIndex];
	
	//tell parent page view to check if empty
	[(ItemPageView*)[self m_ParentPageView] CheckEmpty];
	[[mDelegate m_ItemView] setM_ItemIcon:nil];
}

-(void)TransferSelfToPoolWithQuantity:(int)quantity
{
	//tell icons parent page to delete this icon 
	[m_ParentPageView DeleteIcon:self];
	
	//add to correspond page in pool item view
	[(PoolPageView*)[[(PoolView*)[mDelegate m_PoolView] m_PageContainer] objectAtIndex:0] AddIconWithIconName:self.m_Name WithLableName:self.m_LableName 
																								WithDraggable:self.m_Draggable 
																							 WithDangerousTag:self.m_DangerousTag WithVisible:self.m_Visible 
																								WithSortIndex:self.m_SortIndex WithTypeTag:self.m_TypeTag 
																								WithBehaviour:self.m_Behaviour WithAction:self.m_Action 
																								WithImageName:self.m_ImageFileName WithMenuColor:self.m_MenuColor 
																						  WithBackgroundColor:self.m_BackgroundColor 
																								WithWallpaper:self.m_Wallpaper 
																								 WithThemeSet:self.m_ThemeSet
																								WithCustomize: self.m_Customize 
																						   WithParentPageView:self.m_ParentPageView 
																								WithIconIndex:self.m_ItemIconIndex
																								 WithQuantity:quantity];
	
	//tell parent page view to check if empty
	[(ItemPageView*)[self m_ParentPageView] CheckEmpty];
	[[mDelegate m_ItemView] setM_ItemIcon:nil];
}

-(void)BackToDefault
{
	[self TakeFrameBackToOrigin];
	
	[[mDelegate m_ItemView] setAvaliableToDrag:YES];
	
	//enable up down scroll superview since the this imageview has unlinked form it's superview it have to enable it's superview 
	//scrolling through mDelegate
	[(ItemPageView*)[(ItemView*)[mDelegate m_ItemView] m_CurrentPage] setScrollEnabled:YES];;
	
	//enable left right scroll superview's superview
	[(ItemView*)[mDelegate m_ItemView] setScrollEnabled:YES];
	
	//since user finish drag icon, pool view clip should be on otherwsie page will not able to be seen
	[self.superview setClipsToBounds:YES];
	[(ItemView*)[mDelegate m_ItemView] setClipsToBounds:YES];
	
	//dut to clip is on page on right side of current page should be visible
	[(ItemView*)[mDelegate m_ItemView] UnhidePageStartIndex:[(ItemView*)[mDelegate m_ItemView] m_PageController].currentPage];
	
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(HoldingCheck) object:nil];
	
	m_Drag=NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if([[touches allObjects] count]==1 && m_Draggable==YES &&[[mDelegate m_ItemView] avaliableToDrag])
	{
		
		m_LastTouchPoint=[[touches anyObject] locationInView:self.superview];
		
		//[[mDelegate m_ItemView] setM_Image:self.m_ImageView.image];
		[[mDelegate m_ItemView] setM_ItemIcon:self];
		
		[self.superview bringSubviewToFront:self];
		
		[[mDelegate m_ItemBackground].superview bringSubviewToFront:[mDelegate m_ItemBackground]];
		
		//bring to third layer by put info bar to second and menu to top
		[mDelegate BringInformationBarToTop];
		[mDelegate BringMenuToTop];
		
		//m_Timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(HoldingCheck) userInfo:nil repeats:YES];
		
		[self performSelector:@selector(HoldingCheck) withObject:nil afterDelay:DragDelayTime];
		
		[[mDelegate m_ItemView] setAvaliableToDrag:NO];
		
		//[[self nextResponder] touchesBegan:touches withEvent:event];
		
		
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
			[(ItemPageView*)self.superview setScrollEnabled:NO];
			
			//disable left right scroll superview's superview
			[(ItemView*)[mDelegate m_ItemView] setScrollEnabled:NO];
			
			//since user might drag icon to item view, pool view clip should be off otherwsie icon will be cuted
			[(ItemPageView*)self.superview setClipsToBounds:NO];
			[(ItemView*)[mDelegate m_ItemView] setClipsToBounds:NO];
			
			//dut to clip is off page on right side of current page will appear and overlap other view so make those page to invisible
			[(ItemView*)[mDelegate m_ItemView] HidePageStartIndex:[(ItemView*)[mDelegate m_ItemView] m_PageController].currentPage];
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
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	BOOL deleteSelf=NO;
	
	//if this icon has utility pass command to utility
	if([[touches anyObject] tapCount]==1 && m_Behaviour==YES)
	{
		[[mDelegate m_Utility] StartUtilityWithCommand:m_Action WithObject:self];
	}
	
	if([[touches allObjects] count]==1)
	{
		CGPoint endPoint=[[touches anyObject] locationInView:self.superview];
		
		if(m_Drag)
		{
			
			if(endPoint.x<0 && endPoint.y>0 && [(PoolView*)[mDelegate m_PoolView] m_CurrentPage]==nil)
			{
				[self TakeFrameBackToOrigin];
				
				[mDelegate NoCustomAlert:@"Alert" WithMessage:@"There is no pool currently please choose one to start"];
			}
			else if(endPoint.x<0 && endPoint.y>0 && [(PoolView*)[mDelegate m_PoolView] m_CurrentPage]!=nil)
			{
				//user drag into item view
				//remove from current item page view and container
				//get back current page it is working on
				ItemPageView *currentPage=[(ItemView*)[mDelegate m_ItemView] m_CurrentPage];
				
				//call DeleteIcon to remove this icon from container and current item page view
				[currentPage DeleteIcon:self];
				
				//add to correspond page in pool item view
				[(PoolPageView*)[[(PoolView*)[mDelegate m_PoolView] m_PageContainer] objectAtIndex:0] AddIconWithIconName:self.m_Name WithLableName:self.m_LableName 
																											WithDraggable:self.m_Draggable 
																										 WithDangerousTag:self.m_DangerousTag WithVisible:self.m_Visible 
																											WithSortIndex:self.m_SortIndex WithTypeTag:self.m_TypeTag 
																											WithBehaviour:self.m_Behaviour WithAction:self.m_Action 
																											WithImageName:self.m_ImageFileName WithMenuColor:self.m_MenuColor 
																									  WithBackgroundColor:self.m_BackgroundColor 
																											WithWallpaper:self.m_Wallpaper 
																											 WithThemeSet:self.m_ThemeSet
																											WithCustomize: self.m_Customize 
																									   WithParentPageView:self.m_ParentPageView 
																											WithIconIndex:self.m_ItemIconIndex];
				
				//tell parent page view to check if empty
				[(ItemPageView*)[self m_ParentPageView] CheckEmpty];
				
				deleteSelf=YES;
			}
			else 
			{
				[self TakeFrameBackToOrigin];
			}

			
		}
		
	}
	
	[[mDelegate m_ItemView] setAvaliableToDrag:YES];
	
	//enable up down scroll superview since the this imageview has unlinked form it's superview it have to enable it's superview 
	//scrolling through mDelegate
	[(ItemPageView*)[(ItemView*)[mDelegate m_ItemView] m_CurrentPage] setScrollEnabled:YES];;
	
	//enable left right scroll superview's superview
	[(ItemView*)[mDelegate m_ItemView] setScrollEnabled:YES];
	
	//since user finish drag icon, pool view clip should be on otherwsie page will not able to be seen
	[self.superview setClipsToBounds:YES];
	[(ItemView*)[mDelegate m_ItemView] setClipsToBounds:YES];
	
	//dut to clip is on page on right side of current page should be visible
	[(ItemView*)[mDelegate m_ItemView] UnhidePageStartIndex:[(ItemView*)[mDelegate m_ItemView] m_PageController].currentPage];
	
	
	/*
	if(m_Timer)
	{
		[m_Timer invalidate];
		m_Timer=nil;
	}
	*/

	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(HoldingCheck) object:nil];
	
	m_Drag=NO;
	
	if(deleteSelf)
	{
		
		[[mDelegate m_ItemView] setM_ItemIcon:nil];
		
		//delete self
		//[self release];
	}
	
	NSLog(@"touch end been called");
	
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	//[self touchesEnded:touches withEvent:event];
	NSLog(@"touch cancel been called");
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
	
	if(m_CrossImage!=nil)
	{
		
		[m_CrossImage removeFromSuperview];
		self.m_CrossImage=nil;
	}
	
	if(m_WarningImage!=nil)
	{
		[m_WarningImage removeFromSuperview];
		self.m_WarningImage=nil;
	}
	
	
	if(m_ParentPageView!=nil)
	{
		self.m_ParentPageView=nil;
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
	
    [super dealloc];
}


@end
