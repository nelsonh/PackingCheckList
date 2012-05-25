//
//  ItemPageView.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;
@class ItemIcon;
@class PoolIcon;



@interface ItemPageView : UIScrollView <UIScrollViewDelegate>{
	
	//point to data source
	PackingCheckListAppDelegate *mDelegate;
	
	//an image that present this page view is empty
	ItemIcon *m_EmptyIcon;
	
	//self page number
	int m_PageNumber;
	
	//this page name
	NSString *m_PageName;
	
	NSString *m_PageLableName;
	
	//contain real icon
	NSMutableArray *m_PageColumnContainer;

}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) NSString *m_PageName;
@property (nonatomic, retain) NSString *m_PageLableName;
@property (nonatomic, retain) ItemIcon *m_EmptyIcon;
@property (nonatomic, retain) NSMutableArray *m_PageColumnContainer;


-(void)InitPageColumnContainer;

-(void)DeleteIcon:(ItemIcon*)icon;

-(BOOL)HasSameIconWithName:(NSString*)iconName;

//new initialize item page view
-(id)InitWithPageNumber:(int)pageNum WithPageName:(NSString*)pageName WithPageLableName:(NSString*)pageLableName WithDelegate:(PackingCheckListAppDelegate*)delegate;
//new add a new icon to this this item page view
-(void)AddIconWithIconName:(NSString*)iconName WithLableName:(NSString*)lableName WithDraggable:(BOOL)draggable WithDangerousTag:(NSString*)dangerousTag WithVisible:(BOOL)visible
			 WithSortIndex:(NSUInteger)sortIndex WithTypeTag:(NSString*)typeTag WithBehaviour:(BOOL)behaviour WithAction:(NSString*)action
			 WithImageName:(NSString*)fileName WithMenuColor:(NSString*)menuColor WithBackgroundColor:(UIColor*)mBackgroundColor WithWallpaper:(NSString*)wallpaper 
			  WithThemeSet:(NSString*)themeSet WithCustomize:(BOOL)customize WithItemIconIndex:(NSUInteger)itemIconIndex;

//these two method only use with import photo
-(void)HideIcons;
-(void)ShowIcons;

//method to check this page view is empty or not if so then show empty icon
-(void)CheckEmpty;

//called every time when item icons needed to be reposition into correct position
-(void)RedrawItemIcons;

//called evey time that item added or deleted
-(void)UpdateContentSize;

-(void)TransferIconsToPool;

-(BOOL)TansferSampleIconToPool:(NSString*)sampleIconName;
-(BOOL)TansferSampleIconToPool:(NSString*)sampleIconName WithQuantity:(int)number;

-(void)StartAnimation;
-(void)StopAnimation;

@end
