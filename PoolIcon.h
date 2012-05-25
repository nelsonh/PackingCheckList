//
//  PoolIcon.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;
@class ItemPageView;

@interface PoolIcon : UIView {
	
	//point to data source
	PackingCheckListAppDelegate *mDelegate;
	
	//origin Rect
	CGRect m_OriginRect;
	
	//last touch position
	CGPoint m_LastTouchPoint;
	
	//this view's image
	UIImageView *m_ImageView;
	
	//warning image
	UIImageView *m_WarningImage;
	
	//determind this icon is customize or not
	BOOL m_Customize;
	
	//bool indicate can be drag or not
	BOOL m_Drag;
	
	//determind this image has been enlarge
	BOOL m_Enlarge;
	
	//timer used for checking user is holding on this icon
	NSTimer *m_Timer;
	
	//check image
	UIImageView *m_CheckImage;
	
	//determind this icon is checked or not
	BOOL isChecked;
	
	//remind icon's original page in item view
	ItemPageView *m_ItemBelongPageView;
	
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
	
	NSUInteger m_IconIndex;
	
	int m_Quantity;
	
	//hold quantity background
	UIImageView *m_QuantityImage;
	
	//hold quantity number
	UILabel *m_QuantityNumberLable;

}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) ItemPageView *m_ItemBelongPageView;
@property (nonatomic, retain) UIImageView *m_ImageView;
@property (nonatomic, retain) UIImageView *m_WarningImage;
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
@property (nonatomic, retain) UIImageView *m_CheckImage;
@property (nonatomic, retain) NSString *m_ImageFileName;
@property (nonatomic, retain) NSString *m_MenuColor;
@property (nonatomic, retain) UIColor *m_BackgroundColor;
@property (nonatomic, retain) NSString *m_Wallpaper;
@property (nonatomic, retain) NSString *m_ThemeSet;
@property NSUInteger m_IconIndex;
@property int m_Quantity;
@property (nonatomic, retain) UIImageView *m_QuantityImage;
@property (nonatomic, retain) UILabel *m_QuantityNumberLable;
@property (nonatomic, retain) UILabel *m_Lable;


-(id)InitWithImage:(UIImage*)mImage WithRect:(CGRect)rect;
-(void)HoldingCheck;
-(void)ZoomInSubView;
-(void)ZoomOutSubView;

//new initialize pool icon
-(id)InitWithIconName:(NSString*)iconName WithLableName:(NSString*)lableName WithDraggable:(BOOL)draggable WithDangerousTag:(NSString*)dangerousTag
		  WithVisible:(BOOL)visible WithSortIndex:(NSUInteger)sortIndex WithTypeTag:(NSString*)typeTag WithBeaviour:(BOOL)behaviour 
		   WithAction:(NSString*)action WithFileName:(NSString*)imageFileName WithMenuColor:(NSString*)menuColor WithBackgroundColor:(UIColor*)mBackgroundColor 
		  WithWallpaper:(NSString*)wallpaper WithThemeSet:(NSString*)themeSet WithCustomizeTag:(BOOL)customize WithFrame:(CGRect)viewFrame;

-(void)InitImage;

//called every touchEnd event and image not dragging into item view
-(void)TakeFrameBackToOrigin;
-(void)ClearTimer;
-(void)CheckIcon;
-(void)HideCheck;

//method about scrolling lable
-(void)StartLableAnimation:(NSString*)lableName;
-(void)StopLableAnimation;
-(void)ScrollLable;
-(void)KeepScrollingLable;

-(NSUInteger)GetPageRowContainerIndex;
-(NSUInteger)GetColoumnIndex;
-(void)SwapIcon:(CGPoint)touchPoint;
-(void)InsertRight:(PoolIcon*)icon;
-(void)InsertLeft:(PoolIcon*)icon;

//a method to set quantity number
-(void)SetQuantity:(int)number;
//a method that set quantity lable to visiable and invisible depend on quantity number
-(void)UpdateQuantity;

-(void)Reset;



@end
