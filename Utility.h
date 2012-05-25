//
//  Utility.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PackingCheckListAppDelegate;
@class ImportPhoto;
@class DropDownMenu;
@class HUDView;
@class PoolIcon;


@interface Utility : NSObject <UIAlertViewDelegate>{
	
	PackingCheckListAppDelegate *mDelegate;
	
	HUDView *m_HUD;
	
	BOOL m_ResetFlag;
	
	ImportPhoto *m_ImportPhotoFunction;
	
	DropDownMenu *m_CreateNewDropDwonMenu;
	DropDownMenu *m_ManageListDropDwonMenu;
	DropDownMenu *m_SortDropDwonMenu;
	
	NSString *m_Mode;
	NSString *m_SubMode;
	
	NSUInteger m_Index;
	
	PoolIcon *m_QuantityPoolIcon;

}

@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) ImportPhoto *m_ImportPhotoFunction;
@property (nonatomic, retain) DropDownMenu *m_CreateNewDropDwonMenu;
@property (nonatomic, retain) DropDownMenu *m_ManageListDropDwonMenu;
@property (nonatomic, retain) DropDownMenu *m_SortDropDwonMenu;
@property (nonatomic, retain) HUDView *m_HUD;
@property (nonatomic, retain) PoolIcon *m_QuantityPoolIcon;
@property NSUInteger m_Index;

-(id)InitUtility;
-(void)StartUtilityWithCommand:(NSString*)command WithObject:(id)object;
-(void)ClearDropDownMenu;
-(void)StartHUD;
-(void)KillHUD;


-(void)Reset;
-(void)CreateBlankPool:(NSString*)name;
-(void)MasterPool:(NSString*)name;
-(void)SamplePool:(NSString*)name;
-(void)CreateCustomPool:(NSArray*)nameList;
-(void)EditCustomPool:(NSString*)name;
-(void)Rename:(NSString*)previousName WithNewName:(NSString*)newName;
-(void)Copy:(NSString*)sourceName WithNewName:(NSString*)newName;
-(void)DeletePool:(NSString*)name;
-(void)SortPool;

-(void)LoadCustomPool:(NSString*)name;

@end
