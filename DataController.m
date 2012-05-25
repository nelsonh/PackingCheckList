//
//  DataController.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataController.h"
#import "ItemPageView.h"
#import "ItemIcon.h"
#import "MenuData.h"
#import "CatalogData.h"
#import "MenuPageView.h"
#import "UserConfigDataPackage.h"
#import "LoadIconDataPackage.h"

static sqlite3 *database=nil;

@implementation DataController

@synthesize mDelegate;
@synthesize m_PageViewData;
@synthesize m_SampleListNameStrinList;
@synthesize m_CustomizePoolNameStringList;

/*
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}
*/



//new
-(id)InitDataControllerWithDatabaseWithDelegate:(PackingCheckListAppDelegate*)delegate
{
	if(self=[super init])
	{
		self.mDelegate=delegate;
		
		//init PageViewData
		m_PageViewData=[[NSMutableArray alloc] init];
		
		//init dictionary
		m_DefaultIconsNameStringList=[[NSMutableDictionary alloc] init];
		m_CustomizeIconsNameStringList=[[NSMutableDictionary alloc] init];
		self.m_CustomizePoolNameStringList=[[NSMutableDictionary alloc] init];
		self.m_SampleListNameStrinList=[[NSMutableArray alloc] init];
		
		m_DatabaseName=@"VTCDefaultDatabase.sqlite";
		NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDir=[documentPaths objectAtIndex:0];
		m_DatabasePath=[documentDir stringByAppendingPathComponent:m_DatabaseName];
		
		
		[self CopyDatabaseToIphone];
		
		
		
		[self ConstructData];
		
	}
	
	return self;
}
//new
-(void)CopyDatabaseToIphone
{
	BOOL success;
	
	NSFileManager *fileManager=[NSFileManager defaultManager];
	
	
	//uncomment this will remove previous database
	//[fileManager removeItemAtPath:m_DatabasePath error:nil];
	
	success=[fileManager fileExistsAtPath:m_DatabasePath];
	
	if(success)
	{
		//[fileManager release];
		return;
	}
		
	
	NSString *databaseFromApp=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:m_DatabaseName];
	
	
	if([fileManager copyItemAtPath:databaseFromApp toPath:m_DatabasePath error:nil])
	{
		NSLog(@"database copy successful");
	}
	else 
	{
		NSLog(@"database copy failed");
	}

	
	//[fileManager release];
}
//new
-(void)ConstructData
{
	//first open database
	if(sqlite3_open([m_DatabasePath UTF8String], &database)==SQLITE_OK)
	{
		//read level1 table
		NSString *sqlStatement=@"select * from ";
		NSString *command=[sqlStatement stringByAppendingString:@"L1_CatalogName"];
		
		sqlite3_stmt *compiledStatementLevel1;
		sqlite3_stmt *compiledStatementLevel2;
		sqlite3_stmt *compiledStatementLevel3;
		sqlite3_stmt *compiledStatementLevel4;
		sqlite3_stmt *compiledStatementLevel5;
		
		//sort index
		NSUInteger sortIndex=0;
		
		//check if statement is compiled successful
		if(sqlite3_prepare_v2(database, [command UTF8String], -1, &compiledStatementLevel1, NULL)==SQLITE_OK)
		{
			int menuPageCount=0;
			
			//run through each row in level1 table
			while(sqlite3_step(compiledStatementLevel1)==SQLITE_ROW)
			{
				
				//retrieve each attribute (level1 table has 2 coloumns)
				NSString *L1catalogName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementLevel1, 0)];
				NSString *L1link=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementLevel1, 1)];
				
				
				//retrieve level2 table by appending link
				command=[sqlStatement stringByAppendingString:L1link];
				
				if(sqlite3_prepare_v2(database, [command UTF8String], -1, &compiledStatementLevel2, NULL)==SQLITE_OK)
				{
					//before run through each row in level2 table we need to create a menu data instance
					MenuData *mMenuData=[[MenuData alloc] InitWithPageNum:menuPageCount WithPageName:L1catalogName WithDelegate:self.mDelegate];
					
					//add menu data to page view data array
					[m_PageViewData addObject:mMenuData];
					
					
					//run through each row in level2 table
					while(sqlite3_step(compiledStatementLevel2)==SQLITE_ROW)
					{
						
						//retrieve each attribute (level2 table has 2 coloumns)
						//NSString *L2name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel2, 0)];
						NSString *L2link=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel2, 1)];
						
						//retrieve level3 table by appending link
						command=[sqlStatement stringByAppendingString:L2link];
						
						if(sqlite3_prepare_v2(database, [command UTF8String], -1, &compiledStatementLevel3, NULL)==SQLITE_OK)
						{

							
							//run through each row in level3 table 
							while(sqlite3_step(compiledStatementLevel3)==SQLITE_ROW)
							{
								//retrieve each attribute (level3 table has 3 coloumns)
								NSString *L3name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel3, 0)];
								NSString *L3imageName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel3, 1)];
								NSString *L3link=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel3, 2)];
								
								//tell menu data to add a icon
								[mMenuData AddIconWithIconName:L3name WithFileName:L3imageName];
								
								//add to default dictionary
								[m_DefaultIconsNameStringList setValue:L3imageName forKey:L3name];
								
								 //retrieve level4 table by appending link
								command=[sqlStatement stringByAppendingString:L3link];
								
								if(sqlite3_prepare_v2(database, [command UTF8String], -1, &compiledStatementLevel4, NULL)==SQLITE_OK)
								{
									int itemPageCount=0;
									
									//before run through each row in level4 table we need to create a catalog data instance
									CatalogData *mCatalogData=[[CatalogData alloc] InitWithDelegate:self.mDelegate];
									
									//add catalog data to menu data's main catalog array
									[mMenuData AddCatalog:mCatalogData];
									
									//run through each row in level4 table
									while(sqlite3_step(compiledStatementLevel4)==SQLITE_ROW)
									{
										//retrieve each attribute (level4 table has 2 coloumns)
										NSString *L4name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel4, 0)];
										NSString *L4link=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel4, 1)];
										
										//retrieve level5 table by appending link
										command=[sqlStatement stringByAppendingString:L4link];
										
										if(sqlite3_prepare_v2(database, [command UTF8String], -1, &compiledStatementLevel5, NULL)==SQLITE_OK)
										{
											
											//before run through each row in level5 table we need to create a item page view
											ItemPageView *mItemPageView=[[ItemPageView alloc] InitWithPageNumber:itemPageCount WithPageName:L4name WithPageLableName:L3name 
																									WithDelegate:self.mDelegate];
											
											//add item page view to catalog data 
											[mCatalogData AddItemPageView:mItemPageView];
											
											//run through each row in level5 table
											while(sqlite3_step(compiledStatementLevel5)==SQLITE_ROW)
											{
												//retrieve each attribute (level5 table has 10 coloumns)
												NSString *L5name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 0)];
												NSString *L5lableName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 1)];
												
												BOOL L5draggable;
												NSUInteger draggable=sqlite3_column_int(compiledStatementLevel5, 2);
												if(draggable==1)
												{
													L5draggable=YES;
												}
												else 
												{
													L5draggable=NO;
												}
												
												NSString *L5dangerousTag=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 3)];
												
												BOOL L5visible;
												NSUInteger visible=sqlite3_column_int(compiledStatementLevel5, 4);
												if(visible==1)
												{
													L5visible=YES;
												}
												else 
												{
													L5visible=NO;
												}
												
												//NSUInteger L5sortIndex=sqlite3_column_int(compiledStatementLevel5, 5);
												
												NSString *L5typeTag=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 6)];
												
												BOOL L5behaviour;
												NSUInteger behaviour=sqlite3_column_int(compiledStatementLevel5, 7);
												if(behaviour==1)
												{
													L5behaviour=YES;
												}
												else 
												{
													L5behaviour=NO;
												}
												
												NSString *L5action=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 8)];
												
												NSString *L5imageName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 9)];
												
												//menu color
												NSString *L5menuColor=@"no";
												
												//background color
												UIColor *L5backgroundColor=nil;
												
												//wallpaper
												NSString *L5wallpaper=@"no";
												
												//theme set
												NSString *L5themeSet=@"no";
												
												//check what table we are reading data from by using link from level 4
												if([L4link compare:@"L5_Catalog0_Menu_Color"]==0)
												{
													//table is menu color
													//get value from database
													L5menuColor=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 10)];
												}
												else if([L4link compare:@"L5_Catalog0_Background"]==0)
												{
													CGFloat L5R=sqlite3_column_double(compiledStatementLevel5, 10)/255;
													CGFloat L5G=sqlite3_column_double(compiledStatementLevel5, 11)/255;
													CGFloat L5B=sqlite3_column_double(compiledStatementLevel5, 12)/255;
													
													L5backgroundColor=[[UIColor alloc] initWithRed:L5R green:L5G blue:L5B alpha:1.0f];
												}
												else if([L4link compare:@"L5_Catalog0_Wallpaper"]==0)
												{
													//table is wallpaper
													//get value from database
													L5wallpaper=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 10)];
												}
												else if([L4link compare:@"L5_Catalog0_Purpose"]==0)
												{
													//theme set
													L5themeSet=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 10)];
												}
												else if([L4link compare:@"L5_Catalog1_Season"]==0)
												{
													//theme set
													L5themeSet=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 10)];
												}
												else if([L4link compare:@"L5_Catalog2_Holiday"]==0)
												{
													//theme set
													L5themeSet=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 10)];
												}
												else if([L4link compare:@"L5_Catalog3_Activity"]==0)
												{
													//theme set
													L5themeSet=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 10)];
												}
												else if([L4link compare:@"L5_Catalog4_Miscellaneous"]==0)
												{
													//theme set
													L5themeSet=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 10)];
												}



												NSUInteger itemIndex=[[mItemPageView m_PageColumnContainer] count];
												
												//tell item page view to add a new icon
												[mItemPageView AddIconWithIconName:L5name WithLableName:L5lableName WithDraggable:L5draggable WithDangerousTag:L5dangerousTag 
																	   WithVisible:L5visible WithSortIndex:sortIndex WithTypeTag:L5typeTag WithBehaviour:L5behaviour 
																		WithAction:L5action WithImageName:L5imageName WithMenuColor:L5menuColor 
																		WithBackgroundColor:L5backgroundColor WithWallpaper:L5wallpaper 
																		WithThemeSet:L5themeSet WithCustomize:NO WithItemIconIndex:itemIndex];
												sortIndex++;
												
												if(L5backgroundColor!=nil)
												{
													[L5backgroundColor release];
												}
												
												//add to default dictionary
												[m_DefaultIconsNameStringList setValue:L5imageName forKey:L5name];
											}
											
											sqlite3_reset(compiledStatementLevel5);
											sqlite3_finalize(compiledStatementLevel5);
											
											
										}
										else 
										{
											NSLog(@"error crash at level5");
											NSLog(@"%@", command);
											
											sqlite3_reset(compiledStatementLevel1);
											sqlite3_finalize(compiledStatementLevel1);
											sqlite3_reset(compiledStatementLevel2);
											sqlite3_finalize(compiledStatementLevel2);
											sqlite3_reset(compiledStatementLevel3);
											sqlite3_finalize(compiledStatementLevel3);
											sqlite3_reset(compiledStatementLevel4);
											sqlite3_finalize(compiledStatementLevel4);
											sqlite3_reset(compiledStatementLevel5);
											sqlite3_finalize(compiledStatementLevel5);
											
											return;
										}
										
										itemPageCount++;
									}
									
									sqlite3_reset(compiledStatementLevel4);
									sqlite3_finalize(compiledStatementLevel4);
									
								}
								else
								{
									
									NSLog(@"error crash at level4");
									NSLog(@"%@", command);
									
									sqlite3_reset(compiledStatementLevel1);
									sqlite3_finalize(compiledStatementLevel1);
									sqlite3_reset(compiledStatementLevel2);
									sqlite3_finalize(compiledStatementLevel2);
									sqlite3_reset(compiledStatementLevel3);
									sqlite3_finalize(compiledStatementLevel3);
									sqlite3_reset(compiledStatementLevel4);
									sqlite3_finalize(compiledStatementLevel4);
									sqlite3_reset(compiledStatementLevel5);
									sqlite3_finalize(compiledStatementLevel5);
									
									return;
								}
								
							}
							
							sqlite3_reset(compiledStatementLevel3);
							sqlite3_finalize(compiledStatementLevel3);
							
							
						}
						else 
						{
							
							NSLog(@"error crash at level3");
							NSLog(@"%@", command);
							
							sqlite3_reset(compiledStatementLevel1);
							sqlite3_finalize(compiledStatementLevel1);
							sqlite3_reset(compiledStatementLevel2);
							sqlite3_finalize(compiledStatementLevel2);
							sqlite3_reset(compiledStatementLevel3);
							sqlite3_finalize(compiledStatementLevel3);
							sqlite3_reset(compiledStatementLevel4);
							sqlite3_finalize(compiledStatementLevel4);
							sqlite3_reset(compiledStatementLevel5);
							sqlite3_finalize(compiledStatementLevel5);
							
							return;
						}
					}
					
					[(MenuPageView*)[mMenuData m_MenuPageView] Finish];
					
					sqlite3_reset(compiledStatementLevel2);
					sqlite3_finalize(compiledStatementLevel2);
					
				}
				else 
				{
					
					NSLog(@"error crash at level2");
					NSLog(@"%@", command);
					
					sqlite3_reset(compiledStatementLevel1);
					sqlite3_finalize(compiledStatementLevel1);
					sqlite3_reset(compiledStatementLevel2);
					sqlite3_finalize(compiledStatementLevel2);
					sqlite3_reset(compiledStatementLevel3);
					sqlite3_finalize(compiledStatementLevel3);
					sqlite3_reset(compiledStatementLevel4);
					sqlite3_finalize(compiledStatementLevel4);
					sqlite3_reset(compiledStatementLevel5);
					sqlite3_finalize(compiledStatementLevel5);
					
					return;
				}
				
				menuPageCount++;

			}
			
			sqlite3_reset(compiledStatementLevel1);
			sqlite3_finalize(compiledStatementLevel1);
			
		}
		else 
		{
			
			NSLog(@"error crash at level1");
			NSLog(@"%@", command);
			
			sqlite3_reset(compiledStatementLevel1);
			sqlite3_finalize(compiledStatementLevel1);
			sqlite3_reset(compiledStatementLevel2);
			sqlite3_finalize(compiledStatementLevel2);
			sqlite3_reset(compiledStatementLevel3);
			sqlite3_finalize(compiledStatementLevel3);
			sqlite3_reset(compiledStatementLevel4);
			sqlite3_finalize(compiledStatementLevel4);
			sqlite3_reset(compiledStatementLevel5);
			sqlite3_finalize(compiledStatementLevel5);
			
			return;
		}
		
	}
	else 
	{
		NSLog(@"Open database failed");
	}
	
	[self LoadCustomizePhoto];
	
	//close database
	sqlite3_close(database);

}

-(void)LoadCustomizePhoto
{
	[self LoadCustomizeWallpaper];
	[self LoadCustomizeTask];
	[self LoadCustomizePacking];
	[self LoadCustomizePool];
	[self LoadSampleList];
}

-(void)LoadCustomizeWallpaper
{
	NSString *sqlStatement=@"select * from ";
	NSString *command=[sqlStatement stringByAppendingString:@"L5_Catalog1_Customize_Wallpaper"];
	
	sqlite3_stmt *compiledStatementLevel5;
	
	//retrieve setting menu data
	MenuData *settingMeneuData=[m_PageViewData objectAtIndex:0];
	
	//retrieve catalog data of wllpaper
	CatalogData *wllpaperCatalogData=[[settingMeneuData m_MainCatalogArray] objectAtIndex:3];
	
	if(sqlite3_prepare_v2(database, [command UTF8String], -1, &compiledStatementLevel5, NULL)==SQLITE_OK)
	{
		//create customize wllpaper page
		ItemPageView *mItemPageView=[[ItemPageView alloc] InitWithPageNumber:1 WithPageName:@"Custom Wallpaper" WithPageLableName:@"Custom Wallpaper" 
																WithDelegate:self.mDelegate];

		
		
		//add item page view to catalog data 
		[wllpaperCatalogData AddItemPageView:mItemPageView];
		
		//run through each row in level5 table
		while(sqlite3_step(compiledStatementLevel5)==SQLITE_ROW)
		{
			//retrieve each attribute (level5 table has 10 coloumns)
			NSString *L5name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 0)];
			NSString *L5lableName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 1)];
			
			BOOL L5draggable;
			NSUInteger draggable=sqlite3_column_int(compiledStatementLevel5, 2);
			if(draggable==1)
			{
				L5draggable=YES;
			}
			else 
			{
				L5draggable=NO;
			}
			
			NSString *L5dangerousTag=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 3)];
			
			BOOL L5visible;
			NSUInteger visible=sqlite3_column_int(compiledStatementLevel5, 4);
			if(visible==1)
			{
				L5visible=YES;
			}
			else 
			{
				L5visible=NO;
			}
			
			NSUInteger L5sortIndex=sqlite3_column_int(compiledStatementLevel5, 5);
			
			NSString *L5typeTag=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 6)];
			
			BOOL L5behaviour;
			NSUInteger behaviour=sqlite3_column_int(compiledStatementLevel5, 7);
			if(behaviour==1)
			{
				L5behaviour=YES;
			}
			else 
			{
				L5behaviour=NO;
			}
			
			NSString *L5action=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 8)];
			
			NSString *L5imageName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 9)];
			
			NSString *L5wallpaper=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 10)];
			
			
			//tell item page view to add a new icon
			[mItemPageView AddIconWithIconName:L5name WithLableName:L5lableName WithDraggable:L5draggable WithDangerousTag:L5dangerousTag 
								   WithVisible:L5visible WithSortIndex:L5sortIndex WithTypeTag:L5typeTag WithBehaviour:L5behaviour 
									WithAction:L5action WithImageName:L5imageName WithMenuColor:@"no" WithBackgroundColor:[UIColor clearColor] WithWallpaper:L5wallpaper 
								  WithThemeSet:@"no" 
								 WithCustomize:YES WithItemIconIndex:0];
			
			//add to default dictionary
			[m_CustomizeIconsNameStringList setValue:L5imageName forKey:L5name];
		}
		
	}
	else 
	{
		NSLog(@"error crash at level5 when loading customize wallpaper");
		NSLog(@"%@", command);
		
		sqlite3_reset(compiledStatementLevel5);
		sqlite3_finalize(compiledStatementLevel5);
		
		
		return;
	}


	sqlite3_reset(compiledStatementLevel5);
	sqlite3_finalize(compiledStatementLevel5);
	

	
	
}

-(void)LoadCustomizeTask
{
	NSString *sqlStatement=@"select * from ";
	NSString *command=[sqlStatement stringByAppendingString:@"L3_Customize_Task"];
	
	sqlite3_stmt *compiledStatementLevel3;
	sqlite3_stmt *compiledStatementLevel4;
	sqlite3_stmt *compiledStatementLevel5;
	
	//retrieve level3 table
	if(sqlite3_prepare_v2(database, [command UTF8String], -1, &compiledStatementLevel3, NULL)==SQLITE_OK)
	{
		while (sqlite3_step(compiledStatementLevel3)==SQLITE_ROW) 
		{
			//retrieve each attribute (level3 table has 3 coloumns)
			NSString *L3name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel3, 0)];
			NSString *L3imageName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel3, 1)];
			NSString *L3link=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel3, 2)];
			
			//retrieve task menu data
			MenuData *taskMenuData=[m_PageViewData objectAtIndex:1];
			//tell menu page view to add a customize task icon
			[(MenuPageView*)[taskMenuData m_MenuPageView] AddIconWithIconName:L3name WithImageFileName:L3imageName];
			
			//add to customize dictionary
			[m_CustomizeIconsNameStringList setValue:L3imageName forKey:L3name];
			
			//retrieve level4 table by appending link
			command=[sqlStatement stringByAppendingString:L3link];
			
			if(sqlite3_prepare_v2(database, [command UTF8String], -1, &compiledStatementLevel4, NULL)==SQLITE_OK)
			{
				int itemPageCount=0;
				
				//before run through each row in level4 table we need to create a catalog data instance
				CatalogData *mCatalogData=[[CatalogData alloc] InitWithDelegate:self.mDelegate];
				
				//add catalog data to menu data's main catalog array
				[taskMenuData AddCatalog:mCatalogData];
				
				//run through each row in level4 table
				while(sqlite3_step(compiledStatementLevel4)==SQLITE_ROW)
				{
					//retrieve each attribute (level4 table has 2 coloumns)
					NSString *L4name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel4, 0)];
					NSString *L4link=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel4, 1)];
					
					//retrieve level5 table by appending link
					command=[sqlStatement stringByAppendingString:L4link];
					
					if(sqlite3_prepare_v2(database, [command UTF8String], -1, &compiledStatementLevel5, NULL)==SQLITE_OK)
					{
						//before run through each row in level5 table we need to create a item page view
						ItemPageView *mItemPageView=[[ItemPageView alloc] InitWithPageNumber:itemPageCount WithPageName:L4name WithPageLableName:@"Custom Task" 
																				WithDelegate:self.mDelegate];

						
						//add item page view to catalog data 
						[mCatalogData AddItemPageView:mItemPageView];
						
						//run through each row in level5 table
						while(sqlite3_step(compiledStatementLevel5)==SQLITE_ROW)
						{
							//retrieve each attribute (level5 table has 10 coloumns)
							NSString *L5name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 0)];
							NSString *L5lableName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 1)];
							
							BOOL L5draggable;
							NSUInteger draggable=sqlite3_column_int(compiledStatementLevel5, 2);
							if(draggable==1)
							{
								L5draggable=YES;
							}
							else 
							{
								L5draggable=NO;
							}
							
							NSString *L5dangerousTag=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 3)];
							
							BOOL L5visible;
							NSUInteger visible=sqlite3_column_int(compiledStatementLevel5, 4);
							if(visible==1)
							{
								L5visible=YES;
							}
							else 
							{
								L5visible=NO;
							}
							
							NSUInteger L5sortIndex=sqlite3_column_int(compiledStatementLevel5, 5);
							
							NSString *L5typeTag=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 6)];
							
							BOOL L5behaviour;
							NSUInteger behaviour=sqlite3_column_int(compiledStatementLevel5, 7);
							if(behaviour==1)
							{
								L5behaviour=YES;
							}
							else 
							{
								L5behaviour=NO;
							}
							
							NSString *L5action=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 8)];
							
							NSString *L5imageName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 9)];
							
							
							//tell item page view to add a new icon
							[mItemPageView AddIconWithIconName:L5name WithLableName:L5lableName WithDraggable:L5draggable WithDangerousTag:L5dangerousTag 
												   WithVisible:L5visible WithSortIndex:L5sortIndex WithTypeTag:L5typeTag WithBehaviour:L5behaviour 
													WithAction:L5action WithImageName:L5imageName WithMenuColor:@"no" WithBackgroundColor:[UIColor clearColor] WithWallpaper:@"no" 
												 WithThemeSet:@"no" WithCustomize:YES WithItemIconIndex:0];
							
							//add to default dictionary
							[m_CustomizeIconsNameStringList setValue:L5imageName forKey:L5name];
						}
						
					}
					else 
					{
						NSLog(@"error crash at level5 when loading customize task");
						NSLog(@"%@", command);
						
						sqlite3_reset(compiledStatementLevel3);
						sqlite3_finalize(compiledStatementLevel3);
						
						sqlite3_reset(compiledStatementLevel4);
						sqlite3_finalize(compiledStatementLevel4);
						
						sqlite3_reset(compiledStatementLevel5);
						sqlite3_finalize(compiledStatementLevel5);
						
						
						return;
					}
				}
			}
			else 
			{
				NSLog(@"error crash at level4 when loading customize task");
				NSLog(@"%@", command);
				
				sqlite3_reset(compiledStatementLevel3);
				sqlite3_finalize(compiledStatementLevel3);
				
				sqlite3_reset(compiledStatementLevel4);
				sqlite3_finalize(compiledStatementLevel4);
				
				sqlite3_reset(compiledStatementLevel5);
				sqlite3_finalize(compiledStatementLevel5);
				
				return;
			}
			
			[(MenuPageView*)[taskMenuData m_MenuPageView] Finish];

		}
	}
	else 
	{
		NSLog(@"error crash at level3 when loading customize task");
		NSLog(@"%@", command);
		
		sqlite3_reset(compiledStatementLevel3);
		sqlite3_finalize(compiledStatementLevel3);
		
		sqlite3_reset(compiledStatementLevel4);
		sqlite3_finalize(compiledStatementLevel4);
		
		sqlite3_reset(compiledStatementLevel5);
		sqlite3_finalize(compiledStatementLevel5);
		
		return;
	}
	
	sqlite3_reset(compiledStatementLevel3);
	sqlite3_finalize(compiledStatementLevel3);
	
	sqlite3_reset(compiledStatementLevel4);
	sqlite3_finalize(compiledStatementLevel4);
	
	sqlite3_reset(compiledStatementLevel5);
	sqlite3_finalize(compiledStatementLevel5);

}

-(void)LoadCustomizePacking
{
	NSString *sqlStatement=@"select * from ";
	NSString *command=[sqlStatement stringByAppendingString:@"L3_Customize_Packing"];
	
	sqlite3_stmt *compiledStatementLevel3;
	sqlite3_stmt *compiledStatementLevel4;
	sqlite3_stmt *compiledStatementLevel5;
	
	//retrieve level3 table
	if(sqlite3_prepare_v2(database, [command UTF8String], -1, &compiledStatementLevel3, NULL)==SQLITE_OK)
	{
		while (sqlite3_step(compiledStatementLevel3)==SQLITE_ROW) 
		{
			//retrieve each attribute (level3 table has 3 coloumns)
			NSString *L3name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel3, 0)];
			NSString *L3imageName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel3, 1)];
			NSString *L3link=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel3, 2)];
			
			//retrieve packing menu data
			MenuData *packingMenuData=[m_PageViewData objectAtIndex:2];
			//tell menu page view to add a customize packing icon
			[(MenuPageView*)[packingMenuData m_MenuPageView] AddIconWithIconName:L3name WithImageFileName:L3imageName];
			
			//add to customize dictionary
			[m_CustomizeIconsNameStringList setValue:L3imageName forKey:L3name];
			
			//retrieve level4 table by appending link
			command=[sqlStatement stringByAppendingString:L3link];
			
			if(sqlite3_prepare_v2(database, [command UTF8String], -1, &compiledStatementLevel4, NULL)==SQLITE_OK)
			{
				int itemPageCount=0;
				
				//before run through each row in level4 table we need to create a catalog data instance
				CatalogData *mCatalogData=[[CatalogData alloc] InitWithDelegate:self.mDelegate];
				
				//add catalog data to menu data's main catalog array
				[packingMenuData AddCatalog:mCatalogData];
				
				//run through each row in level4 table
				while(sqlite3_step(compiledStatementLevel4)==SQLITE_ROW)
				{
					//retrieve each attribute (level4 table has 2 coloumns)
					NSString *L4name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel4, 0)];
					NSString *L4link=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel4, 1)];
					
					//retrieve level5 table by appending link
					command=[sqlStatement stringByAppendingString:L4link];
					
					if(sqlite3_prepare_v2(database, [command UTF8String], -1, &compiledStatementLevel5, NULL)==SQLITE_OK)
					{
						//before run through each row in level5 table we need to create a item page view
						ItemPageView *mItemPageView=[[ItemPageView alloc] InitWithPageNumber:itemPageCount WithPageName:L4name WithPageLableName:@"Custom Item" 
																				WithDelegate:self.mDelegate];
						[mItemPageView setMDelegate:self.mDelegate];
						
						
						//add item page view to catalog data 
						[mCatalogData AddItemPageView:mItemPageView];
						
						//run through each row in level5 table
						while(sqlite3_step(compiledStatementLevel5)==SQLITE_ROW)
						{
							//retrieve each attribute (level5 table has 10 coloumns)
							NSString *L5name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 0)];
							NSString *L5lableName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 1)];
							
							BOOL L5draggable;
							NSUInteger draggable=sqlite3_column_int(compiledStatementLevel5, 2);
							if(draggable==1)
							{
								L5draggable=YES;
							}
							else 
							{
								L5draggable=NO;
							}
							
							NSString *L5dangerousTag=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 3)];
							
							BOOL L5visible;
							NSUInteger visible=sqlite3_column_int(compiledStatementLevel5, 4);
							if(visible==1)
							{
								L5visible=YES;
							}
							else 
							{
								L5visible=NO;
							}
							
							NSUInteger L5sortIndex=sqlite3_column_int(compiledStatementLevel5, 5);
							
							NSString *L5typeTag=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 6)];
							
							BOOL L5behaviour;
							NSUInteger behaviour=sqlite3_column_int(compiledStatementLevel5, 7);
							if(behaviour==1)
							{
								L5behaviour=YES;
							}
							else 
							{
								L5behaviour=NO;
							}
							
							NSString *L5action=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 8)];
							
							NSString *L5imageName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatementLevel5, 9)];
							
							
							//tell item page view to add a new icon
							[mItemPageView AddIconWithIconName:L5name WithLableName:L5lableName WithDraggable:L5draggable WithDangerousTag:L5dangerousTag 
												   WithVisible:L5visible WithSortIndex:L5sortIndex WithTypeTag:L5typeTag WithBehaviour:L5behaviour 
													WithAction:L5action WithImageName:L5imageName WithMenuColor:@"no" WithBackgroundColor:[UIColor clearColor] WithWallpaper:@"no" 
												 WithThemeSet:@"no" WithCustomize:YES WithItemIconIndex:0];
							
							//add to default dictionary
							[m_CustomizeIconsNameStringList setValue:L5imageName forKey:L5name];
						}
						
					}
					else 
					{
						NSLog(@"error crash at level5 when loading customize task");
						NSLog(@"%@", command);
						
						sqlite3_reset(compiledStatementLevel3);
						sqlite3_finalize(compiledStatementLevel3);
						
						sqlite3_reset(compiledStatementLevel4);
						sqlite3_finalize(compiledStatementLevel4);
						
						sqlite3_reset(compiledStatementLevel5);
						sqlite3_finalize(compiledStatementLevel5);
						
						NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
						
						return;
					}
				}
			}
			else 
			{
				NSLog(@"error crash at level4 when loading customize task");
				NSLog(@"%@", command);
				
				sqlite3_reset(compiledStatementLevel3);
				sqlite3_finalize(compiledStatementLevel3);
				
				sqlite3_reset(compiledStatementLevel4);
				sqlite3_finalize(compiledStatementLevel4);
				
				sqlite3_reset(compiledStatementLevel5);
				sqlite3_finalize(compiledStatementLevel5);
				
				NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
				
				return;
			}
			
			[(MenuPageView*)[packingMenuData m_MenuPageView] Finish];
		}
	}
	else 
	{
		NSLog(@"error crash at level3 when loading customize task");
		NSLog(@"%@", command);
		
		sqlite3_reset(compiledStatementLevel3);
		sqlite3_finalize(compiledStatementLevel3);
		
		sqlite3_reset(compiledStatementLevel4);
		sqlite3_finalize(compiledStatementLevel4);
		
		sqlite3_reset(compiledStatementLevel5);
		sqlite3_finalize(compiledStatementLevel5);
		
		NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
		
		return;
	}
	
	sqlite3_reset(compiledStatementLevel3);
	sqlite3_finalize(compiledStatementLevel3);
	
	sqlite3_reset(compiledStatementLevel4);
	sqlite3_finalize(compiledStatementLevel4);
	
	sqlite3_reset(compiledStatementLevel5);
	sqlite3_finalize(compiledStatementLevel5);
	
}

-(void)LoadCustomizePool
{
	NSString *sqlStatement=@"select * from ";
	NSString *command=[sqlStatement stringByAppendingString:@"Customize_Pool"];
	
	sqlite3_stmt *compiledStatement;
	
	if(sqlite3_prepare_v2(database, [command UTF8String], -1, &compiledStatement, NULL)==SQLITE_OK)
	{
		while (sqlite3_step(compiledStatement)==SQLITE_ROW)
		{
			NSString *Poolname=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 0)];
			NSString *Poollink=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 1)];
			
			NSLog(@"table:%@",Poolname);
			
			[m_CustomizePoolNameStringList setValue:Poollink forKey:Poolname];
		}
	}
	else 
	{
		NSLog(@"error when loading customize pool");
		NSLog(@"%@", command);
		sqlite3_reset(compiledStatement);
		sqlite3_finalize(compiledStatement);
		
		NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
		return;
	}
	
	sqlite3_reset(compiledStatement);
	sqlite3_finalize(compiledStatement);
	
}



-(void)LoadSampleList
{
	NSString *sqlStatement=@"select * from ";
	NSString *command=[sqlStatement stringByAppendingString:@"Sample_List"];
	
	sqlite3_stmt *compiledStatement;
	
	if(sqlite3_prepare_v2(database, [command UTF8String], -1, &compiledStatement, NULL)==SQLITE_OK)
	{
		while (sqlite3_step(compiledStatement)==SQLITE_ROW)
		{
			NSString *SampleName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 0)];
			
			[m_SampleListNameStrinList addObject:SampleName];
		}
	}
	else 
	{
		NSLog(@"error when loading customize pool");
		NSLog(@"%@", command);
		
		sqlite3_reset(compiledStatement);
		sqlite3_finalize(compiledStatement);
		
		NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
		return;
	}
	
	sqlite3_reset(compiledStatement);
	sqlite3_finalize(compiledStatement);
	
}

//new
-(MenuPageView*)GetMenuPageViewByMenuIndex:(NSUInteger)menuIndex
{
	if(menuIndex>[m_PageViewData count]-1 || menuIndex<0)
	{
		return nil;
	}
	else 
	{
		if([m_PageViewData count]!=0)
		{
			MenuData *mMenuData=[m_PageViewData objectAtIndex:menuIndex];
			return [mMenuData m_MenuPageView];
		}
		else 
		{
			return nil;
		}
		
	}
}
//new
-(NSMutableArray*)GetItemPageViewArrayByMenuIndex:(NSUInteger)menuIndex WithSubMenuIndex:(NSUInteger)subIndex
{
	if(menuIndex>[m_PageViewData count]-1 || menuIndex<0)
	{
		return nil;
	}
	else if(subIndex>[[(MenuData*)[m_PageViewData objectAtIndex:menuIndex] m_MainCatalogArray] count]-1 || subIndex<0)
	{
		return nil;
	}
	else 
	{
		if([m_PageViewData count]!=0 && [[(MenuData*)[m_PageViewData objectAtIndex:menuIndex] m_MainCatalogArray] count]!=0)
		{
			CatalogData *mCatalogData=(CatalogData*)[[(MenuData*)[m_PageViewData objectAtIndex:menuIndex] m_MainCatalogArray] objectAtIndex:subIndex];
			return [mCatalogData m_ItemPageViewArray];
		}
		else 
		{
			return nil;
		}
	}
}

-(BOOL)IsNameUsedBySystem:(NSString*)name
{
	if([m_DefaultIconsNameStringList valueForKey:name]!=nil)
	{
		return YES;
	}
	else 
	{
		return NO;
	}

}

-(BOOL)IsEnterNameExistInCustomizeList:(NSString*)name
{
	if([m_CustomizeIconsNameStringList valueForKey:name]!=nil)
	{
		return YES;
	}
	else 
	{
		return NO;
	}

}

-(BOOL)IsPoolNameExist:(NSString*)name
{
	for(int i=0; i<[m_SampleListNameStrinList count]; i++)
	{
		NSString *listName=[m_SampleListNameStrinList objectAtIndex:i];
		if([listName compare:name]==0)
		{
			return YES;
		}
	}
	
	if([m_CustomizePoolNameStringList valueForKey:name]!=nil)
	{
		return YES;
	}
	else 
	{
		return NO;
	}

}

-(void)SaveCustomizeWallpaperToDatabase:(NSString*)imageName WithImage:(UIImage*)mImage
{
	//convert image to NSData type
	NSData *imageData=UIImagePNGRepresentation(mImage);
	
	
	NSFileManager *fileManager=[NSFileManager defaultManager];
	
	NSString *dangerousTag=[NSString stringWithString:@"no"];
	NSString *typeTag=[NSString stringWithString:@"item"];
	NSString *action=[NSString stringWithString:@"changewallpaper"];
	NSString *imageFileName=[imageName stringByAppendingString:@".png"];
	NSString *wallpaper=[NSString stringWithString:@"customize"];

	
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *imagePath=[documentDir stringByAppendingPathComponent:[imageName stringByAppendingString:@".png"]];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	
	
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		NSString *sqlStatement=@"insert into L5_Catalog1_Customize_Wallpaper(Name, LableName, Draggable, DangerousTag, Visible, SortIndex, TypeTag, Behaviour, Action, ImageName, Wallpaper) Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
		sqlite3_stmt *addStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &addStatement, NULL)==SQLITE_OK)
		{
			sqlite3_bind_text(addStatement, 1, [imageName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 2, [imageName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(addStatement, 3, 0);
			sqlite3_bind_text(addStatement, 4, [dangerousTag UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(addStatement, 5, 1);
			sqlite3_bind_int(addStatement, 6, 0);
			sqlite3_bind_text(addStatement, 7, [typeTag UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(addStatement, 8, 1);
			sqlite3_bind_text(addStatement, 9, [action UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 10, [imageFileName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 11, [wallpaper UTF8String], -1, SQLITE_TRANSIENT);
		}
		else 
		{
			NSLog(@"save to wallpapaer sql statement faild");
			sqlite3_finalize(addStatement);
			sqlite3_reset(addStatement);
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			//[fileManager release];
			sqlite3_close(database);
			return;
		}
		
		if(SQLITE_DONE != sqlite3_step(addStatement))
		{
			//row exist update it
			
			sqlStatement=@"update L5_Catalog1_Customize_Wallpaper Set Name = ?, LableName = ?, Draggable = ?, DangerousTag = ?, Visible = ?,  SortIndex = ?, TypeTag = ?, Behaviour = ?, Action =?, ImageName = ?, Wallpaper = ? Where Name = ?";
			sqlite3_stmt *updateStatement;
			
			if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &updateStatement, NULL)==SQLITE_OK)
			{
				sqlite3_bind_text(updateStatement, 1, [imageName UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(updateStatement, 2, [imageName UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(updateStatement, 3, 0);
				sqlite3_bind_text(updateStatement, 4, [dangerousTag UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(updateStatement, 5, 1);
				sqlite3_bind_int(updateStatement, 6, 0);
				sqlite3_bind_text(updateStatement, 7, [typeTag UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(updateStatement, 8, 1);
				sqlite3_bind_text(updateStatement, 9, [action UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(updateStatement, 10, [imageFileName UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(updateStatement, 11, [wallpaper UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(updateStatement, 1, [imageName UTF8String], -1, SQLITE_TRANSIENT);
			}
			
			//check if need to update or add new one
			if(SQLITE_DONE != sqlite3_step(updateStatement))
			{
				NSLog(@"update failed");
				
				sqlite3_reset(updateStatement);
				sqlite3_finalize(updateStatement);
				
				NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
				sqlite3_close(database);
				return;
			}
			
			sqlite3_reset(updateStatement);
			sqlite3_finalize(updateStatement);
			

			
			sqlite3_close(database);
		}
		else 
		{
			sqlite3_last_insert_rowid(database);
			
			sqlite3_reset(addStatement);
			sqlite3_finalize(addStatement);
			
			
			sqlite3_close(database);
			
			NSLog(@"save to wallpaper database data successful");
			
		}
		
	}
	else 
	{
		NSLog(@"save to wallpaper open database failed");
		//[fileManager release];
		return;
	}
	
	
	
	//check if file need to be replaced
	if([fileManager fileExistsAtPath:imagePath])
	{
		//delete previous image
		[fileManager removeItemAtPath:imagePath error:nil];
		
		//save new one to device
		[imageData writeToFile:imagePath atomically:NO];
		
		NSLog(@"image data replaced successful");
	}
	else 
	{
		//save new one to device
		if([imageData writeToFile:imagePath atomically:NO])
		{
			NSLog(@"image data save successful");
		}
		else 
		{
			NSLog(@"image data save failed");
		}
	}
	
	//[fileManager release];
	
	//add to custiomize dictionary
	[m_CustomizeIconsNameStringList setValue:[imageName stringByAppendingString:@".png"] forKey:imageName];

}

-(void)SaveCustomizeTaskToDatabase:(NSString*)imageName WithImage:(UIImage*)mImage;  
{
	//convert image to NSData type
	NSData *imageData=UIImagePNGRepresentation(mImage);
	
	NSString *dangerousTag=[NSString stringWithString:@"no"];
	NSString *typeTag=[NSString stringWithString:@"task"];
	NSString *action=[NSString stringWithString:@"no action"];
	NSString *imageFileName=[imageName stringByAppendingString:@".png"];
	
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *imagePath=[documentDir stringByAppendingPathComponent:[imageName stringByAppendingString:@".png"]];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	
	NSFileManager *fileManager=[NSFileManager defaultManager];
	
	
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		NSString *sqlStatement=@"insert into L5_Catalog0_Customize_Task(Name, LableName, Draggable, DangerousTag, Visible, SortIndex, TypeTag, Behaviour, Action, ImageName) Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
		sqlite3_stmt *addStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &addStatement, NULL)==SQLITE_OK)
		{
			sqlite3_bind_text(addStatement, 1, [imageName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 2, [imageName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(addStatement, 3, 1);
			sqlite3_bind_text(addStatement, 4, [dangerousTag UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(addStatement, 5, 1);
			sqlite3_bind_int(addStatement, 6, 0);
			sqlite3_bind_text(addStatement, 7, [typeTag UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(addStatement, 8, 0);
			sqlite3_bind_text(addStatement, 9, [action UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 10, [imageFileName UTF8String], -1, SQLITE_TRANSIENT);
		}
		else 
		{
			NSLog(@"save to wallpapaer sql statement faild");
			
			sqlite3_reset(addStatement);
			sqlite3_finalize(addStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			//[fileManager release];
			sqlite3_close(database);
			return;
		}
		
		if(SQLITE_DONE != sqlite3_step(addStatement))
		{
			//row exist update it
			
			sqlStatement=@"update L5_Catalog0_Customize_Task Set Name = ?, LableName = ?, Draggable = ?, DangerousTag = ?, Visible = ?,  SortIndex = ?, TypeTag = ?, Behaviour = ?, Action =?, ImageName = ? Where Name = ?";
			sqlite3_stmt *updateStatement;
			
			if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &updateStatement, NULL)==SQLITE_OK)
			{
				sqlite3_bind_text(updateStatement, 1, [imageName UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(updateStatement, 2, [imageName UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(updateStatement, 3, 1);
				sqlite3_bind_text(updateStatement, 4, [dangerousTag UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(updateStatement, 5, 1);
				sqlite3_bind_int(updateStatement, 6, 0);
				sqlite3_bind_text(updateStatement, 7, [typeTag UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(updateStatement, 8, 0);
				sqlite3_bind_text(updateStatement, 9, [action UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(updateStatement, 10, [imageFileName UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(updateStatement, 1, [imageName UTF8String], -1, SQLITE_TRANSIENT);
			}
			
			//check if need to update or add new one
			if(SQLITE_DONE != sqlite3_step(updateStatement))
			{
				NSLog(@"update failed");
				
				sqlite3_reset(updateStatement);
				sqlite3_finalize(updateStatement);
				
				NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
				sqlite3_close(database);
				return;
			}
			
			sqlite3_reset(updateStatement);
			sqlite3_finalize(updateStatement);
			
			
			sqlite3_close(database);
		}
		else 
		{
			sqlite3_last_insert_rowid(database);
			
			sqlite3_reset(addStatement);
			sqlite3_finalize(addStatement);
			
			
			sqlite3_close(database);
			
			NSLog(@"save to task database data successful");
			
		}
		
	}
	else 
	{
		NSLog(@"save to task open database failed");
		//[fileManager release];
		return;
	}
	
	 
	//check if file need to be replaced
	if([fileManager fileExistsAtPath:imagePath])
	{
		//delete previous image
		[fileManager removeItemAtPath:imagePath error:nil];
		
		//save new one to device
		[imageData writeToFile:imagePath atomically:NO];
		
		NSLog(@"image data replaced successful");
	}
	else 
	{
		//save new one to device
		if([imageData writeToFile:imagePath atomically:NO])
		{
			NSLog(@"image data save successful");
		}
		else 
		{
			NSLog(@"image data save failed");
		}
	}
	
	//[fileManager release];
	 
	
	//add to custiomize dictionary
	[m_CustomizeIconsNameStringList setValue:[imageName stringByAppendingString:@".png"] forKey:imageName];
}

-(void)SaveCustomizeItemToDatabase:(NSString*)imageName WithImage:(UIImage*)mImage;
{
	//convert image to NSData type
	NSData *imageData=UIImagePNGRepresentation(mImage);
	
	NSString *dangerousTag=[NSString stringWithString:@"no"];
	NSString *typeTag=[NSString stringWithString:@"item"];
	NSString *action=[NSString stringWithString:@"no action"];
	NSString *imageFileName=[imageName stringByAppendingString:@".png"];
	
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *imagePath=[documentDir stringByAppendingPathComponent:[imageName stringByAppendingString:@".png"]];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	
	NSFileManager *fileManager=[NSFileManager defaultManager];
	
	
	
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		NSString *sqlStatement=@"insert into L5_Catalog0_Customize_Packing(Name, LableName, Draggable, DangerousTag, Visible, SortIndex, TypeTag, Behaviour, Action, ImageName) Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
		sqlite3_stmt *addStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &addStatement, NULL)==SQLITE_OK)
		{
			sqlite3_bind_text(addStatement, 1, [imageName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 2, [imageName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(addStatement, 3, 1);
			sqlite3_bind_text(addStatement, 4, [dangerousTag UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(addStatement, 5, 1);
			sqlite3_bind_int(addStatement, 6, 0);
			sqlite3_bind_text(addStatement, 7, [typeTag UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(addStatement, 8, 0);
			sqlite3_bind_text(addStatement, 9, [action UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 10, [imageFileName UTF8String], -1, SQLITE_TRANSIENT);
		}
		else 
		{
			NSLog(@"save to wallpapaer sql statement faild");
			
			sqlite3_reset(addStatement);
			sqlite3_finalize(addStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			//[fileManager release];
			sqlite3_close(database);
			return;
		}
		
		if(SQLITE_DONE != sqlite3_step(addStatement))
		{
			//row exist update it
			
			sqlStatement=@"update L5_Catalog0_Customize_Packing Set Name = ?, LableName = ?, Draggable = ?, DangerousTag = ?, Visible = ?,  SortIndex = ?, TypeTag = ?, Behaviour = ?, Action =?, ImageName = ? Where Name = ?";
			sqlite3_stmt *updateStatement;
			
			if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &updateStatement, NULL)==SQLITE_OK)
			{
				sqlite3_bind_text(updateStatement, 1, [imageName UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(updateStatement, 2, [imageName UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(updateStatement, 3, 1);
				sqlite3_bind_text(updateStatement, 4, [dangerousTag UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(updateStatement, 5, 1);
				sqlite3_bind_int(updateStatement, 6, 0);
				sqlite3_bind_text(updateStatement, 7, [typeTag UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(updateStatement, 8, 0);
				sqlite3_bind_text(updateStatement, 9, [action UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(updateStatement, 10, [imageFileName UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(updateStatement, 1, [imageName UTF8String], -1, SQLITE_TRANSIENT);
			}
			
			//check if need to update or add new one
			if(SQLITE_DONE != sqlite3_step(updateStatement))
			{
				NSLog(@"update failed");
				
				sqlite3_reset(updateStatement);
				sqlite3_finalize(updateStatement);
				
				NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
				sqlite3_close(database);
				return;
			}
			
			sqlite3_reset(updateStatement);
			sqlite3_finalize(updateStatement);
			
			
			sqlite3_close(database);
		}
		else 
		{
			sqlite3_last_insert_rowid(database);
			
			sqlite3_reset(addStatement);
			sqlite3_finalize(addStatement);
			
			
			
			sqlite3_close(database);
			
			NSLog(@"save to task database data successful");
			
		}

	}
	else 
	{
		NSLog(@"save to task open database failed");
		//[fileManager release];
		return;
	}
	
	
	
	//check if file need to be replaced
	if([fileManager fileExistsAtPath:imagePath])
	{
		//delete previous image
		[fileManager removeItemAtPath:imagePath error:nil];
		
		//save new one to device
		[imageData writeToFile:imagePath atomically:NO];
		
		NSLog(@"image data replaced successful");
	}
	else 
	{
		//save new one to device
		if([imageData writeToFile:imagePath atomically:NO])
		{
			NSLog(@"image data save successful");
		}
		else 
		{
			NSLog(@"image data save failed");
		}
	}
	
	//[fileManager release];
	
	
	//add to custiomize dictionary
	[m_CustomizeIconsNameStringList setValue:[imageName stringByAppendingString:@".png"] forKey:imageName];

}

-(void)DeleteCustomizeWallpaperFromDatabase:(NSString*)imageName
{
	//first remove data from database

	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		//delete data from data base
		NSString *sqlStatement=@"delete from L5_Catalog1_Customize_Wallpaper where Name = ?";
		sqlite3_stmt *deleteStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &deleteStatement, NULL)==SQLITE_OK)
		{
			sqlite3_bind_text(deleteStatement, 1, [imageName UTF8String], -1, SQLITE_TRANSIENT);
		}
		else 
		{
			NSLog(@"delete data statement failed");
			
			sqlite3_reset(deleteStatement);
			sqlite3_finalize(deleteStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}

		
		if (SQLITE_DONE != sqlite3_step(deleteStatement))
		{
			NSLog(@"failed to delete data from database");
			
			sqlite3_reset(deleteStatement);
			sqlite3_finalize(deleteStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		sqlite3_reset(deleteStatement);
		sqlite3_finalize(deleteStatement);
		
		
		NSLog(@"delete data from database successful");
	}
	else 
	{
		NSLog(@"delete data wallpaper open database failed");
		return;
	}
	sqlite3_close(database);
	
	//check if the image data is referenced by other
	ItemPageView *taskCustomizePageView=[[self GetItemPageViewArrayByMenuIndex:1 WithSubMenuIndex:CutsomizeTaskSubIndex] objectAtIndex:0];
	ItemPageView *packingCustomizePageView=[[self GetItemPageViewArrayByMenuIndex:2 WithSubMenuIndex:CutsomizePackingSubIndex] objectAtIndex:0];
	
	if([taskCustomizePageView HasSameIconWithName:imageName] || [packingCustomizePageView HasSameIconWithName:imageName])
	{
		//the image has been referenced by other dont delete
		NSLog(@"image has been referenced can't not be deleted");
		return;
	}
	else 
	{
		//no one reference to the image delete it
		NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDir=[documentPaths objectAtIndex:0];
		NSString *imagePath=[documentDir stringByAppendingPathComponent:[imageName stringByAppendingString:@".png"]];
		
		NSFileManager *fileManager=[NSFileManager defaultManager];
		
		if([fileManager fileExistsAtPath:imagePath])
		{
			[fileManager removeItemAtPath:imagePath error:nil];
			
			//also remove the name form dictionary
			[m_CustomizeIconsNameStringList removeObjectForKey:imageName];
			
			
			NSLog(@"delete image successful");
		}
		else 
		{
			
			NSLog(@"delete image failed wallpaper");
		}
		
		//[fileManager release];
	}

}

-(void)DeleteCustomizeTaskFromDatabase:(NSString*)imageName
{
	//first remove data from database
	
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		//delete data from data base
		NSString *sqlStatement=@"delete from L5_Catalog0_Customize_Task where Name = ?";
		sqlite3_stmt *deleteStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &deleteStatement, NULL)==SQLITE_OK)
		{
			sqlite3_bind_text(deleteStatement, 1, [imageName UTF8String], -1, SQLITE_TRANSIENT);
		}
		else 
		{
			NSLog(@"delete data statement failed");
			
			sqlite3_reset(deleteStatement);
			sqlite3_finalize(deleteStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		
		if (SQLITE_DONE != sqlite3_step(deleteStatement))
		{
			NSLog(@"failed to delete data from database");
			
			sqlite3_reset(deleteStatement);
			sqlite3_finalize(deleteStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		sqlite3_reset(deleteStatement);
		sqlite3_finalize(deleteStatement);
		

		
		NSLog(@"delete data from database successful");
	}
	else 
	{
		NSLog(@"delete data wallpaper open database failed");
		return;
	}
	sqlite3_close(database);
	
	//check if the image data is referenced by other
	ItemPageView *wallpaperCustomizePageView=[[self GetItemPageViewArrayByMenuIndex:0 WithSubMenuIndex:CutsomizeWallpaperSubIndex] objectAtIndex:1];
	ItemPageView *packingCustomizePageView=[[self GetItemPageViewArrayByMenuIndex:2 WithSubMenuIndex:CutsomizePackingSubIndex] objectAtIndex:0];
	
	if([wallpaperCustomizePageView HasSameIconWithName:imageName] || [packingCustomizePageView HasSameIconWithName:imageName])
	{
		//the image has been referenced by other dont delete
		NSLog(@"image has been referenced can't not be deleted");
		return;
	}
	else 
	{
		//no one reference to the image delete it
		NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDir=[documentPaths objectAtIndex:0];
		NSString *imagePath=[documentDir stringByAppendingPathComponent:[imageName stringByAppendingString:@".png"]];
		
		NSFileManager *fileManager=[NSFileManager defaultManager];
		
		if([fileManager fileExistsAtPath:imagePath])
		{
			[fileManager removeItemAtPath:imagePath error:nil];
			
			//also remove the name form dictionary
			[m_CustomizeIconsNameStringList removeObjectForKey:imageName];
			

			NSLog(@"delete image successful");
		}
		else 
		{
			
			NSLog(@"delete image failed task");
		}
		
		//[fileManager release];
	}
	
}

-(void)DeleteCustomizeItemFromDatabase:(NSString*)imageName
{
	//first remove data from database
	
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		//delete data from data base
		NSString *sqlStatement=@"delete from L5_Catalog0_Customize_Packing where Name = ?";
		sqlite3_stmt *deleteStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &deleteStatement, NULL)==SQLITE_OK)
		{
			sqlite3_bind_text(deleteStatement, 1, [imageName UTF8String], -1, SQLITE_TRANSIENT);
		}
		else 
		{
			NSLog(@"delete data statement failed");
			
			sqlite3_reset(deleteStatement);
			sqlite3_finalize(deleteStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		
		if (SQLITE_DONE != sqlite3_step(deleteStatement))
		{
			NSLog(@"failed to delete data from database");
			
			sqlite3_reset(deleteStatement);
			sqlite3_finalize(deleteStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		sqlite3_reset(deleteStatement);
		sqlite3_finalize(deleteStatement);
		
		
		
		NSLog(@"delete data from database successful");
	}
	else 
	{
		NSLog(@"delete data wallpaper open database failed");
		return;
	}
	
	sqlite3_close(database);
	
	
	//check if the image data is referenced by other
	ItemPageView *wallpaperCustomizePageView=[[self GetItemPageViewArrayByMenuIndex:0 WithSubMenuIndex:CutsomizeWallpaperSubIndex] objectAtIndex:1];
	ItemPageView *taskCustomizePageView=[[self GetItemPageViewArrayByMenuIndex:1 WithSubMenuIndex:CutsomizeTaskSubIndex] objectAtIndex:0];
	
	if([wallpaperCustomizePageView HasSameIconWithName:imageName] || [taskCustomizePageView HasSameIconWithName:imageName])
	{
		//the image has been referenced by other dont delete
		NSLog(@"image has been referenced can't not be deleted");
		return;
	}
	else 
	{
		//no one reference to the image delete it
		NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDir=[documentPaths objectAtIndex:0];
		NSString *imagePath=[documentDir stringByAppendingPathComponent:[imageName stringByAppendingString:@".png"]];
		
		NSFileManager *fileManager=[NSFileManager defaultManager];
		
		if([fileManager fileExistsAtPath:imagePath])
		{
			[fileManager removeItemAtPath:imagePath error:nil];
			
			//also remove the name form dictionary
			[m_CustomizeIconsNameStringList removeObjectForKey:imageName];
			
			NSLog(@"delete image successful");
		}
		else 
		{
			
			NSLog(@"delete image failed item");
		}
		
		//[fileManager release];
	}
}

-(void)DeleteAllRows:(NSString*)tableName
{
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		//delete data from data base
		NSString *sqlStatement=[@"delete from " stringByAppendingString:[NSString stringWithFormat:@"\"%@\"", tableName]];
		sqlite3_stmt *deleteStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &deleteStatement, NULL)==SQLITE_OK)
		{
		}
		else 
		{
			NSLog(@"delete data statement failed");
			
			sqlite3_reset(deleteStatement);
			sqlite3_finalize(deleteStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		
		if (SQLITE_DONE != sqlite3_step(deleteStatement))
		{
			NSLog(@"failed to delete data from database");
			
			sqlite3_reset(deleteStatement);
			sqlite3_finalize(deleteStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		sqlite3_reset(deleteStatement);
		sqlite3_finalize(deleteStatement);
		
		
		
		NSLog(@"delete data from database successful");
	}
	else 
	{
		NSLog(@"delete data wallpaper open database failed");
		return;
	}
	
	sqlite3_close(database);
}

-(void)CreateNewPoolTable:(NSString*)name;
{
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	char *errorMsg;
	
	//open database
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		//appending string turn into a statement
		NSString *sqlStatement=@"CREATE TABLE \"";
		NSString *command=[sqlStatement stringByAppendingString:[name stringByAppendingString:@"\" (\"Name\" TEXT PRIMARY KEY, \"LableName\" TEXT, \"TypeTag\" TEXT, \"Quantity\" INTEGER)"]];
		
		//sqlite3_stmt *createTableStatement;
		
		if(sqlite3_exec(database, [command UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK)
		{
			sqlite3_free(errorMsg);
		}
		else 
		{
			NSLog(@"create pool table statement faild");
			
			//sqlite3_reset(createTableStatement);
			//sqlite3_finalize(createTableStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			return;
		}
		
		//sqlite3_finalize(createTableStatement);
		//sqlite3_reset(createTableStatement);

	}
	else 
	{
		NSLog(@"create pool table open database failed");
		return;
	}
	
	sqlite3_close(database);
	
	
	//open database
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		//variable to add table name to cumstomize pool in database
		NSString *sqlStatementAddTable=@"insert into Customize_Pool(Name, Link) Values(?, ?)";
		sqlite3_stmt *AddTableStatement;
		
		//add this new pool table name to pool table which contain several pool table
		if(sqlite3_prepare_v2(database, [sqlStatementAddTable UTF8String], -1, &AddTableStatement, NULL)==SQLITE_OK)
		{
			sqlite3_bind_text(AddTableStatement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(AddTableStatement, 2, [name UTF8String], -1, SQLITE_TRANSIENT);
		}
		else 
		{
			NSLog(@"statement adding new table to pool table failed ");
			
			sqlite3_reset(AddTableStatement);
			sqlite3_finalize(AddTableStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			return;
		}
		
		//check if need to update or add new one
		if(SQLITE_DONE != sqlite3_step(AddTableStatement))
		{
			NSLog(@"add datato table failed");
			
			sqlite3_reset(AddTableStatement);
			sqlite3_finalize(AddTableStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			return;
		}
		
		sqlite3_reset(AddTableStatement);
		sqlite3_finalize(AddTableStatement);
		

		
	}
	else 
	{
		NSLog(@"create pool table open database failed");
		return;
	}
	
	sqlite3_close(database);
	
	//also add it to customize pool string list
	[m_CustomizePoolNameStringList setValue:name forKey:name];
}

-(void)SaveIconDataToPoolTable:(NSString*)poolTableName WithIconName:(NSString*)iconName WithIconLableName:(NSString*)iconLableName 
				   WithTypeTag:(NSString*)typeTag WithQuantity:(NSUInteger)quantity
{
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	//open database
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		//variable to add table name to cumstomize pool in database
		NSString *sqlStatementAddIcon=[NSString stringWithFormat:@"insert into \"%@\"(Name, LableName, TypeTag, Quantity) Values(?, ?, ?, ?)", poolTableName];
		sqlite3_stmt *AddIconStatement;
		
		//add this new pool table name to pool table which contain several pool table
		if(sqlite3_prepare_v2(database, [sqlStatementAddIcon UTF8String], -1, &AddIconStatement, NULL)==SQLITE_OK)
		{
			sqlite3_bind_text(AddIconStatement, 1, [iconName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(AddIconStatement, 2, [iconLableName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(AddIconStatement, 3, [typeTag UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(AddIconStatement, 4, quantity);
		}
		else 
		{
			NSLog(@"statement adding new icon to pool table failed ");
			
			sqlite3_reset(AddIconStatement);
			sqlite3_finalize(AddIconStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			return;
		}
		
		//check if need to update or add new one
		if(SQLITE_DONE != sqlite3_step(AddIconStatement))
		{
			NSLog(@"add icon data to table failed");
			
			sqlite3_reset(AddIconStatement);
			sqlite3_finalize(AddIconStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			return;
		}
		
		sqlite3_reset(AddIconStatement);
		sqlite3_finalize(AddIconStatement);
		

		
	}
	else 
	{
		NSLog(@"create pool table open database failed");
		return;
	}
	
	sqlite3_close(database);
	
}
-(void)DeleteIconDataFromPoolTable:(NSString*)poolTableName WithIconName:(NSString*)iconName
{
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		//delete data from data base
		NSString *sqlStatement=[NSString stringWithFormat:@"delete from \"%@\" where Name = ?", poolTableName];
		sqlite3_stmt *deleteIconStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &deleteIconStatement, NULL)==SQLITE_OK)
		{
			sqlite3_bind_text(deleteIconStatement, 1, [iconName UTF8String], -1, SQLITE_TRANSIENT);
		}
		else 
		{
			NSLog(@"delete icon data statement failed");
			
			sqlite3_reset(deleteIconStatement);
			sqlite3_finalize(deleteIconStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		
		if (SQLITE_DONE != sqlite3_step(deleteIconStatement))
		{
			NSLog(@"failed to delete icon data from database");
			
			sqlite3_reset(deleteIconStatement);
			sqlite3_finalize(deleteIconStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		sqlite3_reset(deleteIconStatement);
		sqlite3_finalize(deleteIconStatement);
		
		
		
		NSLog(@"delete icon data from database successful");
	}
	else 
	{
		NSLog(@"delete icon data open database failed");
		return;
	}
	
	sqlite3_close(database);
}

-(NSMutableArray*)GetSampleList:(NSString*)tableName
{
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	NSMutableArray *sampleList=[[NSMutableArray alloc] init];
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		//delete data from data base
		NSString *sqlStatement=[NSString stringWithFormat:@"select * from \"%@\"", tableName];
		sqlite3_stmt *sampleStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &sampleStatement, NULL)==SQLITE_OK)
		{
			//run through each row in table
			while(sqlite3_step(sampleStatement)==SQLITE_ROW)
			{
				//retrieve name attribute
				NSString *sampleName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(sampleStatement, 0)];
				
				//add to array
				[sampleList addObject:sampleName];
			}
		}
		else 
		{
			NSLog(@"sample list statement failed");
			
			sqlite3_reset(sampleStatement);
			sqlite3_finalize(sampleStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return nil;
		}
		
		sqlite3_reset(sampleStatement);
		sqlite3_finalize(sampleStatement);
		
		
	}
	else 
	{
		NSLog(@"sample list open database failed");
		return nil;
	}
	
	sqlite3_close(database);
	
	return sampleList;
}

-(NSMutableArray*)GetCustomItemListWithTableName:(NSString*)tableName
{
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	NSMutableArray *customItemList=[[NSMutableArray alloc] init];
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		//delete data from data base
		NSString *sqlStatement=[NSString stringWithFormat:@"select * from \"%@\"", tableName];
		sqlite3_stmt *customStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &customStatement, NULL)==SQLITE_OK)
		{
			//run through each row in table
			while(sqlite3_step(customStatement)==SQLITE_ROW)
			{
				//retrieve name attribute
				NSString *customItemName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(customStatement, 0)];
				int customItemQuantity=sqlite3_column_int(customStatement, 3);
				
				LoadIconDataPackage *dataPackage=[[LoadIconDataPackage alloc] init];
				[dataPackage setM_Name:customItemName];
				[dataPackage setM_Quantity:customItemQuantity];
				
				//add to array
				[customItemList addObject:dataPackage];
			}
		}
		else 
		{
			NSLog(@"custom item list statement failed");
			
			sqlite3_reset(customStatement);
			sqlite3_finalize(customStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return nil;
		}
		
		sqlite3_reset(customStatement);
		sqlite3_finalize(customStatement);
		
		
	}
	else 
	{
		NSLog(@"custom item list open database failed");
		return nil;
	}
	
	sqlite3_close(database);
	
	return customItemList;
}

-(void)RenameCustomPoolTable:(NSString*)previousName WithNewName:(NSString*)newName
{
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		NSString *sqlStatement=[NSString stringWithFormat:@"ALTER TABLE \"%@\" RENAME TO \"%@\"", previousName, newName];
		sqlite3_stmt *renameStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &renameStatement, NULL)==SQLITE_OK)
		{
			
			if (SQLITE_DONE != sqlite3_step(renameStatement))
			{
				NSLog(@"failed to rename pool from database");
				
				sqlite3_reset(renameStatement);
				sqlite3_finalize(renameStatement);
				
				NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
				sqlite3_close(database);
				
				return;
			}
			
		}
		else 
		{
			NSLog(@"rename statement failed");
			
			sqlite3_reset(renameStatement);
			sqlite3_finalize(renameStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		sqlite3_reset(renameStatement);
		sqlite3_finalize(renameStatement);
		
	}
	else 
	{
		NSLog(@"rename custom pool open database failed");
		return;
	}

	sqlite3_close(database);
	
	
	//also delete previoue name form customize pool
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		NSString *sqlStatement=@"delete from Customize_Pool where Name = ?";
		sqlite3_stmt *deleteStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &deleteStatement, NULL)==SQLITE_OK)
		{
			
			sqlite3_bind_text(deleteStatement, 1, [previousName UTF8String], -1, SQLITE_TRANSIENT);

			
			if (SQLITE_DONE != sqlite3_step(deleteStatement))
			{
				NSLog(@"delete name from pool from database");
				
				sqlite3_reset(deleteStatement);
				sqlite3_finalize(deleteStatement);
				
				NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
				sqlite3_close(database);
				
				return;
			}
			
		}
		else 
		{
			NSLog(@"delete statement failed");
			
			sqlite3_reset(deleteStatement);
			sqlite3_finalize(deleteStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		sqlite3_reset(deleteStatement);
		sqlite3_finalize(deleteStatement);
		
	}
	else 
	{
		NSLog(@"delete  name open database failed");
		return;
	}
	
	sqlite3_close(database);
	
	
	//also insert new name customize pool
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		NSString *sqlStatement=@"insert into Customize_Pool(Name, Link) Values(?, ?)";
		sqlite3_stmt *addStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &addStatement, NULL)==SQLITE_OK)
		{
			
			sqlite3_bind_text(addStatement, 1, [newName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 2, [newName UTF8String], -1, SQLITE_TRANSIENT);
			
			
			if (SQLITE_DONE != sqlite3_step(addStatement))
			{
				NSLog(@"add name to pool from database");
				
				sqlite3_reset(addStatement);
				sqlite3_finalize(addStatement);
				
				NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
				sqlite3_close(database);
				
				return;
			}
			
		}
		else 
		{
			NSLog(@"add statement failed");
			
			sqlite3_reset(addStatement);
			sqlite3_finalize(addStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		sqlite3_reset(addStatement);
		sqlite3_finalize(addStatement);
		
	}
	else 
	{
		NSLog(@"add  name open database failed");
		return;
	}
	
	sqlite3_close(database);
	
	
	[m_CustomizePoolNameStringList removeObjectForKey:previousName];
	[m_CustomizePoolNameStringList setValue:newName forKey:newName];
	
}

-(void)DuplicatePoolTable:(NSString*)sourceName WithNewName:(NSString*)newName
{
	//create new table first
	[self CreateNewPoolTable:newName];
	
	
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		NSString *sqlStatement=[NSString stringWithFormat:@"INSERT INTO \"%@\" SELECT * FROM \"%@\"", newName, sourceName];
		sqlite3_stmt *copyStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &copyStatement, NULL)==SQLITE_OK)
		{
			
			if (SQLITE_DONE != sqlite3_step(copyStatement))
			{
				NSLog(@"failed to copy pool from database");
				
				sqlite3_reset(copyStatement);
				sqlite3_finalize(copyStatement);
				
				NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
				sqlite3_close(database);
				
				return;
			}
			
		}
		else 
		{
			NSLog(@"copy statement failed");
			
			sqlite3_reset(copyStatement);
			sqlite3_finalize(copyStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		sqlite3_reset(copyStatement);
		sqlite3_finalize(copyStatement);
		

	}
	else 
	{
		NSLog(@"copy custom pool open database failed");
		return;
	}
	
	sqlite3_close(database);
	

}

-(void)DeletePoolTable:(NSString*)tableName
{
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		NSString *sqlStatement=[NSString stringWithFormat:@"DROP TABLE \"%@\"", tableName];
		sqlite3_stmt *deleteTableStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &deleteTableStatement, NULL)==SQLITE_OK)
		{
			
			if (SQLITE_DONE != sqlite3_step(deleteTableStatement))
			{
				NSLog(@"failed to delete pool from database");
				
				sqlite3_reset(deleteTableStatement);
				sqlite3_finalize(deleteTableStatement);
				
				NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
				sqlite3_close(database);
				
				return;
			}
			
		}
		else 
		{
			NSLog(@"delete statement failed");
			
			sqlite3_reset(deleteTableStatement);
			sqlite3_finalize(deleteTableStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		sqlite3_reset(deleteTableStatement);
		sqlite3_finalize(deleteTableStatement);
		
	}
	else 
	{
		NSLog(@"delete custom pool open database failed");
		return;
	}
	
	sqlite3_close(database);
	
	//also delete previoue name form customize pool
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		NSString *sqlStatement=@"delete from Customize_Pool where Name = ?";
		sqlite3_stmt *deleteStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &deleteStatement, NULL)==SQLITE_OK)
		{
			
			sqlite3_bind_text(deleteStatement, 1, [tableName UTF8String], -1, SQLITE_TRANSIENT);
			
			
			if (SQLITE_DONE != sqlite3_step(deleteStatement))
			{
				NSLog(@"delete name from pool from database");
				
				sqlite3_reset(deleteStatement);
				sqlite3_finalize(deleteStatement);
				
				NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
				sqlite3_close(database);
				
				return;
			}
			
		}
		else 
		{
			NSLog(@"delete statement failed");
			
			sqlite3_reset(deleteStatement);
			sqlite3_finalize(deleteStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		sqlite3_reset(deleteStatement);
		sqlite3_finalize(deleteStatement);
		

	}
	else 
	{
		NSLog(@"delete  name open database failed");
		return;
	}
	
	sqlite3_close(database);
	
	//remove from custom pool string name list
	[m_CustomizePoolNameStringList removeObjectForKey:tableName];
}

-(id)GetUserConfig
{
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	//create a package
	UserConfigDataPackage *dataPackage=[[UserConfigDataPackage alloc] init];
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		NSString *sqlStatement=@"select * from ";
		NSString *command=[sqlStatement stringByAppendingString:@"User_Config"];
		
		sqlite3_stmt *userConfigStatement;
		
		
		if(sqlite3_prepare_v2(database, [command UTF8String], -1, &userConfigStatement, NULL)==SQLITE_OK)
		{
			
			while(sqlite3_step(userConfigStatement)==SQLITE_ROW)
			{
				//NSString *user=[NSString stringWithUTF8String:(char*)sqlite3_column_text(userConfigStatement, 0)];
				NSString *menuBorder=[NSString stringWithUTF8String:(char*)sqlite3_column_text(userConfigStatement, 1)];
				NSString *menuBackground=[NSString stringWithUTF8String:(char*)sqlite3_column_text(userConfigStatement, 2)];
				NSString *infoBarBackground=[NSString stringWithUTF8String:(char*)sqlite3_column_text(userConfigStatement, 3)];
				NSString *itemBorder=[NSString stringWithUTF8String:(char*)sqlite3_column_text(userConfigStatement, 4)];
				NSString *itemBackground=[NSString stringWithUTF8String:(char*)sqlite3_column_text(userConfigStatement, 5)];
				NSString *wallpaper=[NSString stringWithUTF8String:(char*)sqlite3_column_text(userConfigStatement, 6)];
				CGFloat poolRed=sqlite3_column_double(userConfigStatement, 7)/255;
				CGFloat poolGreen=sqlite3_column_double(userConfigStatement, 8)/255;
				CGFloat poolBlue=sqlite3_column_double(userConfigStatement, 9)/255;
				CGFloat poolAlpha=sqlite3_column_double(userConfigStatement, 10);
				NSString *lastPoolName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(userConfigStatement, 11)];
				NSString *topRightBorder=[NSString stringWithUTF8String:(char*)sqlite3_column_text(userConfigStatement, 12)];
				NSString *topRightBorder2=[NSString stringWithUTF8String:(char*)sqlite3_column_text(userConfigStatement, 13)];
				
				//set up package
				[dataPackage setM_MenuBorder:menuBorder];
				[dataPackage setM_MenuBackground:menuBackground];
				[dataPackage setM_InfoBarBackground:infoBarBackground];
				[dataPackage setM_ItemBorder:itemBorder];
				[dataPackage setM_ItemBackground:itemBackground];
				[dataPackage setM_Wallpaper:wallpaper];
				[dataPackage setM_PoolRed:poolRed];
				[dataPackage setM_PoolGreen:poolGreen];
				[dataPackage setM_PoolBlue:poolBlue];
				[dataPackage setM_PoolAlpha:poolAlpha];
				[dataPackage setM_LastPoolName:lastPoolName];
				[dataPackage setM_TopRightBorder:topRightBorder];
				[dataPackage setM_TopRightBorder2:topRightBorder2];
			}
			
		}
		else 
		{
			NSLog(@"config statement failed");
			
			sqlite3_reset(userConfigStatement);
			sqlite3_finalize(userConfigStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return nil;
		}
		
		sqlite3_reset(userConfigStatement);
		sqlite3_finalize(userConfigStatement);
		

	}
	else 
	{
		NSLog(@"config open database failed");
		return nil;
	}
	
	sqlite3_close(database);
	
	return dataPackage;
}

-(BOOL)IsCustomWallpaper:(NSString*)wallpaperName
{
	BOOL custom=NO;
	
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		NSString *sqlStatement=@"select * from ";
		NSString *command=[sqlStatement stringByAppendingString:@"L5_Catalog1_Customize_Wallpaper"];
		
		sqlite3_stmt *checkStatement;
		
		if(sqlite3_prepare_v2(database, [command UTF8String], -1, &checkStatement, NULL)==SQLITE_OK)
		{
			
			while(sqlite3_step(checkStatement)==SQLITE_ROW)
			{
				NSString *imageName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(checkStatement, 9)];
				
				if([wallpaperName compare:imageName]==0)
				{
					custom=YES;
					
					sqlite3_reset(checkStatement);
					sqlite3_finalize(checkStatement);
					
					sqlite3_close(database);
					return custom;
				}
			}
			
		}
		else 
		{
			NSLog(@"delete statement failed");
			
			sqlite3_reset(checkStatement);
			sqlite3_finalize(checkStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return custom;
		}
		
		sqlite3_reset(checkStatement);
		sqlite3_finalize(checkStatement);
		

	}
	else 
	{
		NSLog(@"delete custom pool open database failed");
		return custom;
	}
	
	sqlite3_close(database);
	
	return custom;
}

-(void)SaveUserConfig:(UserConfigDataPackage*)dataPackage
{
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		//delete data from data base
		NSString *sqlStatement=@"DELETE FROM User_Config WHERE User = ?";
		sqlite3_stmt *deleteStatement;
		NSString *user=[NSString stringWithString:@"user"];
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &deleteStatement, NULL)==SQLITE_OK)
		{
			sqlite3_bind_text(deleteStatement, 1, [user UTF8String], -1, SQLITE_TRANSIENT);
		}
		else 
		{
			NSLog(@"delete data statement failed");
			
			sqlite3_reset(deleteStatement);
			sqlite3_finalize(deleteStatement);
			
			NSAssert1(0, @"Error: '%s'.", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		
		if (SQLITE_DONE != sqlite3_step(deleteStatement))
		{
			NSLog(@"failed to delete data from database");
			
			sqlite3_reset(deleteStatement);
			sqlite3_finalize(deleteStatement);
			
			NSAssert1(0, @"Error: '%s'.", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		sqlite3_reset(deleteStatement);
		sqlite3_finalize(deleteStatement);
		
		
		
		NSLog(@"delete data from database successful");
	}
	else 
	{
		NSLog(@"delete data wallpaper open database failed");
		return;
	}
	sqlite3_close(database);
	
	
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		//delete data from data base
		NSString *sqlStatement=@"insert into User_Config(User, MenuBorder, MenuBackground, InfoBarBackground, ItemBorder, ItemBackground, Wallpaper, PoolRed, PoolGreen, PoolBlue, PoolAlpha, LastPoolName, TopRightBorder, TopRightBorder2) Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
		//NSString *sqlStatement=@"UPDATE User_Config Set User = ?, MenuBorder = ?, MenuBackground = ?, InfoBarBackground = ?, ItemBorder = ?,  ItemBackground = ?, Wallpaper = ?, PoolRed = ?, PoolGreen =?, PoolBlue = ? PoolAlpha =? LastPoolName =? TopRightBorder = ? TopRightBorder2 = ?";
		sqlite3_stmt *addStatement;
		
		double poolRed=[dataPackage m_PoolRed]*255;
		double poolGreen=[dataPackage m_PoolGreen]*255;
		double poolBlue=[dataPackage m_PoolBlue]*255;
		double poolAlpha=[dataPackage m_PoolAlpha];
		
		NSString *user=[NSString stringWithString:@"user"];
		
		if(sqlite3_prepare(database, [sqlStatement UTF8String], -1, &addStatement, NULL)==SQLITE_OK)
		{
			sqlite3_bind_text(addStatement, 1, [user UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 2, [[dataPackage m_MenuBorder] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 3, [[dataPackage m_MenuBackground] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 4, [[dataPackage m_InfoBarBackground] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 5, [[dataPackage m_ItemBorder] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 6, [[dataPackage m_ItemBackground] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 7, [[dataPackage m_Wallpaper] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_double(addStatement, 8, poolRed);
			sqlite3_bind_double(addStatement, 9, poolGreen);
			sqlite3_bind_double(addStatement, 10, poolBlue);
			sqlite3_bind_double(addStatement, 11, poolAlpha);
			sqlite3_bind_text(addStatement, 12, [[dataPackage m_LastPoolName] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 13, [[dataPackage m_TopRightBorder] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStatement, 14, [[dataPackage m_TopRightBorder2] UTF8String], -1, SQLITE_TRANSIENT);
		}
		else 
		{
			NSLog(@"add data statement failed");
			
			sqlite3_reset(addStatement);
			sqlite3_finalize(addStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		
		if(SQLITE_DONE != sqlite3_step(addStatement))
		{
			NSLog(@"add data statement failed");
			
			sqlite3_reset(addStatement);
			sqlite3_finalize(addStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		sqlite3_reset(addStatement);
		sqlite3_finalize(addStatement);
		
		
		NSLog(@"add data from database successful");
	}
	else 
	{
		NSLog(@"add data wallpaper open database failed");
		return;
	}
	sqlite3_close(database);
	
}

-(int)GetAppUsedTime
{
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	int appUsedTime;
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		NSString *sqlStatement=@"select * from ";
		NSString *command=[sqlStatement stringByAppendingString:@"App_Use_Time"];
		
		sqlite3_stmt *appUsedTimeStatement;
		
		
		if(sqlite3_prepare_v2(database, [command UTF8String], -1, &appUsedTimeStatement, NULL)==SQLITE_OK)
		{
			
			while(sqlite3_step(appUsedTimeStatement)==SQLITE_ROW)
			{
				
				appUsedTime=sqlite3_column_int(appUsedTimeStatement, 0);
			}
			
		}
		else 
		{
			NSLog(@"appUsedTime statement failed");
			
			sqlite3_reset(appUsedTimeStatement);
			sqlite3_finalize(appUsedTimeStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return -1;
		}
		
		sqlite3_reset(appUsedTimeStatement);
		sqlite3_finalize(appUsedTimeStatement);
		
		
	}
	else 
	{
		NSLog(@"appUsedTime open database failed");
		return -1;
	}
	
	sqlite3_close(database);
	
	return appUsedTime;
}

-(void)UpdateAppUsedTime:(int)usedTime
{
	//deal with database
	NSString *databaseName=@"VTCDefaultDatabase.sqlite";
	NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentPaths objectAtIndex:0];
	NSString *databasePath =[documentDir stringByAppendingPathComponent:databaseName];
	
	//open databse
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
	{
		NSString *sqlStatement=@"update App_Use_Time Set UsedTime = ?";
		sqlite3_stmt *updateStatement;
		
		
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &updateStatement, NULL)==SQLITE_OK)
		{
			
			sqlite3_bind_int(updateStatement, 1, usedTime);
			
		}
		else 
		{
			NSLog(@"update app used time statement failed");
			
			sqlite3_reset(updateStatement);
			sqlite3_finalize(updateStatement);
			
			NSAssert1(0, @"Error: '%s' ", sqlite3_errmsg(database));
			sqlite3_close(database);

			return;
		}
		
		
		if (SQLITE_DONE != sqlite3_step(updateStatement))
		{
			NSLog(@"failed to update app used time from database");
			
			sqlite3_reset(updateStatement);
			sqlite3_finalize(updateStatement);
			
			NSAssert1(0, @"Error: '%s'.", sqlite3_errmsg(database));
			sqlite3_close(database);
			
			return;
		}
		
		sqlite3_reset(updateStatement);
		sqlite3_finalize(updateStatement);
		
		
		
		NSLog(@"update app used time from database successful");
		
	}
	else 
	{
		NSLog(@"update app used time open database failed");
		return;
	}
	
	sqlite3_close(database);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	
	if(m_DatabaseName!=nil)
	{
		[m_DatabaseName release];
	}
	
	if(m_DatabasePath!=nil)
	{
		[m_DatabasePath release];
	}
	
	if(m_PageViewData!=nil)
	{
		[m_PageViewData removeAllObjects];
		[m_PageViewData release];
	}
	
	if(m_DefaultIconsNameStringList!=nil)
	{
		[m_DefaultIconsNameStringList release];
	}
	
	if(m_CustomizeIconsNameStringList!=nil)
	{
		[m_CustomizeIconsNameStringList release];
	}
	
	if(m_CustomizePoolNameStringList!=nil)
	{
		[m_CustomizePoolNameStringList release];
	}
	
	
    [super dealloc];
}


@end
