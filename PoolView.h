//
//  PoolView.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;
@class PoolPageView;
@class PoolIcon;

@interface PoolView : UIScrollView <UIScrollViewDelegate> {
	
	//point to data source
	PackingCheckListAppDelegate *mDelegate;
	
	//page controller
	UIPageControl *m_PageController;
	
	//hold page that is visible
	NSMutableArray *m_PageContainer;
	
	//current page 
	PoolPageView *m_CurrentPage;
	
	//current pool icon
	PoolIcon *m_PoolIcon;
	
	//current selected icon
	UIImage *m_Image;
	
	//use to prevent multi-drag
	BOOL avaliableToDrag;
	
	CGRect m_OriginRect;
	
	PoolIcon *m_InsertEndIcon;
	
	UIImageView *m_PoolEmpty;
	
	//a switch to determind should save to database or not default on
	BOOL m_SavedOn;
}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property BOOL avaliableToDrag;
@property BOOL m_SavedOn;

@property (nonatomic, retain) PoolPageView *m_CurrentPage;
@property (nonatomic, retain) UIImage *m_Image;
@property (nonatomic, retain) PoolIcon *m_PoolIcon;
@property (nonatomic, retain) PoolIcon *m_InsertEndIcon;
@property (nonatomic, retain) UIPageControl *m_PageController;
@property (nonatomic, retain) NSMutableArray *m_PageContainer;
@property (nonatomic, retain) UIImageView *m_PoolEmpty;

-(void)InitPageContainer;
-(PoolPageView*)CreatePoolPageViewByPageNumber:(int)PageNum WithTypeName:(NSString*)typeName;

//hide page with start index and page index greater than given index will be hidden
//given index of page will not be hidden
//this should be called when user drag icon around
-(void)HidePageStartIndex:(int)index;

//unhide page with start index and page index greater than given index witll be show
//this should be called when user end of drag icon 
-(void)UnhidePageStartIndex:(int)index;

-(void)UpdateContentSize;

-(void)UnCheckAllIconsInPageView;

-(void)ZoomIn;
-(void)ZoomOut;

-(void)Reset;

//has pool page check if there is nay task and item 
-(void)CheckEmpty;

//check if there is a pool 
-(void)ShouldShowEmpty;

-(void)CloseCurrentPool;
-(void)CloseCurrentPoolWithoutUpdateIcon;

-(void)UpdateIcon;

-(void)CreateNewPoolWithName:(NSString*)pageName;

-(void)SortCurrentPool;

@end
