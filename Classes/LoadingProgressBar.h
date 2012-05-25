//
//  LoadingProgressBar.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingProgressBar : UIView {
	
	UIProgressView *m_ProgressView;
	UILabel *m_StatusLable;
	
	float m_ProgressValue;
}

-(void)SetProgress:(float)value;
-(void)UpdateProgress;

@end
