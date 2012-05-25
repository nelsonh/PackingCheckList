//
//  NamePhotoController.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NamePhotoView;

@interface NamePhotoController : UIViewController <UIAlertViewDelegate>{
	
	NamePhotoView *m_NamePhotoView;
	
	BOOL m_PhotoOverWrite;
	
	NSString *m_Text;
}

@property (nonatomic, retain) NamePhotoView *m_NamePhotoView;

-(void)NameImageAlert;
-(void)ImageOverWriteAlert;
-(void)NameImageAlertWithTitle:(NSString*)mTitle WithMessage:(NSString*)message;
-(void)BlankNameAlert;
-(BOOL)IsEnterNameUsedBySystem:(NSString*)enterName;
-(BOOL)IsEnterNameExistInCustomizeList:(NSString *)enterName;

@end
