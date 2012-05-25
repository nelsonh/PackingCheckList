//
//  WallpaperView.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingCheckListAppDelegate;

@interface WallpaperView : UIView {

	PackingCheckListAppDelegate *mDelegate;
	
	UIImageView *m_BackgroundImage;
	
	CGRect m_OriginRect;
	
	NSString *m_ImageFileName;
}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) UIImageView *m_BackgroundImage;
@property (nonatomic, retain) NSString *m_ImageFileName;

-(void)ZoomIn;
-(void)ZoomOut;

-(void)ChangeWallpaperSystem:(NSString*)fileName;
-(void)ChangeWallpaperCustomize:(UIImage*)mImage WithFileName:(NSString*)fileName;
-(void)RemoveWallpaperAnimation;
-(void)RemoveWallpaper;

@end
