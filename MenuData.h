//
//  MenuData.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PackingCheckListAppDelegate;
@class MenuPageView;
@class CatalogData;

@interface MenuData : NSObject {
	
	PackingCheckListAppDelegate *mDelegate;
	
	//hold the menu page view 
	MenuPageView *m_MenuPageView;
	
	//an array hold sub catalog could be one or more 
	NSMutableArray *m_MainCatalogArray;

}
@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) MenuPageView *m_MenuPageView;
@property (nonatomic, retain) NSMutableArray *m_MainCatalogArray;

-(id)InitWithPageNum:(int)pageNum WithPageName:(NSString*)pageName WithDelegate:(PackingCheckListAppDelegate*)delegate;
-(void)AddIconWithIconName:(NSString*)iconName WithFileName:(NSString*)fileName;
-(void)AddCatalog:(CatalogData*)catalog;

@end
