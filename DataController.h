//
//  DataController.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//

#define CutsomizeWallpaperSubIndex 3
#define CutsomizeTaskSubIndex 4
#define CutsomizePackingSubIndex 11

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class PackingCheckListAppDelegate;
@class MenuPageView;
@class UserConfigDataPackage;


@interface DataController : NSObject {
	
	//point to data source
	PackingCheckListAppDelegate *mDelegate;
	
	//NSMutableArray *m_MenuRowContainer;
	
	//for item view only
	//this contain page of item view so item view can get these page back and attached to item view
	//NSMutableArray *m_ItemViewData;
	
	
	
	
	//-------------DB---------------//
	//database variables
	NSString *m_DatabaseName;
	NSString *m_DatabasePath;
	
	//an array contain a data structure
	NSMutableArray *m_PageViewData;
	
	//dictionary contain default icons string(name)
	NSMutableDictionary *m_DefaultIconsNameStringList;
	
	//dictionary contain customize icons string(name)
	NSMutableDictionary *m_CustomizeIconsNameStringList;
	
	//dictionary contain customize pool list string name
	NSMutableDictionary *m_CustomizePoolNameStringList;
	
	//array contain sample list string name
	NSMutableArray *m_SampleListNameStrinList;

}

@property (nonatomic, retain) NSMutableArray *m_PageViewData;
@property (nonatomic, retain) PackingCheckListAppDelegate *mDelegate;
@property (nonatomic, retain) NSMutableDictionary *m_CustomizePoolNameStringList;
@property (nonatomic, retain) NSMutableArray *m_SampleListNameStrinList;



//new
-(id)InitDataControllerWithDatabaseWithDelegate:(PackingCheckListAppDelegate*)delegate;
//new this method check if database is exist or not if exist then dont copy otherwise copy it to user's iphone
-(void)CopyDatabaseToIphone;
//new this method read data from database and then construct data structure
-(void)ConstructData;
-(void)LoadCustomizePhoto;
-(void)LoadCustomizeWallpaper;
-(void)LoadCustomizeTask;
-(void)LoadCustomizePacking;
-(void)LoadCustomizePool;
-(void)LoadSampleList;


//new
-(MenuPageView*)GetMenuPageViewByMenuIndex:(NSUInteger)menuIndex;
//new
-(NSMutableArray*)GetItemPageViewArrayByMenuIndex:(NSUInteger)menuIndex WithSubMenuIndex:(NSUInteger)subIndex;

-(BOOL)IsNameUsedBySystem:(NSString*)name;
-(BOOL)IsEnterNameExistInCustomizeList:(NSString*)name;
-(BOOL)IsPoolNameExist:(NSString*)name;

-(void)SaveCustomizeWallpaperToDatabase:(NSString*)imageName WithImage:(UIImage*)mImage;
-(void)SaveCustomizeTaskToDatabase:(NSString*)imageName WithImage:(UIImage*)mImage;  
-(void)SaveCustomizeItemToDatabase:(NSString*)imageName WithImage:(UIImage*)mImage;

-(void)DeleteCustomizeWallpaperFromDatabase:(NSString*)imageName;
-(void)DeleteCustomizeTaskFromDatabase:(NSString*)imageName;
-(void)DeleteCustomizeItemFromDatabase:(NSString*)imageName;
-(void)DeleteAllRows:(NSString*)tableName;

-(void)CreateNewPoolTable:(NSString*)name;

-(void)SaveIconDataToPoolTable:(NSString*)poolTableName WithIconName:(NSString*)iconName WithIconLableName:(NSString*)iconLableName 
				   WithTypeTag:(NSString*)typeTag WithQuantity:(NSUInteger)quantity;

-(void)DeleteIconDataFromPoolTable:(NSString*)poolTableName WithIconName:(NSString*)iconName;

-(NSMutableArray*)GetSampleList:(NSString*)tableName;

-(NSMutableArray*)GetCustomItemListWithTableName:(NSString*)tableName;

-(void)RenameCustomPoolTable:(NSString*)previousName WithNewName:(NSString*)newName;

-(void)DuplicatePoolTable:(NSString*)sourceName WithNewName:(NSString*)newName;

-(void)DeletePoolTable:(NSString*)tableName;

-(id)GetUserConfig;

-(BOOL)IsCustomWallpaper:(NSString*)wallpaperName;

-(void)SaveUserConfig:(UserConfigDataPackage*)dataPackage;

-(int)GetAppUsedTime;

-(void)UpdateAppUsedTime:(int)usedTime;

@end
