//
//  PoolSubView.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;
@class PoolIcon;
@class ItemIcon;
@class ItemPageView;

@interface PoolPageView : UIScrollView <UIScrollViewDelegate>{
	
	//point to data source
	PackingCheckListAppDelegate *mDelegate;
	
	//self page number
	int m_PageNumber;
	
	//row array have several item container, item container is a array which contain real icon
	NSMutableArray *m_TaskRowContainer;
	NSMutableArray *m_ItemRowContainer;
	
	CGRect m_OriginRect;
	
	NSString *m_PageName;
}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) NSMutableArray *m_TaskRowContainer;
@property (nonatomic, retain) NSMutableArray *m_ItemRowContainer;
@property (nonatomic, retain) NSString *m_PageName;

-(id)InitWithPageNumber:(int)pageNum WithPageName:(NSString*)pageName WithFrame:(CGRect)viewFrame;
-(void)InitRowContainer;
-(void)DeleteIcon:(PoolIcon*)icon;

//new add a new icon to this this item page view
-(void)AddIconWithIconName:(NSString*)iconName WithLableName:(NSString*)lableName WithDraggable:(BOOL)draggable WithDangerousTag:(NSString*)dangerousTag WithVisible:(BOOL)visible
			 WithSortIndex:(NSUInteger)sortIndex WithTypeTag:(NSString*)typeTag WithBehaviour:(BOOL)behaviour WithAction:(NSString*)action
			 WithImageName:(NSString*)fileName WithMenuColor:(NSString*)menuColor WithBackgroundColor:(UIColor*)mBackgroundColor 
			 WithWallpaper:(NSString*)wallpaper WithThemeSet:(NSString*)themeSet WithCustomize:(BOOL)customize WithParentPageView:(ItemPageView*)parentPage
			 WithIconIndex:(NSUInteger)iconIndex;

-(void)AddIconWithIconName:(NSString*)iconName WithLableName:(NSString*)lableName WithDraggable:(BOOL)draggable WithDangerousTag:(NSString*)dangerousTag WithVisible:(BOOL)visible
			 WithSortIndex:(NSUInteger)sortIndex WithTypeTag:(NSString*)typeTag WithBehaviour:(BOOL)behaviour WithAction:(NSString*)action
			 WithImageName:(NSString*)fileName WithMenuColor:(NSString*)menuColor WithBackgroundColor:(UIColor*)mBackgroundColor 
			 WithWallpaper:(NSString*)wallpaper WithThemeSet:(NSString*)themeSet WithCustomize:(BOOL)customize WithParentPageView:(ItemPageView*)parentPage
			 WithIconIndex:(NSUInteger)iconIndex WithQuantity:(int)quantity;

//remove empty item container
-(void)ClearAllEmptyContainer;

//called every time icon been deleted from pool
//reposition each icon into corrent position
-(void)SortIcons;

//called every time when pool icons needed to be reposition into correct position
-(void)RedrawPoolIcons;

//called evey time that item added or deleted
-(void)UpdateContentSizeWithIconWidth:(int)iconWidth;

-(void)UnCheckAllIcons;
-(BOOL)IsPoolEmpty;
-(BOOL)IsAnyIconChecked;

-(void)ZoomIn;
-(void)ZoomOut;

-(void)SwapIconByFirstIconRowIndex:(NSUInteger)firstRowIndex WithFirstIconColoumnIndex:(NSUInteger)firstColoumnIndex WithSecondIconRowIndex:(NSUInteger)secondRowIndex WithSecondIconColoumnIndex:(NSUInteger)secondColoumnIndex WithPoolPageRowContainer:(NSMutableArray*)container;

-(void)Reset;

-(void)SaveIconDataToPoolTableWithPoolTableName:(NSString*)poolTableName WithIconName:(NSString*)iconName WithIconLableName:(NSString*)iconLableName 
									WithTypeTag:(NSString*)typeTag WithQuantity:(NSUInteger)quantity;

-(void)DeleteIconDataFromPoolTableWithIconName:(NSString*)iconName;

-(void)Sort;

-(void)QuickSort:(NSMutableArray*)mutableArray WithLeft:(int)left WithRight:(int)right;

-(void)ManageVisibleIcons;

-(void)ManageVisibleIcons:(PoolIcon*)icon;

@end
