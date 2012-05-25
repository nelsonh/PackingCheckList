//
//  UIProgressHUD.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIProgressHUD : NSObject {
	

}

- (void) show: (BOOL) yesOrNo;

- (UIProgressHUD *) initWithWindow: (UIView *) window;

-(void)setText:(NSString*)theText;

@end
