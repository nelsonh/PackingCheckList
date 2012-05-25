//
//  HUDView.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/6/14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HUDView : UIView {
	
	UIView *m_ActivityBackView;
	UILabel *m_MsgLable;
	UIActivityIndicatorView *m_Activity;
}

@property (nonatomic, retain) UIView *m_ActivityBackView;
@property (nonatomic, retain) UILabel *m_MsgLable;
@property (nonatomic, retain) UIActivityIndicatorView *m_Activity;

-(id)InitWithWindow:(UIView*)window;
-(void)SetText:(NSString*)text;
-(void)Show:(BOOL)yes;


@end
