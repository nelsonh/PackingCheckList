//
//  ImportPhotoImageView.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;

@interface ImportPhotoImageView : UIView {

	PackingCheckListAppDelegate *mDelegate;
	
	UIImageView *m_ImageView;
	
	//determind this view is visible or not
	BOOL m_Hide;
	
	NSString *m_ImageName;
}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) NSString *m_ImageName;
@property (nonatomic, retain) UIImageView *m_ImageView;

-(void)ShowWithImage:(UIImage*)mImage WithImageName:(NSString*)imageName;
-(void)Hide;

@end
