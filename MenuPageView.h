//
//  MenuPageView.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;

@interface MenuPageView : UIScrollView <UIScrollViewDelegate>{
	
	//point to data source
	PackingCheckListAppDelegate *mDelegate;
	
	//page controller
	UIPageControl *m_PageController;
	
	//self page number
	int m_PageNumber;
	
	//contain real icon
	NSMutableArray *m_PageIconContainer;
	
	//content offset begin
	CGPoint m_ContentOffsetBegin;
	
	//this page name
	NSString *m_PageName;
	
	//last page index
	int m_LastPageIndex;

}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) UIPageControl *m_PageController;
@property (nonatomic, retain) NSString *m_PageName;
@property (nonatomic, retain) NSMutableArray *m_PageIconContainer;


//new initialize menu page view
-(id)InitWithPageNumber:(int)pageNum WithName:(NSString*)pageName WithFrame:(CGRect)viewFrame WithDelegate:(PackingCheckListAppDelegate*)delegate;
//new add a new icon to this menu page view
-(void)AddIconWithIconName:(NSString*)iconName WithImageFileName:(NSString*)fileName;
//new call this method to reposition icon to correct position
-(void)Finish;

-(void)InitPageIconContainer;


//called evey time that item added or deleted
-(void)UpdateContentSize;
-(NSUInteger)GetCurrentPageIndex;

-(void)ScrollToBySubIndex:(NSUInteger)subIndex;
-(void)ApaulScrollToBySubIndex:(NSUInteger)subIndex;

-(void)Presentation:(NSUInteger)endSubIndex;

@end
