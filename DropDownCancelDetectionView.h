//
//  DropDownCancelDetectionView.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;

@interface DropDownCancelDetectionView : UIView {
	
	PackingCheckListAppDelegate *mDelegate;

}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;

@end
