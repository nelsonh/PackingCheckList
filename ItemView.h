//
//  ItemView.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;
@class ItemPageView;
@class ItemIcon;

@interface ItemView : UIScrollView <UIScrollViewDelegate>{

	//point to data source
	PackingCheckListAppDelegate *mDelegate;
	
	//page controller
	UIPageControl *m_PageController;
	
	//hold page that is visible
	NSMutableArray *m_PageContainer;
	
	//current page 
	ItemPageView *m_CurrentPage;
	
	//current item icon
	ItemIcon *m_ItemIcon;
	
	//current selected icon
	UIImage *m_Image;
	
	//use to prevent multi-drag
	BOOL avaliableToDrag;
	
	//last page index
	int m_LastPageIndex;
	
}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property BOOL avaliableToDrag;

@property (nonatomic, retain) ItemPageView *m_CurrentPage;
@property (nonatomic, retain) UIImage *m_Image;
@property (nonatomic, retain) ItemIcon *m_ItemIcon;
@property (nonatomic, retain) UIPageControl *m_PageController;
@property (nonatomic, retain) NSMutableArray *m_PageContainer;

-(void)InitPageContainer;

-(void)ShowLeftNarrow;
-(void)ShowRightNarrow;
-(void)ShowBothNarrow;
-(void)HideBothNarrow;

//hide page with start index and page index smaller than given index will be hidden
//given index of page will not be hidden
//this should be called when user drag icon around
-(void)HidePageStartIndex:(int)index;

//unhide page with start index and page index smaller than given index witll be show
//this should be called when user end of drag icon 
-(void)UnhidePageStartIndex:(int)index;

//use to update item view, this should be called every time user change or scroll top menu 
-(void)UpdateItemView;

-(void)UpdateContentSize;

-(void)Reset;

-(void)TransferAllIconsToPool;

-(void)TransferSampleToPoolWithSampleTableName:(NSString*)tableName;

-(void)TransferIconToPoolWithCustomTableName:(NSString*)tableName;

@end
