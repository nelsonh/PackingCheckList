//
//  CatalogView.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/16.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CatalogView : UIView {
	
	//catalog name bar
	UILabel *m_ScrollingLable;
	
	//scrolling speed
	CGFloat m_TextScrollingSpeed;
	


}

@property (nonatomic, retain) UILabel *m_ScrollingLable;


-(void)Reboot:(NSString*)text;
-(void)ScrollLable;
-(void)KeepScrollingLable;
-(void)StartAnimation;

@end
