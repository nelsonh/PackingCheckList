//
//  TextFieldAlertView.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/6/14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextFieldAlertView : UIAlertView <UITextFieldDelegate>{
	
	UITextField *m_TextField;

}

@property (nonatomic, retain) UITextField *m_TextField;

-(id)InitWithTitle:(NSString*)title WithMessage:(NSString*)msg WithDelegate:(id)delegte WithPlaceHolder:(NSString*)placeHolder WithButtons:(NSArray*)buttonArray;

@end
