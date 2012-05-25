//
//  Utility.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"
#import "PackingCheckListAppDelegate.h"
#import "ImportPhoto.h"
#import "ImportPhotoImageView.h"
#import "ItemPageView.h"
#import "MenuPageView.h"
#import "MenuView.h"
#import "PoolIcon.h"
#import "DataController.h"
#import "ItemIcon.h"
#import "ItemView.h"
#import "MenuBorder.h"
#import "TopRightBorder.h"
#import "TopRightBorder2.h"
#import "ItemBorder.h"
#import "MenuBackground.h"
#import "ItemBackground.h"
#import "WallpaperView.h"
#import "PoolBackground.h"
#import "DropDownMenu.h"
#import "DropDownMenuButton.h"
#import "PoolView.h"
#import "PoolPageView.h"
#import "AlertTableView.h"
#import "HUDView.h"
#import "TextFieldAlertView.h"
#import "QuantityAlert.h"

@implementation Utility

@synthesize mDelegate;
@synthesize m_ImportPhotoFunction;
@synthesize m_CreateNewDropDwonMenu;
@synthesize m_ManageListDropDwonMenu;
@synthesize m_SortDropDwonMenu;
@synthesize m_HUD;
@synthesize m_Index;
@synthesize m_QuantityPoolIcon;

-(id)InitUtility
{
	if(self=[super init])
	{
		//init import photo function
		ImportPhoto *importPhotoFunction=[[ImportPhoto alloc] InitImportPhotoWithDelegate:self.mDelegate];
		self.m_ImportPhotoFunction=importPhotoFunction;
		[importPhotoFunction release];
	}
	
	return self;
}

-(void)StartUtilityWithCommand:(NSString*)command WithObject:(id)object
{
	if([command compare:@"no action"]==0)
	{
		return;
	}
	
	if([command compare:@"importphoto"]==0)
	{
		[m_ImportPhotoFunction ActiveImportPhotoMenu];
	}
	else if([command compare:@"reset"]==0) 
	{
		m_Mode=@"ResetMode";
		
		UIAlertView *resetAlert=[[UIAlertView alloc] initWithTitle:@"Reset alert" message:@"Reset Menu and pool!" delegate:self 
												 cancelButtonTitle:@"NO" otherButtonTitles:@"Reset", nil];
		[resetAlert show];
		[resetAlert release];
	}
	else if([command compare:@"Quantity"]==0)
	{
		m_Mode=@"QuantityMode";
		
		if([object isKindOfClass:[PoolIcon class]])
		{
			self.m_QuantityPoolIcon=(PoolIcon*)object;
			m_SubMode=@"QuantityAskMode";
			
			NSString *iconName=[(PoolIcon*)object m_LableName];
			
			QuantityAlert *quantityAlert=[[QuantityAlert alloc] InitWithTitle:@"Quantity" WithMessage:[NSString stringWithFormat:@"Please enter a quantity from 2 to 99 \n %@", iconName] 
																 WithDelegate:self WithPlaceHolder:@"Enter number" WithButtons:[NSArray arrayWithObjects:@"OK", nil]];
			[quantityAlert show];
			[quantityAlert release];
		}
		else if([object isKindOfClass:[NSString class]])
		{
			m_SubMode=@"QuantityInvaildMode";
			
			NSString *warningMsg=(NSString*)object;
			
			UIAlertView *warningAlert=[[UIAlertView alloc] initWithTitle:@"Invaild" message:warningMsg delegate:self 
													 cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			[warningAlert show];
			[warningAlert release];
			
		}
	}
	else if([command compare:@"changewallpaper"]==0)
	{
		ItemIcon *icon=(ItemIcon*)object;
		
		NSString *wallpaper=[icon m_Wallpaper];
		
		//check if wallpaper is system or customize
		if([wallpaper compare:@"customize"]==0)
		{
			//customize
			[(WallpaperView*)[mDelegate m_WallpaperView] ChangeWallpaperCustomize:[[icon m_ImageView] image] WithFileName:[icon m_ImageFileName]];
		}
		else 
		{
			//bundle
			NSString *systemWallpaper=[[@"Wallpaper_" stringByAppendingString:wallpaper] stringByAppendingString:@".png"];
			
			[(WallpaperView*)[mDelegate m_WallpaperView] ChangeWallpaperSystem:systemWallpaper];
		}

	}
	else if([command compare:@"changetheme"]==0)
	{
		ItemIcon *icon=(ItemIcon*)object;
		
		NSString *themeSet=[icon m_ThemeSet];
		
		NSString *menuBorder=[[@"themeset_" stringByAppendingString:themeSet] stringByAppendingString:@"_01.png"];
		NSString *menuBackground=[[@"themeset_" stringByAppendingString:themeSet] stringByAppendingString:@"_02.png"];
		NSString *infoBackground=[[@"themeset_" stringByAppendingString:themeSet] stringByAppendingString:@"_03.png"];
		NSString *itemBorder=[[@"themeset_" stringByAppendingString:themeSet] stringByAppendingString:@"_04.png"];
		NSString *itemBackground=[[@"themeset_" stringByAppendingString:themeSet] stringByAppendingString:@"_05.png"];
		NSString *topRightBorder=[[@"themeset_" stringByAppendingString:themeSet] stringByAppendingString:@"_06.png"];
		NSString *wallpaper=[[@"Wallpaper_" stringByAppendingString:themeSet] stringByAppendingString:@".png"];
		
		[(MenuBorder*)[mDelegate m_MenuBorder] ChangeBorderImage:menuBorder];
		[(MenuBackground*)[mDelegate m_MenuBackground] ChangeBackgroundImage:menuBackground];
		[(InformationBar*)[mDelegate m_InfoBar] ChangeBackgroundImage:infoBackground];
		[(ItemBorder*)[mDelegate m_ItemBorder] ChangeBorderImage:itemBorder];
		[(ItemBackground*)[mDelegate m_ItemBackground] ChangeBackgroundImage:itemBackground];
		[(TopRightBorder*)[mDelegate m_TopRightBorder] ChangeBorderImage:topRightBorder];
		[(TopRightBorder2*)[mDelegate m_TopRightBorder2] ChangeBorderImage:topRightBorder];
		[(WallpaperView*)[mDelegate m_WallpaperView] ChangeWallpaperSystem:wallpaper];
		
	}
	else if([command compare:@"changebackgroundcolor"]==0) 
	{
		ItemIcon *icon=(ItemIcon*)object;
		
		UIColor *backgroundColor=[icon m_BackgroundColor];
		
		[(PoolBackground*)[mDelegate m_PoolBackground] ChangeBackgroundColor:backgroundColor];
	}
	else if([command compare:@"changemenucolor"]==0)
	{
		ItemIcon *icon=(ItemIcon*)object;
		
		NSString *menuColor=[icon m_MenuColor];
		
		//check what menu color should be changed to
		if([menuColor compare:@"MenuSet1"]==0)
		{
			//change menu color
			//first change border
			[(MenuBorder*)[mDelegate m_MenuBorder] ChangeBorderImage:@"menuset1_01.png"];
			[(TopRightBorder*)[mDelegate m_TopRightBorder] ChangeBorderImage:@"menuset1_06.png"];
			[(TopRightBorder2*)[mDelegate m_TopRightBorder2] ChangeBorderImage:@"menuset1_06.png"];
			[(ItemBorder*)[mDelegate m_ItemBorder] ChangeBorderImage:@"menuset1_04.png"];
			
			//change background
			[(MenuBackground*)[mDelegate m_MenuBackground] ChangeBackgroundImage:@"menuset1_02.png"];
			[(ItemBackground*)[mDelegate m_ItemBackground] ChangeBackgroundImage:@"menuset1_05.png"];
			
			//change info bar
			[(InformationBar*)[mDelegate m_InfoBar] ChangeBackgroundImage:@"menuset1_03.png"];
		}
		else if([menuColor compare:@"MenuSet2"]==0) 
		{
			//change menu color
			//first change border
			[(MenuBorder*)[mDelegate m_MenuBorder] ChangeBorderImage:@"menuset2_01.png"];
			[(TopRightBorder*)[mDelegate m_TopRightBorder] ChangeBorderImage:@"menuset2_06.png"];
			[(TopRightBorder2*)[mDelegate m_TopRightBorder2] ChangeBorderImage:@"menuset2_06.png"];
			[(ItemBorder*)[mDelegate m_ItemBorder] ChangeBorderImage:@"menuset2_04.png"];
			
			//change background
			[(MenuBackground*)[mDelegate m_MenuBackground] ChangeBackgroundImage:@"menuset2_02.png"];
			[(ItemBackground*)[mDelegate m_ItemBackground] ChangeBackgroundImage:@"menuset2_05.png"];
			
			//change info bar
			[(InformationBar*)[mDelegate m_InfoBar] ChangeBackgroundImage:@"menuset2_03.png"];
		}
		else if([menuColor compare:@"MenuSet3"]==0) 
		{
			//change menu color
			//first change border
			[(MenuBorder*)[mDelegate m_MenuBorder] ChangeBorderImage:@"menuset3_01.png"];
			[(TopRightBorder*)[mDelegate m_TopRightBorder] ChangeBorderImage:@"menuset3_06.png"];
			[(TopRightBorder2*)[mDelegate m_TopRightBorder2] ChangeBorderImage:@"menuset3_06.png"];
			[(ItemBorder*)[mDelegate m_ItemBorder] ChangeBorderImage:@"menuset3_04.png"];
			
			//change background
			[(MenuBackground*)[mDelegate m_MenuBackground] ChangeBackgroundImage:@"menuset3_02.png"];
			[(ItemBackground*)[mDelegate m_ItemBackground] ChangeBackgroundImage:@"menuset3_05.png"];
			
			//change info bar
			[(InformationBar*)[mDelegate m_InfoBar] ChangeBackgroundImage:@"menuset3_03.png"];
		}
		else if([menuColor compare:@"MenuSet4"]==0) 
		{
			//change menu color
			//first change border
			[(MenuBorder*)[mDelegate m_MenuBorder] ChangeBorderImage:@"menuset4_01.png"];
			[(TopRightBorder*)[mDelegate m_TopRightBorder] ChangeBorderImage:@"menuset4_06.png"];
			[(TopRightBorder2*)[mDelegate m_TopRightBorder2] ChangeBorderImage:@"menuset4_06.png"];
			[(ItemBorder*)[mDelegate m_ItemBorder] ChangeBorderImage:@"menuset4_04.png"];
			
			//change background
			[(MenuBackground*)[mDelegate m_MenuBackground] ChangeBackgroundImage:@"menuset4_02.png"];
			[(ItemBackground*)[mDelegate m_ItemBackground] ChangeBackgroundImage:@"menuset4_05.png"];
			
			//change info bar
			[(InformationBar*)[mDelegate m_InfoBar] ChangeBackgroundImage:@"menuset4_03.png"];
		}
		else if([menuColor compare:@"MenuSet5"]==0) 
		{
			//change menu color
			//first change border
			[(MenuBorder*)[mDelegate m_MenuBorder] ChangeBorderImage:@"menuset5_01.png"];
			[(TopRightBorder*)[mDelegate m_TopRightBorder] ChangeBorderImage:@"menuset5_06.png"];
			[(TopRightBorder2*)[mDelegate m_TopRightBorder2] ChangeBorderImage:@"menuset5_06.png"];
			[(ItemBorder*)[mDelegate m_ItemBorder] ChangeBorderImage:@"menuset5_04.png"];
			
			//change background
			[(MenuBackground*)[mDelegate m_MenuBackground] ChangeBackgroundImage:@"menuset5_02.png"];
			[(ItemBackground*)[mDelegate m_ItemBackground] ChangeBackgroundImage:@"menuset5_05.png"];
			
			//change info bar
			[(InformationBar*)[mDelegate m_InfoBar] ChangeBackgroundImage:@"menuset5_03.png"];
		}
		else if([menuColor compare:@"MenuSet6"]==0) 
		{
			//change menu color
			//first change border
			[(MenuBorder*)[mDelegate m_MenuBorder] ChangeBorderImage:@"menuset6_01.png"];
			[(TopRightBorder*)[mDelegate m_TopRightBorder] ChangeBorderImage:@"menuset6_06.png"];
			[(TopRightBorder2*)[mDelegate m_TopRightBorder2] ChangeBorderImage:@"menuset6_06.png"];
			[(ItemBorder*)[mDelegate m_ItemBorder] ChangeBorderImage:@"menuset6_04.png"];
			
			//change background
			[(MenuBackground*)[mDelegate m_MenuBackground] ChangeBackgroundImage:@"menuset6_02.png"];
			[(ItemBackground*)[mDelegate m_ItemBackground] ChangeBackgroundImage:@"menuset6_05.png"];
			
			//change info bar
			[(InformationBar*)[mDelegate m_InfoBar] ChangeBackgroundImage:@"menuset6_03.png"];
		}
		else if([menuColor compare:@"MenuSet7"]==0) 
		{
			//change menu color
			//first change border
			[(MenuBorder*)[mDelegate m_MenuBorder] ChangeBorderImage:@"menuset7_01.png"];
			[(TopRightBorder*)[mDelegate m_TopRightBorder] ChangeBorderImage:@"menuset7_06.png"];
			[(TopRightBorder2*)[mDelegate m_TopRightBorder2] ChangeBorderImage:@"menuset7_06.png"];
			[(ItemBorder*)[mDelegate m_ItemBorder] ChangeBorderImage:@"menuset7_04.png"];
			
			//change background
			[(MenuBackground*)[mDelegate m_MenuBackground] ChangeBackgroundImage:@"menuset7_02.png"];
			[(ItemBackground*)[mDelegate m_ItemBackground] ChangeBackgroundImage:@"menuset7_05.png"];
			
			//change info bar
			[(InformationBar*)[mDelegate m_InfoBar] ChangeBackgroundImage:@"menuset7_03.png"];
		}
		else if([menuColor compare:@"MenuSet8"]==0) 
		{
			//change menu color
			//first change border
			[(MenuBorder*)[mDelegate m_MenuBorder] ChangeBorderImage:@"menuset8_01.png"];
			[(TopRightBorder*)[mDelegate m_TopRightBorder] ChangeBorderImage:@"menuset8_06.png"];
			[(TopRightBorder2*)[mDelegate m_TopRightBorder2] ChangeBorderImage:@"menuset8_06.png"];
			[(ItemBorder*)[mDelegate m_ItemBorder] ChangeBorderImage:@"menuset8_04.png"];
			
			//change background
			[(MenuBackground*)[mDelegate m_MenuBackground] ChangeBackgroundImage:@"menuset8_02.png"];
			[(ItemBackground*)[mDelegate m_ItemBackground] ChangeBackgroundImage:@"menuset8_05.png"];
			
			//change info bar
			[(InformationBar*)[mDelegate m_InfoBar] ChangeBackgroundImage:@"menuset8_03.png"];
		}
		else if([menuColor compare:@"MenuSet9"]==0) 
		{
			//change menu color
			//first change border
			[(MenuBorder*)[mDelegate m_MenuBorder] ChangeBorderImage:@"menuset9_01.png"];
			[(TopRightBorder*)[mDelegate m_TopRightBorder] ChangeBorderImage:@"menuset9_06.png"];
			[(TopRightBorder2*)[mDelegate m_TopRightBorder2] ChangeBorderImage:@"menuset9_06.png"];
			[(ItemBorder*)[mDelegate m_ItemBorder] ChangeBorderImage:@"menuset9_04.png"];
			
			//change background
			[(MenuBackground*)[mDelegate m_MenuBackground] ChangeBackgroundImage:@"menuset9_02.png"];
			[(ItemBackground*)[mDelegate m_ItemBackground] ChangeBackgroundImage:@"menuset9_05.png"];
			
			//change info bar
			[(InformationBar*)[mDelegate m_InfoBar] ChangeBackgroundImage:@"menuset9_03.png"];
		}
		else if([menuColor compare:@"MenuSet10"]==0) 
		{
			//change menu color
			//first change border
			[(MenuBorder*)[mDelegate m_MenuBorder] ChangeBorderImage:@"menuset10_01.png"];
			[(TopRightBorder*)[mDelegate m_TopRightBorder] ChangeBorderImage:@"menuset10_06.png"];
			[(TopRightBorder2*)[mDelegate m_TopRightBorder2] ChangeBorderImage:@"menuset10_06.png"];
			[(ItemBorder*)[mDelegate m_ItemBorder] ChangeBorderImage:@"menuset10_04.png"];
			
			//change background
			[(MenuBackground*)[mDelegate m_MenuBackground] ChangeBackgroundImage:@"menuset10_02.png"];
			[(ItemBackground*)[mDelegate m_ItemBackground] ChangeBackgroundImage:@"menuset10_05.png"];
			
			//change info bar
			[(InformationBar*)[mDelegate m_InfoBar] ChangeBackgroundImage:@"menuset10_03.png"];
		}
		else if([menuColor compare:@"MenuSet11"]==0) 
		{
			//change menu color
			//first change border
			[(MenuBorder*)[mDelegate m_MenuBorder] ChangeBorderImage:@"menuset11_01.png"];
			[(TopRightBorder*)[mDelegate m_TopRightBorder] ChangeBorderImage:@"menuset11_06.png"];
			[(TopRightBorder2*)[mDelegate m_TopRightBorder2] ChangeBorderImage:@"menuset11_06.png"];
			[(ItemBorder*)[mDelegate m_ItemBorder] ChangeBorderImage:@"menuset11_04.png"];
			
			//change background
			[(MenuBackground*)[mDelegate m_MenuBackground] ChangeBackgroundImage:@"menuset11_02.png"];
			[(ItemBackground*)[mDelegate m_ItemBackground] ChangeBackgroundImage:@"menuset11_05.png"];
			
			//change info bar
			[(InformationBar*)[mDelegate m_InfoBar] ChangeBackgroundImage:@"menuset11_03.png"];
		}
		else if([menuColor compare:@"MenuSet12"]==0) 
		{
			//change menu color
			//first change border
			[(MenuBorder*)[mDelegate m_MenuBorder] ChangeBorderImage:@"menuset12_01.png"];
			[(TopRightBorder*)[mDelegate m_TopRightBorder] ChangeBorderImage:@"menuset12_06.png"];
			[(TopRightBorder2*)[mDelegate m_TopRightBorder2] ChangeBorderImage:@"menuset12_06.png"];
			[(ItemBorder*)[mDelegate m_ItemBorder] ChangeBorderImage:@"menuset12_04.png"];
			
			//change background
			[(MenuBackground*)[mDelegate m_MenuBackground] ChangeBackgroundImage:@"menuset12_02.png"];
			[(ItemBackground*)[mDelegate m_ItemBackground] ChangeBackgroundImage:@"menuset12_05.png"];
			
			//change info bar
			[(InformationBar*)[mDelegate m_InfoBar] ChangeBackgroundImage:@"menuset12_03.png"];
		}

	}
	else if([command compare:@"saveasitem"]==0)
	{
		[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] Hide];
		
		//get image name from import photo view
		NSString *imageName=[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] m_ImageName];
		//get image from import photo view
		UIImage *imageFile=[[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] m_ImageView] image];
		
		//write image file to device and database
		[[mDelegate m_DataController] SaveCustomizeItemToDatabase:imageName WithImage:imageFile];
		
		//retrieve customize page view
		ItemPageView *itempageView=[[(DataController*)[mDelegate m_DataController] GetItemPageViewArrayByMenuIndex:2 WithSubMenuIndex:CutsomizePackingSubIndex] objectAtIndex:0];
		ItemPageView *taskpageView=[[(DataController*)[mDelegate m_DataController] GetItemPageViewArrayByMenuIndex:1 WithSubMenuIndex:CutsomizeTaskSubIndex] objectAtIndex:0];
		ItemPageView *wallpaperpageView=[[(DataController*)[mDelegate m_DataController] GetItemPageViewArrayByMenuIndex:0 WithSubMenuIndex:CutsomizeWallpaperSubIndex] objectAtIndex:1];
		
		//get back several icons in this page view
		NSMutableArray *itemIconArray=[itempageView m_PageColumnContainer];
		NSMutableArray *taskIconArray=[taskpageView m_PageColumnContainer];
		NSMutableArray *wallpaperIconArray=[wallpaperpageView m_PageColumnContainer];
		
		
		//run through each to find if have same icons  if so then replace it's image to new one
		for(int i=0; i<[taskIconArray count]; i++)
		{
			ItemIcon *itemIcon=[taskIconArray objectAtIndex:i];
			
			if([imageName compare:[itemIcon m_Name]]==0)
			{
				//overwrite
				[[itemIcon m_ImageView] setImage:[[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] m_ImageView] image]];
				
				break;
			}
		}
		
		for(int i=0; i<[wallpaperIconArray count]; i++)
		{
			ItemIcon *itemIcon=[wallpaperIconArray objectAtIndex:i];
			
			if([imageName compare:[itemIcon m_Name]]==0)
			{
				//overwrite
				[[itemIcon m_ImageView] setImage:[[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] m_ImageView] image]];
				
				break;
			}
		}
		
		for(int i=0; i<[itemIconArray count]; i++)
		{
			ItemIcon *itemIcon=[itemIconArray objectAtIndex:i];
			
			if([imageName compare:[itemIcon m_Name]]==0)
			{
				//overwrite
				[[itemIcon m_ImageView] setImage:[[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] m_ImageView] image]];
				
				return;
			}
		}
		
		//if there is no same image then  add new one
		NSString *imageFileName=[imageName stringByAppendingString:@".png"];
		
		//add a image to that customize page view
		[itempageView AddIconWithIconName:imageName WithLableName:imageName WithDraggable:YES WithDangerousTag:@"no" WithVisible:YES WithSortIndex:0 WithTypeTag:@"item" 
						WithBehaviour:NO WithAction:@"no action" WithImageName:imageFileName WithMenuColor:@"no" WithBackgroundColor:[UIColor clearColor] WithWallpaper:@"no" 
							 WithThemeSet:@"no" WithCustomize:YES WithItemIconIndex:0];
	}
	else if([command compare:@"saveastask"]==0)
	{
		[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] Hide];
		
		//get image name from import photo view
		NSString *imageName=[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] m_ImageName];
		//get image from import photo view
		UIImage *imageFile=[[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] m_ImageView] image];
		
		//write image file to device and database
		[[mDelegate m_DataController] SaveCustomizeTaskToDatabase:imageName WithImage:imageFile];
		
		//retrieve customize page view
		ItemPageView *itempageView=[[(DataController*)[mDelegate m_DataController] GetItemPageViewArrayByMenuIndex:2 WithSubMenuIndex:CutsomizePackingSubIndex] objectAtIndex:0];
		ItemPageView *taskpageView=[[(DataController*)[mDelegate m_DataController] GetItemPageViewArrayByMenuIndex:1 WithSubMenuIndex:CutsomizeTaskSubIndex] objectAtIndex:0];
		ItemPageView *wallpaperpageView=[[(DataController*)[mDelegate m_DataController] GetItemPageViewArrayByMenuIndex:0 WithSubMenuIndex:CutsomizeWallpaperSubIndex] objectAtIndex:1];
		
		//get back several icons in this page view
		NSMutableArray *itemIconArray=[itempageView m_PageColumnContainer];
		NSMutableArray *taskIconArray=[taskpageView m_PageColumnContainer];
		NSMutableArray *wallpaperIconArray=[wallpaperpageView m_PageColumnContainer];
		
		//run through each to find if have same icons  if so then replace it's image to new one
		for(int i=0; i<[itemIconArray count]; i++)
		{
			ItemIcon *itemIcon=[itemIconArray objectAtIndex:i];
			
			if([imageName compare:[itemIcon m_Name]]==0)
			{
				//overwrite
				[[itemIcon m_ImageView] setImage:[[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] m_ImageView] image]];
				
				break;
			}
		}
		
		for(int i=0; i<[wallpaperIconArray count]; i++)
		{
			ItemIcon *itemIcon=[wallpaperIconArray objectAtIndex:i];
			
			if([imageName compare:[itemIcon m_Name]]==0)
			{
				//overwrite
				[[itemIcon m_ImageView] setImage:[[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] m_ImageView] image]];
				
				break;
			}
		}
		
		
		for(int i=0; i<[taskIconArray count]; i++)
		{
			ItemIcon *itemIcon=[taskIconArray objectAtIndex:i];
			
			if([imageName compare:[itemIcon m_Name]]==0)
			{
				//overwrite
				[[itemIcon m_ImageView] setImage:[[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] m_ImageView] image]];
				
				return;
			}
		}
		
		//if there is no same image then  add new one
		NSString *imageFileName=[imageName stringByAppendingString:@".png"];
		
		//add a image to that customize page view
		[taskpageView AddIconWithIconName:imageName WithLableName:imageName WithDraggable:YES WithDangerousTag:@"no" WithVisible:YES WithSortIndex:0 WithTypeTag:@"task" 
						WithBehaviour:NO WithAction:@"no action" WithImageName:imageFileName WithMenuColor:@"no" WithBackgroundColor:[UIColor clearColor] WithWallpaper:@"no" 
						WithThemeSet:@"no" WithCustomize:YES WithItemIconIndex:0];
		
	}
	else if([command compare:@"saveaswallpaper"]==0)
	{
		[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] Hide];
		
		//get image name from import photo view
		NSString *imageName=[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] m_ImageName];
		//get image from import photo view
		UIImage *imageFile=[[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] m_ImageView] image];
		
		//write image file to device and database
		[[mDelegate m_DataController] SaveCustomizeWallpaperToDatabase:imageName WithImage:imageFile];
		
		//retrieve customize page view
		ItemPageView *itempageView=[[(DataController*)[mDelegate m_DataController] GetItemPageViewArrayByMenuIndex:2 WithSubMenuIndex:CutsomizePackingSubIndex] objectAtIndex:0];
		ItemPageView *taskpageView=[[(DataController*)[mDelegate m_DataController] GetItemPageViewArrayByMenuIndex:1 WithSubMenuIndex:CutsomizeTaskSubIndex] objectAtIndex:0];
		ItemPageView *wallpaperpageView=[[(DataController*)[mDelegate m_DataController] GetItemPageViewArrayByMenuIndex:0 WithSubMenuIndex:CutsomizeWallpaperSubIndex] objectAtIndex:1];
		
		//get back several icons in this page view
		NSMutableArray *itemIconArray=[itempageView m_PageColumnContainer];
		NSMutableArray *taskIconArray=[taskpageView m_PageColumnContainer];
		NSMutableArray *wallpaperIconArray=[wallpaperpageView m_PageColumnContainer];
		
		//run through each to find if have same icons  if so then replace it's image to new one
		for(int i=0; i<[itemIconArray count]; i++)
		{
			ItemIcon *itemIcon=[itemIconArray objectAtIndex:i];
			
			if([imageName compare:[itemIcon m_Name]]==0)
			{
				//overwrite
				[[itemIcon m_ImageView] setImage:[[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] m_ImageView] image]];
				
				break;
			}
		}
		
		for(int i=0; i<[taskIconArray count]; i++)
		{
			ItemIcon *itemIcon=[taskIconArray objectAtIndex:i];
			
			if([imageName compare:[itemIcon m_Name]]==0)
			{
				//overwrite
				[[itemIcon m_ImageView] setImage:[[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] m_ImageView] image]];
				
				break;
			}
		}
		
		
		for(int i=0; i<[wallpaperIconArray count]; i++)
		{
			ItemIcon *itemIcon=[wallpaperIconArray objectAtIndex:i];
			
			if([imageName compare:[itemIcon m_Name]]==0)
			{
				//overwrite
				[[itemIcon m_ImageView] setImage:[[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] m_ImageView] image]];
				
				return;
			}
		}
		
		//if there is no same image then  add new one
		NSString *imageFileName=[imageName stringByAppendingString:@".png"];
		
		//add a image to that customize page view
		[wallpaperpageView AddIconWithIconName:imageName WithLableName:imageName WithDraggable:NO WithDangerousTag:@"no" WithVisible:YES WithSortIndex:0 WithTypeTag:@"item" 
						WithBehaviour:YES WithAction:@"changewallpaper" WithImageName:imageFileName WithMenuColor:@"no" WithBackgroundColor:[UIColor clearColor] WithWallpaper:@"customize" 
						WithThemeSet:@"no" WithCustomize:YES WithItemIconIndex:0];
	}
	else if([command compare:@"removewallpaper"]==0)
	{
		[(WallpaperView*)[mDelegate m_WallpaperView] RemoveWallpaperAnimation];
	}
	else if([command compare:@"filesystemblank"]==0)
	{
		m_Mode=@"Blank";
		
		//check if pool has page
		if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]!=nil)
		{
			m_SubMode=@"FileSystemDiscardMode";
			
			UIAlertView *discardAlert=[[UIAlertView alloc] initWithTitle:@"Discard" message:@"Are you suer you want to discard current list" 
																delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			[discardAlert show];
			[discardAlert release];
		}
		else if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]==nil && object==nil)
		{
			m_SubMode=@"FileSystemBlankMode";
			
			/*
			//init an alert
			UIAlertView *blankAlert=[[UIAlertView alloc] initWithTitle:@"Blank" message:@"You will start with a blank list please enter a name for this list" 
														 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			
			//add a textfield to alert
			[blankAlert addTextFieldWithValue:@"" label:@"Enter pool name"];
			
			//retrieve that textfield
			UITextField *mTextField=[blankAlert textFieldAtIndex:0];
		
			
			//adjust textfield
			[mTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
			[mTextField setKeyboardType:UIKeyboardTypeAlphabet];
			[mTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
			[mTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
			[mTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			
			[blankAlert show];
			[blankAlert release];
			 */
			
			TextFieldAlertView *blankAlert=[[TextFieldAlertView alloc] InitWithTitle:@"Blank" WithMessage:@"You will start with a blank list please enter a name for this list" 
																		WithDelegate:self WithPlaceHolder:@"Enter pool name" WithButtons:[NSArray arrayWithObjects:@"OK", nil]];
			
			[blankAlert show];
			[blankAlert release];
		}
		else if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]==nil && object!=nil) 
		{
			//user not enter name or name is existed
			NSString *message=(NSString*)object;
			
			m_SubMode=@"FileSystemBlankMode";
			
			/*
			//init an alert
			UIAlertView *blankAlert=[[UIAlertView alloc] initWithTitle:@"Blank" message:message 
															  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			
			//add a textfield to alert
			[blankAlert addTextFieldWithValue:@"" label:@"Enter pool name"];
			
			//retrieve that textfield
			UITextField *mTextField=[blankAlert textFieldAtIndex:0];
			
			//adjust textfield
			[mTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
			[mTextField setKeyboardType:UIKeyboardTypeAlphabet];
			[mTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
			[mTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
			[mTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			
			[blankAlert show];
			[blankAlert release];
			*/
			
			TextFieldAlertView *blankAlert=[[TextFieldAlertView alloc] InitWithTitle:@"Blank" WithMessage:message 
																		WithDelegate:self WithPlaceHolder:@"Enter pool name" WithButtons:[NSArray arrayWithObjects:@"OK", nil]];
			
			[blankAlert show];
			[blankAlert release];
			
		}


	}
	else if([command compare:@"filesystemmaster"]==0)
	{
		m_Mode=@"Master";
		
		//check if pool has page
		if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]!=nil)
		{
			m_SubMode=@"FileSystemMasterDiscardMode";
			
			UIAlertView *discardAlert=[[UIAlertView alloc] initWithTitle:@"Discard" message:@"Are you suer you want to discard current list" 
																delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			[discardAlert show];
			[discardAlert release];
			
		}
		else if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]==nil && object==nil) 
		{
			m_SubMode=@"FileSystemMasterBlankMode";
			
			/*
			//init an alert
			UIAlertView *blankAlert=[[UIAlertView alloc] initWithTitle:@"Blank" message:@"You will start with a master list please enter a name for this list" 
															  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			
			//add a textfield to alert
			[blankAlert addTextFieldWithValue:@"" label:@"Enter pool name"];
			
			//retrieve that textfield
			UITextField *mTextField=[blankAlert textFieldAtIndex:0];
			
			//adjust textfield
			[mTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
			[mTextField setKeyboardType:UIKeyboardTypeAlphabet];
			[mTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
			[mTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
			[mTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			
			[blankAlert show];
			[blankAlert release];
			 */
			
			TextFieldAlertView *blankAlert=[[TextFieldAlertView alloc] InitWithTitle:@"Blank" WithMessage:@"You will start with a master list please enter a name for this list" 
																		WithDelegate:self WithPlaceHolder:@"Enter pool name" WithButtons:[NSArray arrayWithObjects:@"OK", nil]];
			
			[blankAlert show];
			[blankAlert release];
		}
		else if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]==nil && object!=nil) 
		{
			//user not enter name or name is existed
			NSString *message=(NSString*)object;
			
			m_SubMode=@"FileSystemMasterBlankMode";
			
			/*
			//init an alert
			UIAlertView *blankAlert=[[UIAlertView alloc] initWithTitle:@"Blank" message:message 
															  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			
			//add a textfield to alert
			[blankAlert addTextFieldWithValue:@"" label:@"Enter pool name"];
			
			//retrieve that textfield
			UITextField *mTextField=[blankAlert textFieldAtIndex:0];
			
			//adjust textfield
			[mTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
			[mTextField setKeyboardType:UIKeyboardTypeAlphabet];
			[mTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
			[mTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
			[mTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			
			[blankAlert show];
			[blankAlert release];
			*/
			
			TextFieldAlertView *blankAlert=[[TextFieldAlertView alloc] InitWithTitle:@"Blank" WithMessage:message 
																		WithDelegate:self WithPlaceHolder:@"Enter pool name" WithButtons:[NSArray arrayWithObjects:@"OK", nil]];
			
			[blankAlert show];
			[blankAlert release];
			
		}

	}
	else if([command compare:@"filesystemsample"]==0)
	{
		m_Mode=@"Sample";
		
		//check if pool has page
		if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]!=nil)
		{
			m_SubMode=@"FileSystemSampleDiscardMode";
			
			UIAlertView *discardAlert=[[UIAlertView alloc] initWithTitle:@"Discard" message:@"Are you suer you want to discard current list" 
																delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			[discardAlert show];
			[discardAlert release];
			
		}
		else if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]==nil && object==nil) 
		{
			m_SubMode=@"FileSystemSampleBlankMode";
			
			//start alert table view
			AlertTableView *alertTable=[[AlertTableView alloc] initWithTitle:@"Select a sample" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
			[alertTable PrepareTableWithData:[(DataController*)[mDelegate m_DataController] m_SampleListNameStrinList] WithAction:@"filesystemsample" WithDelegate:self.mDelegate];
			[alertTable show];
		}
		else if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]==nil && object!=nil) 
		{
			//user not enter name or name is existed
			NSString *message=(NSString*)object;
			
			m_SubMode=@"FileSystemSampleBlankMode";
			
			/*
			//init an alert
			UIAlertView *blankAlert=[[UIAlertView alloc] initWithTitle:@"Blank" message:message 
															  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			
			//add a textfield to alert
			[blankAlert addTextFieldWithValue:@"" label:@"Enter pool name"];
			
			//retrieve that textfield
			UITextField *mTextField=[blankAlert textFieldAtIndex:0];
			
			//adjust textfield
			[mTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
			[mTextField setKeyboardType:UIKeyboardTypeAlphabet];
			[mTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
			[mTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
			[mTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			
			[blankAlert show];
			[blankAlert release];
			*/
			
			TextFieldAlertView *blankAlert=[[TextFieldAlertView alloc] InitWithTitle:@"Blank" WithMessage:message 
																		WithDelegate:self WithPlaceHolder:@"Enter pool name" WithButtons:[NSArray arrayWithObjects:@"OK", nil]];
			
			[blankAlert show];
			[blankAlert release];
			
		}
		
	}
	else if([command compare:@"filesystemcustomize"]==0)
	{
		m_Mode=@"Custom";
		
		//check if pool has page
		if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]!=nil)
		{
			m_SubMode=@"FileSystemCustomDiscardMode";
			
			UIAlertView *discardAlert=[[UIAlertView alloc] initWithTitle:@"Discard" message:@"Are you suer you want to discard current list" 
																delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			[discardAlert show];
			[discardAlert release];
			
		}
		else if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]==nil && object==nil) 
		{
			m_SubMode=@"FileSystemCustomBlankMode";
			
			NSArray *array=[[(DataController*)[mDelegate m_DataController] m_CustomizePoolNameStringList] allValues];
			NSMutableArray *dataArray=[[NSMutableArray alloc] initWithArray:array];
			
			if([dataArray count]!=0)
			{
				//start alert table view
				AlertTableView *alertTable=[[AlertTableView alloc] initWithTitle:@"Choose a custom" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
				[alertTable PrepareTableWithData:dataArray WithAction:@"filesystemcustomize" WithDelegate:self.mDelegate];
				[alertTable show];
				
				[dataArray release];
			}
			else 
			{
				UIAlertView *noCustomAlert=[[UIAlertView alloc] initWithTitle:@"No custom" message:@"There are currently no customized list" 
																	delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[noCustomAlert show];
				[noCustomAlert release];
			}


		}
		else if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]==nil && object!=nil) 
		{
			//user not enter name or name is existed
			NSString *message=(NSString*)object;
			
			m_SubMode=@"FileSystemCustomBlankMode";
			
			/*
			//init an alert
			UIAlertView *blankAlert=[[UIAlertView alloc] initWithTitle:@"Blank" message:message 
															  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			
			//add a textfield to alert
			[blankAlert addTextFieldWithValue:@"" label:@"Enter pool name"];
			
			//retrieve that textfield
			UITextField *mTextField=[blankAlert textFieldAtIndex:0];
			
			//adjust textfield
			[mTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
			[mTextField setKeyboardType:UIKeyboardTypeAlphabet];
			[mTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
			[mTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
			[mTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			
			[blankAlert show];
			[blankAlert release];
			 */
			
			TextFieldAlertView *blankAlert=[[TextFieldAlertView alloc] InitWithTitle:@"Blank" WithMessage:message 
																		WithDelegate:self WithPlaceHolder:@"Enter pool name" WithButtons:[NSArray arrayWithObjects:@"OK", nil]];
			
			[blankAlert show];
			[blankAlert release];
			
		}
	}
	else if([command compare:@"filesystemedit"]==0)
	{
		m_Mode=@"Edit";
		
		//check if pool has page
		if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]!=nil)
		{
			m_SubMode=@"FileSystemEditDiscardMode";
			

			UIAlertView *discardAlert=[[UIAlertView alloc] initWithTitle:@"Discard" message:@"Are you suer you want to discard current list" 
																delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			[discardAlert show];
			[discardAlert release];
			
		}
		else if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]==nil && ![object isKindOfClass:[NSString class]]) 
		{
			m_SubMode=@"FileSystemEditBlankMode";
			
			NSArray *array=[[(DataController*)[mDelegate m_DataController] m_CustomizePoolNameStringList] allValues];
			NSMutableArray *dataArray=[[NSMutableArray alloc] initWithArray:array];
			
			if([dataArray count]!=0)
			{
				//start alert table view
				AlertTableView *alertTable=[[AlertTableView alloc] initWithTitle:@"Choose a custom" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
				[alertTable PrepareTableWithData:dataArray WithAction:@"filesystemedit" WithDelegate:self.mDelegate];
				[alertTable show];
				
				[dataArray release];
			}
			else 
			{
				UIAlertView *noCustomAlert=[[UIAlertView alloc] initWithTitle:@"No custom" message:@"There are currently no customized list" 
																	 delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[noCustomAlert show];
				[noCustomAlert release];
			}
			
		}
		else if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]==nil && [object isKindOfClass:[NSString class]]) 
		{
			

			
			HUDView *HUD=[[HUDView alloc] InitWithWindow:[mDelegate window]];
			self.m_HUD=HUD;
			[HUD release];
			
			[m_HUD SetText:@"Please wait"];
			[m_HUD Show:YES];
			
			NSArray *array=[[(DataController*)[mDelegate m_DataController] m_CustomizePoolNameStringList] allValues];
			NSString *customPoolName=[array objectAtIndex:m_Index];
			
			
			
			
			NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
			
			NSOperationQueue *operationQueue=[NSOperationQueue new];
			
			[pool release];
			
			//NSInvocationOperation *startHUD=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(StartHUD) object:nil];
			NSInvocationOperation *editCustomPool=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(EditCustomPool:) object:customPoolName];
			
			//[operationQueue addOperation:startHUD];
			[operationQueue addOperation:editCustomPool];
			
			//[startHUD release];
			[editCustomPool release];
			
			//tell menu scroll to item
			[(MenuView*)[mDelegate m_MenuView] ScrollToByMenuIndex:2 WithSubMenuIndex:3];
		}
	}
	else if([command compare:@"filesystemrename"]==0)
	{
		m_Mode=@"Rename";
		
		if(![object isKindOfClass:[NSString class]])
		{
			NSArray *array=[[(DataController*)[mDelegate m_DataController] m_CustomizePoolNameStringList] allValues];
			NSMutableArray *dataArray=[[NSMutableArray alloc] initWithArray:array];
			
			if([dataArray count]!=0)
			{
				//start alert table view
				AlertTableView *alertTable=[[AlertTableView alloc] initWithTitle:@"Choose a custom" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
				[alertTable PrepareTableWithData:dataArray WithAction:@"filesystemrename" WithDelegate:self.mDelegate];
				[alertTable show];
				
				[dataArray release];
			}
			else 
			{
				m_SubMode=@"none";
				UIAlertView *noCustomAlert=[[UIAlertView alloc] initWithTitle:@"No custom" message:@"There are currently no customized list" 
																	 delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[noCustomAlert show];
				[noCustomAlert release];
			}
		}
		else if([object isKindOfClass:[NSString class]])
		{
			//user not enter name or name is existed
			NSString *message=(NSString*)object;
			
			m_SubMode=@"FileSystemRenameMode";
			
			/*
			//init an alert
			UIAlertView *blankAlert=[[UIAlertView alloc] initWithTitle:@"Rename" message:message 
															  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			
			//add a textfield to alert
			[blankAlert addTextFieldWithValue:@"" label:@"Enter new name"];
			
			//retrieve that textfield
			UITextField *mTextField=[blankAlert textFieldAtIndex:0];
			
			//adjust textfield
			[mTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
			[mTextField setKeyboardType:UIKeyboardTypeAlphabet];
			[mTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
			[mTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
			[mTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			
			[blankAlert show];
			[blankAlert release];
			*/
			
			TextFieldAlertView *blankAlert=[[TextFieldAlertView alloc] InitWithTitle:@"Blank" WithMessage:message
																		WithDelegate:self WithPlaceHolder:@"Enter pool name" WithButtons:[NSArray arrayWithObjects:@"OK", nil]];
			
			[blankAlert show];
			[blankAlert release];
			
		}
	}
	else if([command compare:@"filesystemcopy"]==0)
	{
		m_Mode=@"Copy";
		
		if(![object isKindOfClass:[NSString class]])
		{
			NSArray *array=[[(DataController*)[mDelegate m_DataController] m_CustomizePoolNameStringList] allValues];
			NSMutableArray *dataArray=[[NSMutableArray alloc] initWithArray:array];
			
			if([dataArray count]!=0)
			{
				//start alert table view
				AlertTableView *alertTable=[[AlertTableView alloc] initWithTitle:@"Choose a custom" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
				[alertTable PrepareTableWithData:dataArray WithAction:@"filesystemcopy" WithDelegate:self.mDelegate];
				[alertTable show];
				
				[dataArray release];
			}
			else 
			{
				m_SubMode=@"none";
				UIAlertView *noCustomAlert=[[UIAlertView alloc] initWithTitle:@"No custom" message:@"There are currently no customized list" 
																	 delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[noCustomAlert show];
				[noCustomAlert release];
			}
		}
		else if([object isKindOfClass:[NSString class]])
		{
			//user not enter name or name is existed
			NSString *message=(NSString*)object;
			
			m_SubMode=@"FileSystemCopyMode";
			
			/*
			//init an alert
			UIAlertView *blankAlert=[[UIAlertView alloc] initWithTitle:@"Duplicate" message:message 
															  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			
			//add a textfield to alert
			[blankAlert addTextFieldWithValue:@"" label:@"Enter new name"];
			
			//retrieve that textfield
			UITextField *mTextField=[blankAlert textFieldAtIndex:0];
			
			//adjust textfield
			[mTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
			[mTextField setKeyboardType:UIKeyboardTypeAlphabet];
			[mTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
			[mTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
			[mTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			
			[blankAlert show];
			[blankAlert release];
			*/
			
			
			TextFieldAlertView *blankAlert=[[TextFieldAlertView alloc] InitWithTitle:@"Blank" WithMessage:message
																		WithDelegate:self WithPlaceHolder:@"Enter pool name" WithButtons:[NSArray arrayWithObjects:@"OK", nil]];
			
			[blankAlert show];
			[blankAlert release];
			
		}
		
	}
	else if([command compare:@"filesystemdelete"]==0)
	{
		m_Mode=@"Delete";
		
		if(![object isKindOfClass:[NSString class]])
		{
			NSArray *array=[[(DataController*)[mDelegate m_DataController] m_CustomizePoolNameStringList] allValues];
			NSMutableArray *dataArray=[[NSMutableArray alloc] initWithArray:array];
			
			if([dataArray count]!=0)
			{
				//start alert table view
				AlertTableView *alertTable=[[AlertTableView alloc] initWithTitle:@"Choose a custom" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
				[alertTable PrepareTableWithData:dataArray WithAction:@"filesystemdelete" WithDelegate:self.mDelegate];
				[alertTable show];
				
				[dataArray release];
			}
			else 
			{
				m_SubMode=@"none";
				UIAlertView *noCustomAlert=[[UIAlertView alloc] initWithTitle:@"No custom" message:@"There are currently no customized list" 
																	 delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[noCustomAlert show];
				[noCustomAlert release];
			}
		}
		else if([object isKindOfClass:[NSString class]])
		{
			//user not enter name or name is existed
			//NSString *message=(NSString*)object;
			
			m_SubMode=@"FileSystemDeleteMode";
			
			UIAlertView *deleteAlert=[[UIAlertView alloc] initWithTitle:@"Delete" message:@"Would you like to delete this list?" 
																delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			[deleteAlert show];
			[deleteAlert release];
			
		}
		
	}
	else if([command compare:@"filesystemsortcategory"]==0)
	{
		m_Mode=@"Sort";
		//check pool has some thing to sorted
		if([(PoolView*)[mDelegate m_PoolView] m_CurrentPage]!=nil)
		{
			
			if([(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] IsPoolEmpty])
			{
				m_SubMode=@"none";
				//pool is empty
				UIAlertView *poolEmptyAlert=[[UIAlertView alloc] initWithTitle:@"Empty" message:@"There are no task or item in pool" 
																	  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[poolEmptyAlert show];
				[poolEmptyAlert release];
			}
			else 
			{
				m_SubMode=@"FileSystemSortMode";
				
				UIAlertView *sortAlert=[[UIAlertView alloc] initWithTitle:@"Sort" message:@"Would you like to sort task and item?" 
																	  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sort", nil];
				[sortAlert show];
				[sortAlert release];
			}
		}
		else 
		{
			m_SubMode=@"none";
			//no pool
			UIAlertView *noPoolAlert=[[UIAlertView alloc] initWithTitle:@"No pool" message:@"There are no pool" 
																  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[noPoolAlert show];
			[noPoolAlert release];
		}



	}
	else if([command compare:@"dropdowncreatenewmenu"]==0)
	{
		if(m_CreateNewDropDwonMenu==nil)
		{
			//create button array
			NSMutableArray *buttonArray=[[NSMutableArray alloc] init];
			
			//add button to array blank, master, sample and customize 
			DropDownMenuButton *button;
			button=[[DropDownMenuButton alloc] InitWithButtonName:@"Blank" WithDisplayName:@"Blank" WithBehaviour:YES WithAction:@"filesystemblank" WithFrame:CGRectZero WithImageFileName:@"Blank-button.png"];
			[button setMDelegate:self.mDelegate];
			[buttonArray addObject:button];
			[button release];
			
			button=[[DropDownMenuButton alloc] InitWithButtonName:@"Sample" WithDisplayName:@"Sample" WithBehaviour:YES WithAction:@"filesystemsample" WithFrame:CGRectZero WithImageFileName:@"Sample-button.png"];
			[button setMDelegate:self.mDelegate];
			[buttonArray addObject:button];
			[button release];
			
			button=[[DropDownMenuButton alloc] InitWithButtonName:@"Customize" WithDisplayName:@"Custom" WithBehaviour:YES WithAction:@"filesystemcustomize" WithFrame:CGRectZero WithImageFileName:@"Custom-button.png"];
			[button setMDelegate:self.mDelegate];
			[buttonArray addObject:button];
			[button release];
			
			//init a drop down menu
			DropDownMenu *dropDownMenu;
			dropDownMenu=[[DropDownMenu alloc] InitWithMenuName:@"CreateNew" WithTitle:@"Create From" WithButtonArray:buttonArray WithFrame:CGRectZero];
			[dropDownMenu setMDelegate:self.mDelegate];
			
			//add drop down menu to pool background view
			[(PoolBackground*)[mDelegate m_PoolBackground] addSubview:dropDownMenu];
			
			self.m_CreateNewDropDwonMenu=dropDownMenu;
			[dropDownMenu release];
			
			//tell menu to show up
			[m_CreateNewDropDwonMenu ShowMenu];
		}
		else 
		{
			NSLog(@"create new drop down menu already exist");
		}
		
	}
	/*
	else if([command compare:@"dropdownsortmenu"]==0)
	{
		if(m_SortDropDwonMenu==nil)
		{
			//create button array
			NSMutableArray *buttonArray=[[NSMutableArray alloc] init];
			
			//add button to array blank, master, sample and customize 
			DropDownMenuButton *button;
			button=[[DropDownMenuButton alloc] InitWithButtonName:@"Alphabetical" WithDisplayName:@"Alphabetical" WithBehaviour:YES WithAction:@"filesystemsortalphabetical" WithFrame:CGRectZero];
			[button setMDelegate:self.mDelegate];
			[buttonArray addObject:button];
			[button release];
			
			button=[[DropDownMenuButton alloc] InitWithButtonName:@"Category" WithDisplayName:@"Category" WithBehaviour:YES WithAction:@"filesystemsortcategory" WithFrame:CGRectZero];
			[button setMDelegate:self.mDelegate];
			[buttonArray addObject:button];
			[button release];
			
			//init a drop down menu
			DropDownMenu *dropDownMenu;
			dropDownMenu=[[DropDownMenu alloc] InitWithMenuName:@"Sort" WithTitle:@"Sort" WithButtonArray:buttonArray WithFrame:CGRectZero];
			[dropDownMenu setMDelegate:self.mDelegate];
			
			//add drop down menu to pool background view
			[(PoolBackground*)[mDelegate m_PoolBackground] addSubview:dropDownMenu];
			
			self.m_SortDropDwonMenu=dropDownMenu;
			[dropDownMenu release];
			
			//tell menu to show up
			[m_SortDropDwonMenu ShowMenu];
		}
		else 
		{
			NSLog(@"create new drop down menu already exist");
		}
	}
	 */
	else if([command compare:@"undropdowncreatenewmenu"]==0)
	{
		if(m_CreateNewDropDwonMenu!=nil)
		{
			[m_CreateNewDropDwonMenu HideMenu];
			m_CreateNewDropDwonMenu=nil;
		}
		else 
		{
			NSLog(@"no drop down menu to remove"); 
		}

	}
	else if([command compare:@"undropdownmanagelistmenu"]==0)
	{
		if(m_ManageListDropDwonMenu!=nil)
		{
			[m_ManageListDropDwonMenu HideMenu];
			m_ManageListDropDwonMenu=nil;
		}
		else 
		{
			NSLog(@"no drop down menu to remove"); 
		}
	}
	else if([command compare:@"undropdownsortmenu"]==0)
	{
		if(m_SortDropDwonMenu!=nil)
		{
			[m_SortDropDwonMenu HideMenu];
			m_SortDropDwonMenu=nil;
		}
		else 
		{
			NSLog(@"no drop down menu to remove"); 
		}
	}


}

-(void)ClearDropDownMenu
{
	
	if(m_CreateNewDropDwonMenu!=nil)
	{
		[m_CreateNewDropDwonMenu HideMenu];
		m_CreateNewDropDwonMenu=nil;
	}
	else 
	{
		NSLog(@"no drop down menu to remove"); 
	}
	
	if(m_ManageListDropDwonMenu!=nil)
	{
		[m_ManageListDropDwonMenu HideMenu];
		m_ManageListDropDwonMenu=nil;
	}
	else 
	{
		NSLog(@"no drop down menu to remove"); 
	}
	
	if(m_SortDropDwonMenu!=nil)
	{
		[m_SortDropDwonMenu HideMenu];
		m_SortDropDwonMenu=nil;
	}
	else 
	{
		NSLog(@"no drop down menu to remove"); 
	}
}



//alert delegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if([m_Mode compare:@"ResetMode"]==0)
	{
		if(buttonIndex==1)
		{
			
			HUDView *HUD=[[HUDView alloc] InitWithWindow:[mDelegate window]];
			self.m_HUD=HUD;
			[HUD release];
			
			[m_HUD SetText:@"Please wait"];
			[m_HUD Show:YES];
			
			
			
			NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
			
			NSOperationQueue *operationQueue=[NSOperationQueue new];
			
			[pool release];
			
			//NSInvocationOperation *startHUD=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(StartHUD) object:nil];
			NSInvocationOperation *reset=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(Reset) object:nil];
			
			//[operationQueue addOperation:startHUD];
			[operationQueue addOperation:reset];
			
			//[startHUD release];
			[reset release];
			
		}
	}
	else if([m_Mode compare:@"QuantityMode"]==0)
	{
		if([m_SubMode compare:@"QuantityAskMode"]==0)
		{
			if(buttonIndex==1)
			{
				//get back text
				UITextField *mTextField=[(TextFieldAlertView*)alertView m_TextField];
				[mTextField resignFirstResponder];
				
				if([mTextField.text compare:@""]==0 || [mTextField.text integerValue]<1 || [mTextField.text integerValue]>99)
				{
					[self StartUtilityWithCommand:@"Quantity" WithObject:[NSString stringWithString:@"Please enter vaild number"]];
				}
				else 
				{
					int quantityValue=[mTextField.text intValue];
					[m_QuantityPoolIcon SetQuantity:quantityValue];
				}
			}
		}
		else if([m_SubMode compare:@"QuantityInvaildMode"]==0)
		{
			if(buttonIndex==0)
			{
				[self StartUtilityWithCommand:@"Quantity" WithObject:m_QuantityPoolIcon];
			}
		}
	}
	else if([m_Mode compare:@"Blank"]==0)
	{
		if([m_SubMode compare:@"FileSystemBlankMode"]==0)
		{
			if(buttonIndex==1)
			{
				//get back text
				UITextField *mTextField=[(TextFieldAlertView*)alertView m_TextField];
				[mTextField resignFirstResponder];
				
				if([mTextField.text compare:@""]==0)
				{
					//user enter no name
					[self StartUtilityWithCommand:@"filesystemblank" WithObject:[NSString stringWithString:@"Name can not be blank"]];
				}
				else 
				{
					//user enter name
					//check the name that user enter is used or not
					if([[mDelegate m_DataController] IsPoolNameExist:mTextField.text])
					{
						//name is exist
						//user enter no name
						[self StartUtilityWithCommand:@"filesystemblank" WithObject:[NSString stringWithString:@"Name is exist please enter vaild name"]];
					}
					else 
					{ 
						
						HUDView *HUD=[[HUDView alloc] InitWithWindow:[mDelegate window]];
						self.m_HUD=HUD;
						[HUD release];
						
						[m_HUD SetText:@"Please wait"];
						[m_HUD Show:YES];
						
						
						
						NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
						
						NSOperationQueue *operationQueue=[NSOperationQueue new];
						
						[pool release];
						
						//NSInvocationOperation *startHUD=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(StartHUD) object:nil];
						NSInvocationOperation *createBlankPool=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(CreateBlankPool:) object:mTextField.text];
						
						//[operationQueue addOperation:startHUD];
						[operationQueue addOperation:createBlankPool];
						
						//[startHUD release];
						[createBlankPool release];
						
						//tell menu scroll to item
						[(MenuView*)[mDelegate m_MenuView] ScrollToByMenuIndex:2 WithSubMenuIndex:3];

					}
					
					
				}
			}
		}
		else if([m_SubMode compare:@"FileSystemDiscardMode"]==0)
		{
			if(buttonIndex==1)
			{
				[(PoolView*)[mDelegate m_PoolView] CloseCurrentPool];
				[(PoolView*)[mDelegate m_PoolView] ShouldShowEmpty];
				[self StartUtilityWithCommand:@"filesystemblank" WithObject:nil];
			}
		}
		
	}
	else if([m_Mode compare:@"Master"]==0) 
	{
		if([m_SubMode compare:@"FileSystemMasterBlankMode"]==0)
		{
			if(buttonIndex==1)
			{
				//get back text
				UITextField *mTextField=[(TextFieldAlertView*)alertView m_TextField];
				[mTextField resignFirstResponder];
				
				if([mTextField.text compare:@""]==0)
				{
					//user enter no name
					[self StartUtilityWithCommand:@"filesystemmaster" WithObject:[NSString stringWithString:@"Name can not be blank"]];
				}
				else 
				{
					//user enter name
					//check the name that user enter is used or not
					if([[mDelegate m_DataController] IsPoolNameExist:mTextField.text])
					{
						//name is exist
						//user enter no name
						[self StartUtilityWithCommand:@"filesystemmaster" WithObject:[NSString stringWithString:@"Name is exist please enter vaild name"]];
					}
					else 
					{ 
						
						HUDView *HUD=[[HUDView alloc] InitWithWindow:[mDelegate window]];
						self.m_HUD=HUD;
						[HUD release];
						
						[m_HUD SetText:@"Please wait"];
						[m_HUD Show:YES];
						
						
						NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
						
						NSOperationQueue *operationQueue=[NSOperationQueue new];
						
						[pool release];
						
						//NSInvocationOperation *startHUD=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(StartHUD) object:nil];
						NSInvocationOperation *masterPool=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(MasterPool:) object:mTextField.text];
						
						//[operationQueue addOperation:startHUD];
						[operationQueue addOperation:masterPool];
						
						//[startHUD release];
						[masterPool release];
						
					}
					
					
				}
			}
		}
		else if([m_SubMode compare:@"FileSystemMasterDiscardMode"]==0)
		{
			if(buttonIndex==1)
			{
				[(PoolView*)[mDelegate m_PoolView] CloseCurrentPool];
				[(PoolView*)[mDelegate m_PoolView] ShouldShowEmpty];
				[self StartUtilityWithCommand:@"filesystemmaster" WithObject:nil];
			}
		}

	}
	else if([m_Mode compare:@"Sample"]==0)
	{
		if([m_SubMode compare:@"FileSystemSampleBlankMode"]==0)
		{
			if(buttonIndex==1)
			{
				//get back text
				UITextField *mTextField=[(TextFieldAlertView*)alertView m_TextField];
				[mTextField resignFirstResponder];
				
				if([mTextField.text compare:@""]==0)
				{
					//user enter no name
					[self StartUtilityWithCommand:@"filesystemsample" WithObject:[NSString stringWithString:@"Name can not be blank"]];
				}
				else 
				{
					//user enter name
					//check the name that user enter is used or not
					if([[mDelegate m_DataController] IsPoolNameExist:mTextField.text])
					{
						//name is exist
						//user enter no name
						[self StartUtilityWithCommand:@"filesystemsample" WithObject:[NSString stringWithString:@"Name is exist please enter vaild name"]];
					}
					else 
					{
						
						HUDView *HUD=[[HUDView alloc] InitWithWindow:[mDelegate window]];
						self.m_HUD=HUD;
						[HUD release];
						
						[m_HUD SetText:@"Please wait"];
						[m_HUD Show:YES];
						
						
						
						NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
						
						NSOperationQueue *operationQueue=[NSOperationQueue new];
						
						[pool release];
						
						//NSInvocationOperation *startHUD=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(StartHUD) object:nil];
						NSInvocationOperation *samplePool=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(SamplePool:) object:mTextField.text];
						
						//[operationQueue addOperation:startHUD];
						[operationQueue addOperation:samplePool];
						
						//[startHUD release];
						[samplePool release];
						
						//tell menu scroll to item
						[(MenuView*)[mDelegate m_MenuView] ScrollToByMenuIndex:2 WithSubMenuIndex:3];
						

					}
					
					
				}
			}
		}
		else if([m_SubMode compare:@"FileSystemSampleDiscardMode"]==0)
		{
			if(buttonIndex==1)
			{
				[(PoolView*)[mDelegate m_PoolView] CloseCurrentPool];
				[(PoolView*)[mDelegate m_PoolView] ShouldShowEmpty];
				[self StartUtilityWithCommand:@"filesystemsample" WithObject:nil];
			}
		}
	}
	else if([m_Mode compare:@"Custom"]==0)
	{
		if([m_SubMode compare:@"FileSystemCustomBlankMode"]==0)
		{
			if(buttonIndex==1)
			{
				//get back text
				UITextField *mTextField=[(TextFieldAlertView*)alertView m_TextField];
				[mTextField resignFirstResponder];
				
				if([mTextField.text compare:@""]==0)
				{
					//user enter no name
					[self StartUtilityWithCommand:@"filesystemcustomize" WithObject:[NSString stringWithString:@"Name can not be blank"]];
				}
				else 
				{
					//user enter name
					//check the name that user enter is used or not
					if([[mDelegate m_DataController] IsPoolNameExist:mTextField.text])
					{
						//name is exist
						//user enter no name
						[self StartUtilityWithCommand:@"filesystemcustomize" WithObject:[NSString stringWithString:@"Name is exist please enter vaild name"]];
					}
					else 
					{
						
						HUDView *HUD=[[HUDView alloc] InitWithWindow:[mDelegate window]];
						self.m_HUD=HUD;
						[HUD release];
						
						[m_HUD SetText:@"Please wait"];
						[m_HUD Show:YES];
						
						NSArray *array=[[(DataController*)[mDelegate m_DataController] m_CustomizePoolNameStringList] allValues];
						NSString *customPoolName=[array objectAtIndex:m_Index];
						
						NSArray *nameList=[[NSArray alloc] initWithObjects:customPoolName, mTextField.text, nil];
						
						
						NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
						
						NSOperationQueue *operationQueue=[NSOperationQueue new];
						
						[pool release];
						
						//NSInvocationOperation *startHUD=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(StartHUD) object:nil];
						NSInvocationOperation *createCustomPool=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(CreateCustomPool:) object:nameList];
						
						//[operationQueue addOperation:startHUD];
						[operationQueue addOperation:createCustomPool];
						
						//[startHUD release];
						[createCustomPool release];
						
						
						//tell menu scroll to item
						[(MenuView*)[mDelegate m_MenuView] ScrollToByMenuIndex:2 WithSubMenuIndex:3];
						
					}
					
					
				}
			}
		}
		else if([m_SubMode compare:@"FileSystemCustomDiscardMode"]==0)
		{
			if(buttonIndex==1)
			{
				[(PoolView*)[mDelegate m_PoolView] CloseCurrentPool];
				[(PoolView*)[mDelegate m_PoolView] ShouldShowEmpty];
				[self StartUtilityWithCommand:@"filesystemcustomize" WithObject:nil];
			}
		}
	}
	else if([m_Mode compare:@"Edit"]==0)
	{
		if([m_SubMode compare:@"FileSystemEditDiscardMode"]==0)
		{
			if(buttonIndex==1)
			{
				[(PoolView*)[mDelegate m_PoolView] CloseCurrentPool];
				[(PoolView*)[mDelegate m_PoolView] ShouldShowEmpty];
				[self StartUtilityWithCommand:@"filesystemedit" WithObject:nil];
			}
		}
	}
	else if([m_Mode compare:@"Rename"]==0)
	{
		if([m_SubMode compare:@"FileSystemRenameMode"]==0)
		{
			
			//get back text
			UITextField *mTextField=[(TextFieldAlertView*)alertView m_TextField];
			NSString *newName=mTextField.text;
			[mTextField resignFirstResponder];
			
			if(buttonIndex==1)
			{
				if([mTextField.text compare:@""]==0)
				{
					//user enter no name
					[self StartUtilityWithCommand:@"filesystemrename" WithObject:[NSString stringWithString:@"Name can not be blank"]];
				}
				else 
				{
					//user enter name
					//check the name that user enter is used or not
					if([[mDelegate m_DataController] IsPoolNameExist:mTextField.text])
					{
						//name is exist
						//user enter no name
						[self StartUtilityWithCommand:@"filesystemrename" WithObject:[NSString stringWithString:@"Name is exist please enter vaild name"]];
					}
					else 
					{
						
						NSArray *array=[[(DataController*)[mDelegate m_DataController] m_CustomizePoolNameStringList] allValues];
						NSString *previousName=[array objectAtIndex:m_Index];
						
						
						
						[self Rename:previousName WithNewName:newName];
					}
				}
				
			}
			

		}
	}
	else if([m_Mode compare:@"Copy"]==0)
	{
		if([m_SubMode compare:@"FileSystemCopyMode"]==0)
		{
			
			//get back text
			UITextField *mTextField=[(TextFieldAlertView*)alertView m_TextField];
			[mTextField resignFirstResponder];
			
			if(buttonIndex==1)
			{
				if([mTextField.text compare:@""]==0)
				{
					//user enter no name
					[self StartUtilityWithCommand:@"filesystemcopy" WithObject:[NSString stringWithString:@"Name can not be blank"]];
				}
				else 
				{
					//user enter name
					//check the name that user enter is used or not
					if([[mDelegate m_DataController] IsPoolNameExist:mTextField.text])
					{
						//name is exist
						//user enter no name
						[self StartUtilityWithCommand:@"filesystemcopy" WithObject:[NSString stringWithString:@"Name is exist please enter vaild name"]];
					}
					else 
					{
						
						NSArray *array=[[(DataController*)[mDelegate m_DataController] m_CustomizePoolNameStringList] allValues];
						NSString *sourceName=[array objectAtIndex:m_Index];
						
						NSString *newName=mTextField.text;
						
						[self Copy:sourceName WithNewName:newName];
						
					}
				}
			}
			

		}
	}
	else if([m_Mode compare:@"Delete"]==0)
	{
		if([m_SubMode compare:@"FileSystemDeleteMode"]==0)
		{
			
			if(buttonIndex==1)
			{
				NSArray *array=[[(DataController*)[mDelegate m_DataController] m_CustomizePoolNameStringList] allValues];
				NSString *tableName=[array objectAtIndex:m_Index];
				
				[self DeletePool:tableName];
			}
		}
	}
	else if([m_Mode compare:@"Sort"]==0)
	{
		if([m_SubMode compare:@"FileSystemSortMode"]==0)
		{
			
			if(buttonIndex==1)
			{
				
				HUDView *HUD=[[HUDView alloc] InitWithWindow:[mDelegate window]];
				self.m_HUD=HUD;
				[HUD release];
				
				[m_HUD SetText:@"Please wait"];
				[m_HUD Show:YES];
				
				NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
				
				NSOperationQueue *operationQueue=[NSOperationQueue new];
				
				[pool release];
				
				//NSInvocationOperation *startHUD=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(StartHUD) object:nil];
				NSInvocationOperation *sortPool=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(SortPool) object:nil];
				
				//[operationQueue addOperation:startHUD];
				[operationQueue addOperation:sortPool];
				
				//[startHUD release];
				[sortPool release];
				
			
			}
			else if(buttonIndex==0)
			{
				//bring each scrollview's detection view to top
				[(MenuBackground*)[mDelegate m_MenuBackground] BringDropDownDetectionViewtoBack];
				[(ItemBackground*)[mDelegate m_ItemBackground] BringDropDownDetectionViewtoBack];
				[(PoolBackground*)[mDelegate m_PoolBackground] BringDropDownDetectionViewtoBack];
			}
		}
	}

}

-(void)Reset
{
	
	//reset menu
	[(MenuView*)[mDelegate m_MenuView] Reset];
	
	//reset item view
	[(ItemView*)[mDelegate m_ItemView] Reset];
	
	//info bar
	[(InformationBar*)[mDelegate m_InfoBar] Reset];
	
	//two border on top right
	[(TopRightBorder*)[mDelegate m_TopRightBorder] Reset];
	[(TopRightBorder2*)[mDelegate m_TopRightBorder2] Reset];
	
	//reset pool
	[(PoolView*)[mDelegate m_PoolView] Reset];
	[(PoolView*)[mDelegate m_PoolView] CloseCurrentPool];
	[(PoolView*)[mDelegate m_PoolView] ShouldShowEmpty];
	
	[self KillHUD];
	
	
}

-(void)CreateBlankPool:(NSString*)name;
{
	//name is not exist
	//deal with database make database to create a new table by given name
	[(DataController*)[mDelegate m_DataController] CreateNewPoolTable:name];
	
	//create new pool for visual
	[(PoolView*)[mDelegate m_PoolView] CreateNewPoolWithName:name];
	
	[self KillHUD];
	
	
}

-(void)MasterPool:(NSString*)name
{
	//name is not exist
	//deal with database make database to create a new table by given name
	[(DataController*)[mDelegate m_DataController] CreateNewPoolTable:name];
	
	//create new pool for visual
	[(PoolView*)[mDelegate m_PoolView] CreateNewPoolWithName:name];
	
	//tell item view put all task and item to pool
	[(ItemView*)[mDelegate m_ItemView] TransferAllIconsToPool];
	
	[self KillHUD];
	
	
}

-(void)SamplePool:(NSString*)name
{
	//name is not exist
	//deal with database make database to create a new table by given name
	[(DataController*)[mDelegate m_DataController] CreateNewPoolTable:name];
	
	//create new pool for visual
	[(PoolView*)[mDelegate m_PoolView] CreateNewPoolWithName:name];
	
	//get back sample table name
	NSString *sampleTableName=[[(DataController*)[mDelegate m_DataController] m_SampleListNameStrinList] objectAtIndex:m_Index];
	
	//tell item view to put sample to pool by given a table name
	[(ItemView*)[mDelegate m_ItemView] TransferSampleToPoolWithSampleTableName:sampleTableName];
	
	[self KillHUD];
	
	
}

-(void)CreateCustomPool:(NSArray*)nameList
{
	NSString *sourceName=[nameList objectAtIndex:0];
	NSString *newName=[nameList objectAtIndex:1];

	//name is not exist
	//deal with database make database to create a new table by given name
	[(DataController*)[mDelegate m_DataController] CreateNewPoolTable:newName];
	
	//load custom pool by first create a pool by given name
	//create new pool for visual since this pool is load from custom so no needed to deal with database
	[(PoolView*)[mDelegate m_PoolView] CreateNewPoolWithName:newName];
	
	//tell item view to tansfer icon from tiem page view to pool
	[(ItemView*)[mDelegate m_ItemView] TransferIconToPoolWithCustomTableName:sourceName];
	
	[nameList release];
	
	[self KillHUD];
	
	
}

-(void)EditCustomPool:(NSString*)name
{
	[(PoolView*)[mDelegate m_PoolView] setM_SavedOn:NO];
	
	[(PoolView*)[mDelegate m_PoolView] CreateNewPoolWithName:name];
	
	[(ItemView*)[mDelegate m_ItemView] TransferIconToPoolWithCustomTableName:name];
	
	[(PoolView*)[mDelegate m_PoolView] setM_SavedOn:YES];
	
	[self KillHUD];
	
	
}

-(void)Rename:(NSString*)previousName WithNewName:(NSString*)newName
{
	//tell database to rename
	[(DataController*)[mDelegate m_DataController] RenameCustomPoolTable:previousName WithNewName:newName];
	
	//check if need to change name of pool that user currently using
	if([[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] m_PageName] compare:previousName]==0)
	{
		[[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] setM_PageName:newName];
	}
}

-(void)Copy:(NSString*)sourceName WithNewName:(NSString*)newName
{
	//tell database to copy
	[(DataController*)[mDelegate m_DataController] DuplicatePoolTable:sourceName WithNewName:newName];
}

-(void)DeletePool:(NSString*)name
{
	//tell database to delete
	[(DataController*)[mDelegate m_DataController] DeletePoolTable:name];
	
	//check if user current page is same as delete one 
	if([[(PoolPageView*)[(PoolView*)[mDelegate m_PoolView] m_CurrentPage] m_PageName] compare:name]==0)
	{
		[(PoolView*)[mDelegate m_PoolView] CloseCurrentPoolWithoutUpdateIcon];
		[(PoolView*)[mDelegate m_PoolView] ShouldShowEmpty];
	}
}

-(void)SortPool
{
	[(PoolView*)[mDelegate m_PoolView] SortCurrentPool];
	
	//bring each scrollview's detection view to top
	[(MenuBackground*)[mDelegate m_MenuBackground] BringDropDownDetectionViewtoBack];
	[(ItemBackground*)[mDelegate m_ItemBackground] BringDropDownDetectionViewtoBack];
	[(PoolBackground*)[mDelegate m_PoolBackground] BringDropDownDetectionViewtoBack];
	
	[self KillHUD];
	
	
}

-(void)LoadCustomPool:(NSString*)name
{
	
	HUDView *HUD=[[HUDView alloc] InitWithWindow:[mDelegate window]];
	self.m_HUD=HUD;
	[HUD release];
	
	[m_HUD SetText:@"Please wait"];
	[m_HUD Show:YES];
	
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	
	NSOperationQueue *operationQueue=[NSOperationQueue new];
	
	[pool release];
	
	//NSInvocationOperation *startHUD=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(StartHUD) object:nil];
	NSInvocationOperation *editCustomPool=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(EditCustomPool:) object:name];
	
	//[operationQueue addOperation:startHUD];
	[operationQueue addOperation:editCustomPool];
	
	//[startHUD release];
	[editCustomPool release];
	
}

-(void)StartHUD
{
	[m_HUD Show:YES];
}

-(void)KillHUD
{
	[m_HUD Show:NO];
	self.m_HUD=nil;
}

- (void)dealloc {
	
	if(m_ImportPhotoFunction!=nil)
	{
		self.m_ImportPhotoFunction=nil;
	}
	
	if(m_CreateNewDropDwonMenu!=nil)
	{
		[m_CreateNewDropDwonMenu removeFromSuperview];
		self.m_CreateNewDropDwonMenu=nil;
	}
	
	if(m_ManageListDropDwonMenu!=nil)
	{
		[m_ManageListDropDwonMenu removeFromSuperview];
		self.m_ManageListDropDwonMenu=nil;
	}
	
	if(m_SortDropDwonMenu!=nil)
	{
		[m_SortDropDwonMenu removeFromSuperview];
		self.m_SortDropDwonMenu=nil;
	}
	
	
    [super dealloc];
}

@end
