//
//  CatalogData.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PackingCheckListAppDelegate;
@class ItemPageView;

@interface CatalogData : NSObject {
	
	PackingCheckListAppDelegate *mDelegate;
	
	//hold one or more item page view
	NSMutableArray *m_ItemPageViewArray;

}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) NSMutableArray *m_ItemPageViewArray;

-(id)InitWithDelegate:(PackingCheckListAppDelegate*)delegate;
-(void)AddItemPageView:(ItemPageView*)itemPageView;

@end
