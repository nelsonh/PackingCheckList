//
//  AlertTableView.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;

@interface AlertTableView : UIAlertView<UITableViewDelegate, UITableViewDataSource> {
	
	PackingCheckListAppDelegate *mDelegate;
	
	//alert view
	UIAlertView *m_AlertView;
	
	//table view
	UITableView *m_TableView;
	
	//title
	NSString *m_Title;
	
	NSMutableArray *m_Data;
	
	int m_TableHeight;
	
	NSString *m_Action;

}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) NSMutableArray *m_Data;

-(void)PrepareTableWithData:(NSMutableArray*)data WithAction:(NSString*)action WithDelegate:(PackingCheckListAppDelegate*)delegate;

@end
