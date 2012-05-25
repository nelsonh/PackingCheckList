//
//  CrossImage.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackingCheckListAppDelegate.h"


@interface CrossImage : UIImageView <UIAlertViewDelegate>{
	
	PackingCheckListAppDelegate *mDelegate;

}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;

-(id)InitWithFrame:(CGRect)frame WithDelegate:(PackingCheckListAppDelegate*)delegate;
-(void)DeleteCustomizeIcon;


@end
