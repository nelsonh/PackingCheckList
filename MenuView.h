//
//  MenuView.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;
@class MenuPageView;

@interface MenuView : UIScrollView <UIScrollViewDelegate> {
	
	//point to data source
	PackingCheckListAppDelegate *mDelegate;
	
	//page controller
	UIPageControl *m_PageController;
	
	//hold page that is visible
	NSMutableArray *m_PageContainer;
	
	//current page 
	MenuPageView *m_CurrentPage;
	
	//last page index
	int m_LastPageIndex;
	
	NSUInteger m_TempSubIndex;
	NSUInteger m_TempMenuIndex;
}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;

@property (nonatomic, retain) MenuPageView *m_CurrentPage;
@property (nonatomic, retain) UIPageControl *m_PageController;
@property (nonatomic, retain) NSMutableArray *m_PageContainer;

-(void)InitPageContainer;

-(void)Reset;

-(void)ScrollMenuByMenuIndex:(NSUInteger)menuIndex;
-(void)ScrollToByMenuIndex:(NSUInteger)menuIndex WithSubMenuIndex:(NSUInteger)subIndex;
-(void)ApaulScrollMenuByMenuIndex:(NSUInteger)menuIndex;
-(void)UpdateNarrow;
-(void)ScrollToHelp:(NSUInteger)menuIndex;



@end
