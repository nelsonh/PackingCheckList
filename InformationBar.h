//
//  InformationBar.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;
@class CatalogView;
@class FileSystemBar;


@interface InformationBar : UIView {
	
	//point to data source
	PackingCheckListAppDelegate *mDelegate;
	
	//menu name bar
	UILabel *m_MenuNameBar;
	
	//catalog view
	CatalogView *m_CatalogView;
	
	CGRect m_OriginRect;
	
	UIImageView *m_BackgroundImage;
	
	FileSystemBar *m_FileSystemBar;
	
	NSString *m_ImageFileName;
}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) UILabel *m_MenuNameBar;
@property (nonatomic, retain) CatalogView *m_CatalogView;
@property (nonatomic, retain) FileSystemBar *m_FileSystemBar;
@property (nonatomic, retain) UIImageView *m_BackgroundImage;
@property (nonatomic, retain) NSString *m_ImageFileName;

-(void)EaseOut;
-(void)EaseIn;

//-(void)SetMenuNameBarText:(NSString*)text;
-(void)SetMenuNameBarWithMainText:(NSString*)text WithSubText:(NSString*)subText;
-(void)SetCatalogBarText:(NSString*)text;
-(void)ChangeBackgroundImage:(NSString*)fileName;


-(void)Reset;


@end
