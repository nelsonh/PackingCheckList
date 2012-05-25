//
//  ItemIcon.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackingCheckListAppDelegate.h"

@class ItemPageView;
@class CrossImage;


@interface ItemIcon : UIView {
	
	//point to data source
	PackingCheckListAppDelegate *mDelegate;
	
	//this view's image
	UIImageView *m_ImageView;
	
	//cross image
	CrossImage *m_CrossImage;
	
	//warning image
	UIImageView *m_WarningImage;
	
	//determind this icon is customize or not
	BOOL m_Customize;
	
	//origin Rect
	CGRect m_OriginRect;
	
	//last touch position
	CGPoint m_LastTouchPoint;
	
	//bool indicate can be drag or not
	BOOL m_Drag;
	
	//determind this image has been enlarge
	BOOL m_Enlarge;
	
	//timer used for checking user is holding on this icon
	NSTimer *m_Timer;
	
	//remind which page view in tiem this icon belong to
	ItemPageView *m_ParentPageView;
	
	//lable
	UILabel *m_Lable;
	
	
	//this item icon's name
	NSString *m_Name;
	
	//this item icon 's lable name
	NSString *m_LableName;
	
	//use to determind this icon is draggable or not draggable yes=draggable no=not draggable
	BOOL m_Draggable;
	
	//dangerous tag is a dangerous description
	NSString *m_DangerousTag;
	
	//determind this icon is visible or not
	BOOL m_Visible;
	
	//sort index use to sort item 
	NSUInteger m_SortIndex;
	
	//type tag use to determind this icon is item or task
	NSString *m_TypeTag;
	
	//behaviour use to determind this icon has behaviour or not
	BOOL m_Behaviour;
	
	//action command use to trigger functionality
	NSString *m_Action;
	
	//image file name
	NSString *m_ImageFileName;
	
	//menu color 
	NSString *m_MenuColor;
	
	//background color
	UIColor *m_BackgroundColor;
	
	//wallpaper
	NSString *m_Wallpaper;
	
	//theme set
	NSString *m_ThemeSet;
	
	
	BOOL m_LableGoScroll;
	
	NSUInteger m_ItemIconIndex;

}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) UIImageView *m_ImageView;
@property (nonatomic, retain) CrossImage *m_CrossImage;
@property (nonatomic, retain) UIImageView *m_WarningImage;
@property (nonatomic, retain) ItemPageView *m_ParentPageView;
@property CGRect m_OriginRect;
@property (nonatomic, retain) NSString *m_Name;
@property (nonatomic, retain) NSString *m_LableName;
@property BOOL m_Draggable;
@property BOOL m_Customize;
@property (nonatomic, retain) NSString *m_DangerousTag;
@property BOOL m_Visible;
@property NSUInteger m_SortIndex;
@property (nonatomic, retain) NSString *m_TypeTag;
@property BOOL m_Behaviour;
@property (nonatomic, retain) NSString *m_Action;
@property (nonatomic, retain) NSString *m_ImageFileName;
@property (nonatomic, retain) NSString *m_MenuColor;
@property (nonatomic, retain) UIColor *m_BackgroundColor;
@property (nonatomic, retain) NSString *m_Wallpaper;
@property (nonatomic, retain) NSString *m_ThemeSet;
@property (nonatomic, retain) UILabel *m_Lable;
@property NSUInteger m_ItemIconIndex;

-(id)InitWithImage:(UIImage*)mImage WithRect:(CGRect)rect;

//new initialize item icon
-(id)InitWithIconName:(NSString*)iconName WithLableName:(NSString*)lableName WithDraggable:(BOOL)draggable WithDangerousTag:(NSString*)dangerousTag
		  WithVisible:(BOOL)visible WithSortIndex:(NSUInteger)sortIndex WithTypeTag:(NSString*)typeTag WithBeaviour:(BOOL)behaviour 
		   WithAction:(NSString*)action WithFileName:(NSString*)imageFileName WithMenuColor:(NSString*)menuColor WithBackgroundColor:(UIColor*)mBackgroundColor 
		WithWallpaper:(NSString*)wallpaper WithThemeSet:(NSString*)themeSet WithCustomizeTag:(BOOL)customize WithFrame:(CGRect)viewFrame 
		 WithDelegate:(PackingCheckListAppDelegate*)delegate;

-(void)InitImage;

//called every touchEnd event and image not dragging into pool view
-(void)TakeFrameBackToOrigin;
-(void)ClearTimer;
-(void)HoldingCheck;



//method about scrolling lable
-(void)StartLableAnimation:(NSString*)lableName;
-(void)StopLableAnimation;
-(void)ScrollLable;
-(void)KeepScrollingLable;

-(void)TransferSelfToPool;
-(void)TransferSelfToPoolWithQuantity:(int)quantity;

-(void)BackToDefault;

@end
