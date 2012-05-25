//
//  MainBackground.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;

@interface MainBackground : UIView {
	
	PackingCheckListAppDelegate *mDelegate;

}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;

@end
