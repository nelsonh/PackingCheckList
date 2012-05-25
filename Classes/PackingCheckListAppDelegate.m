//
//  PackingCheckListAppDelegate.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/3/29.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PackingCheckListAppDelegate.h"
#import "MainBackground.h"
#import "PoolView.h"
#import "ImportPhotoImageView.h"
#import "PoolBackground.h"
#import "WallpaperView.h"
#import "ItemView.h"
#import "ItemPageView.h"
#import "InformationBar.h"
#import "MenuView.h"
#import "MenuBorder.h"
#import "MenuBackground.h"
#import "ItemBorder.h"
#import "ItemBackground.h"
#import "TopRightBorder.h"
#import "TopRightBorder2.h"
#import "DataController.h"
#import "Utility.h"
#import <AudioToolbox/AudioToolbox.h>
#import "LoadingProgressBar.h"
#import "PoolPageView.h"
#import "MenuPageView.h"
#import "UserConfigDataPackage.h"



@implementation PackingCheckListAppDelegate

@synthesize window;
@synthesize m_MainBackground;

@synthesize m_PoolView;
@synthesize m_ImportPhotoImageView;
@synthesize m_PoolBackground;
@synthesize m_WallpaperView;
@synthesize m_ItemView;
@synthesize m_InfoBar;
@synthesize m_MenuView;
@synthesize m_MenuBorder;
@synthesize m_MenuBackground;
@synthesize m_ItemBorder;
@synthesize m_ItemBackground;
@synthesize m_TopRightBorder;
@synthesize m_TopRightBorder2;

@synthesize m_DataController;
@synthesize m_Utility;

@synthesize m_LastAcceleration;

@synthesize m_DeviceModel;
@synthesize m_DeviceName;
@synthesize m_DeviceOperationSystem;
@synthesize m_DeviceOSVersion;
@synthesize m_DeviceLocalizeModel;
@synthesize m_DeviceUniqueIdentifier;

@synthesize m_LoadingImage;


-(void)BringInformationBarToTop
{
	[m_InfoBar.superview bringSubviewToFront:m_InfoBar];
}

-(void)BringMenuToTop
{
	[m_MenuBackground.superview bringSubviewToFront:m_MenuBackground];
	[m_TopRightBorder.superview bringSubviewToFront:m_TopRightBorder];
	[m_TopRightBorder2.superview bringSubviewToFront:m_TopRightBorder2];
}

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	if(self.m_LastAcceleration)
	{
		[self ShackCheck:self.m_LastAcceleration WithCurrentAcceleration:acceleration WithThreshold:1.0];
	}
	

	
	self.m_LastAcceleration=acceleration;
}

-(void)ShackCheck:(UIAcceleration*)lastAcceleration WithCurrentAcceleration:(UIAcceleration*)currentAcceleration WithThreshold:(double)threshold
{
	if([m_PoolView m_CurrentPage]!=nil)
	{
		if(![(PoolPageView*)[m_PoolView m_CurrentPage] IsPoolEmpty])
		{
			if([(PoolPageView*)[m_PoolView m_CurrentPage] IsAnyIconChecked])
			{
				double deltaY=fabs(lastAcceleration.y-currentAcceleration.y);
				
				if(deltaY>threshold && isAlertOn==NO)
				{
					//vibrate iphone
					AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
					
					m_Mode=@"Shack";
					
					UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil 
																  message:@"Are you sure you want to unchecke all the items and tasks?" delegate:self 
														cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No", nil];
					
					//make buttons line up as coloumn
					[alert show];
					[alert release];
					
					isAlertOn=YES;
				}
			}

		}
	}

	/*
	if(fabs(lastAcceleration.y-currentAcceleration.y)>threshold)
	{
		s+=1;
	}
	
	if(s==3)
	{
		s=0;
		sImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
		[sImage setImage:[UIImage imageNamed:@"s.jpg"]];
		[sImage setAlpha:1.0f];
		[window addSubview:sImage];
		
		[UIView beginAnimations:@"Ease in" context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDuration:7.0f];
		[UIView setAnimationDidStopSelector:@selector(Bound)];
		
		[sImage setAlpha:0.0f];
		
		[UIView commitAnimations];
	}

	*/

}

/*
-(void)Bound
{
	[sImage removeFromSuperview];
	[sImage release];
}
*/

-(void)RetrieveDeviceInformation
{
	UIDevice *mDevice=[UIDevice currentDevice];
	m_DeviceModel=[mDevice.model retain];
	m_DeviceName=[mDevice.name retain];
	m_DeviceOperationSystem=[mDevice.systemName retain];
	m_DeviceOSVersion=[mDevice.systemVersion retain];
	m_DeviceLocalizeModel=[mDevice.localizedModel retain];
	m_DeviceUniqueIdentifier=[mDevice.uniqueIdentifier retain];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
	if([m_Mode compare:@"Shack"]==0)
	{
		if(buttonIndex==0)
		{
			[m_PoolView UnCheckAllIconsInPageView];
			isAlertOn=NO;
		}	
		else if(buttonIndex==1) 
		{
			
			isAlertOn=NO;
		}
	}
	else if([m_Mode compare:@"NoCustom"]==0)
	{
		if(buttonIndex==1)
		{
			//blank
			[m_Utility StartUtilityWithCommand:@"filesystemblank" WithObject:nil];
		}
		else if(buttonIndex==2)
		{
			//master
			[m_Utility StartUtilityWithCommand:@"filesystemmaster" WithObject:nil];
		}
		else if(buttonIndex==3) 
		{
			//sample
			[m_Utility StartUtilityWithCommand:@"filesystemsample" WithObject:nil];
		}


	}
}

-(void)LoadApp
{

	/*----------------------------------retrieve user's iphone information------------------------------------*/
	[self RetrieveDeviceInformation];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}
	/*----------------------------------retrieve user's iphone information------------------------------------*/
	
	
	/*----------------------------------data controller init------------------------------------*/
	m_DataController=[[DataController alloc] InitDataControllerWithDatabaseWithDelegate:self];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}

	
	/*----------------------------------data controller init------------------------------------*/
	
	
	/*----------------------------------Utility init------------------------------------*/
	
	m_Utility=[Utility alloc];
	[m_Utility setMDelegate:self];
	[m_Utility InitUtility];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}

	
	/*----------------------------------Utility init------------------------------------*/
	
	
	/*----------------------------------init background------------------------------------*/
	
	m_MainBackground=[MainBackground alloc];
	[m_MainBackground setMDelegate:self];
	[m_MainBackground initWithFrame:CGRectMake(0, 0, 320, 480)];
	
	[window addSubview:m_MainBackground];
	[m_MainBackground release];
	
	[m_MainBackground setAlpha:0];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}

	
	/*----------------------------------init background------------------------------------*/
	
    
	/*----------------------------------pool view init------------------------------------*/
	//init pool background
	m_PoolBackground=[PoolBackground alloc];
	
	[m_PoolBackground setMDelegate:self];
	[m_PoolBackground initWithFrame:CGRectMake(0, 120, 240, 360)];
	
	[m_MainBackground addSubview:m_PoolBackground];
	[m_PoolBackground release];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}
	
	//init wallpaper view
	m_WallpaperView=[WallpaperView alloc];
	
	[m_WallpaperView setMDelegate:self];
	[m_WallpaperView initWithFrame:CGRectMake(0, 0, 240, 360)];
	
	[m_PoolBackground addSubview:m_WallpaperView];
	[m_WallpaperView release];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}
	
	
	//init import photo image view
	//this view only for user to view the photo they take it from camera or photo library
	m_ImportPhotoImageView=[ImportPhotoImageView alloc];
	
	[m_ImportPhotoImageView setMDelegate:self];
	[m_ImportPhotoImageView initWithFrame:CGRectMake(0, 0, 240, 360)];
	
	[m_PoolBackground addSubview:m_ImportPhotoImageView];
	[m_ImportPhotoImageView release];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}
	
	//init pool view
	m_PoolView=[PoolView alloc];
	
	[m_PoolView setMDelegate:self];
	[m_PoolView initWithFrame:CGRectMake(0, 0, 240, 360)];
	
	[m_PoolBackground addSubview:m_PoolView];
	[m_PoolView release];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}

	
	/*----------------------------------pool view init------------------------------------*/
	
	
	
	/*----------------------------------item init------------------------------------*/
	//init item background
	m_ItemBackground=[ItemBackground alloc];
	[m_ItemBackground setMDelegate:self];
	[m_ItemBackground initWithFrame:CGRectMake(240, 20, 80, 460)];
	
	[m_MainBackground addSubview:m_ItemBackground];
	[m_ItemBackground release];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}
	
	//init item border
	m_ItemBorder=[ItemBorder alloc];
	[m_ItemBorder setMDelegate:self];
	[m_ItemBorder initWithFrame:CGRectMake(0, 100, 80, 360)];
	
	[m_ItemBackground addSubview:m_ItemBorder];
	[m_ItemBorder release];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}
	
	//init item view
	m_ItemView=[ItemView alloc];
	
	[m_ItemView setMDelegate:self];
	[m_ItemView initWithFrame:CGRectMake(4, 100, 80-8, 360-4)];
	[m_ItemBackground addSubview:m_ItemView];
	[m_ItemView release];
	
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}

	
	
	/*----------------------------------item init------------------------------------*/
	
	
	/*----------------------------------menu init------------------------------------*/
	//init menu background
	m_MenuBackground=[MenuBackground alloc];
	[m_MenuBackground setMDelegate:self];
	[m_MenuBackground initWithFrame:CGRectMake(0, 20, 320, 80)];
	
	[m_MainBackground addSubview:m_MenuBackground];
	[m_MenuBackground release];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}
	
	//init menu border
	m_MenuBorder=[MenuBorder alloc];
	[m_MenuBorder setMDelegate:self];
	[m_MenuBorder initWithFrame:CGRectMake(0, 0, 320, 80)];
	
	[m_MenuBackground addSubview:m_MenuBorder];
	[m_MenuBorder release];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}
	
	//init menu view
	m_MenuView=[MenuView alloc];
	[m_MenuView setMDelegate:self];
	[m_MenuView initWithFrame:CGRectMake(0, 0, 320, 80)];
	
	[m_MenuBackground addSubview:m_MenuView];
	[m_MenuView release];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}

	/*----------------------------------menu init------------------------------------*/
	
	
	
	
	
	/*----------------------------------information bar init------------------------------------*/
	//init information bar
	m_InfoBar=[InformationBar alloc];
	[m_InfoBar setMDelegate:self];
	[m_InfoBar initWithFrame:CGRectMake(0, 100, 320, 20)];
	
	[m_MainBackground addSubview:m_InfoBar];
	[m_InfoBar release];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}

	
	/*----------------------------------information bar init------------------------------------*/
	
	/*----------------------------------top right border init------------------------------------*/
	//init top right border
	m_TopRightBorder=[TopRightBorder alloc];
	[m_TopRightBorder setMDelegate:self];
	[m_TopRightBorder initWithFrame:CGRectMake(240, 20, 4, 100)];
	
	[m_MainBackground addSubview:m_TopRightBorder];
	[m_TopRightBorder release];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}

	
	/*----------------------------------top right border init------------------------------------*/
	
	/*----------------------------------top right border2 init------------------------------------*/
	//init top right border
	m_TopRightBorder2=[TopRightBorder2 alloc];
	[m_TopRightBorder2 setMDelegate:self];
	[m_TopRightBorder2 initWithFrame:CGRectMake(316, 20, 4, 100)];
	
	[m_MainBackground addSubview:m_TopRightBorder2];
	[m_TopRightBorder2 release];
	
	if(LoadingProgressView!=NO)
	{
		
		[m_LoadingProgressBar SetProgress:0.17];
		
		[NSThread detachNewThreadSelector:@selector(UpdateProgressBar)toTarget:self withObject:nil];
	}
	

	
	/*----------------------------------top right border2 init------------------------------------*/

	//test
	zoom=NO;
	
	//[m_ItemView UpdateItemView];
	
	
	[window setBackgroundColor:[UIColor yellowColor]];
	
	
	if(!LoadingProgressView)
	{
		[m_LoadingActivity stopAnimating];
		[m_LoadingActivity removeFromSuperview];
		[m_LoadingActivity release];
		m_LoadingActivity=nil;
	}
	else 
	{
		[m_LoadingProgressBar removeFromSuperview];
		[m_LoadingProgressBar release];
		m_LoadingProgressBar=nil;
	}



	
	[UIView beginAnimations:nil  context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:3.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(LoadingImageFadeOut)];
	
	[m_LoadingImage setAlpha:0];
	[m_MainBackground setAlpha:1];
	
	[UIView commitAnimations];
	
	
}

-(void)LoadingImageFadeOut
{
	[m_LoadingImage removeFromSuperview];
	[m_LoadingImage release];
	
	m_LoadingImage=nil;
	
	NSMutableArray *pageContainer=[m_MenuView m_PageContainer];
	
	/*
	for(int i=0; i<[pageContainer count]; i++)
	{
		MenuPageView *pageView=[pageContainer objectAtIndex:i];
		
		[pageView Presentation:3];
	}
	 */
	if([m_DataController GetAppUsedTime]==0)
	{
		int appUsedTime=[m_DataController GetAppUsedTime]+1;
		
		//user first time use app
		
		[m_MenuView ScrollToHelp:0];
		
		[m_DataController UpdateAppUsedTime:appUsedTime];
	}
	else 
	{
		int appUsedTime=[m_DataController GetAppUsedTime]+1;
		
		for(int i=0; i<[pageContainer count]; i++)
		{
			MenuPageView *pageView=[pageContainer objectAtIndex:i];
			
			[pageView Presentation:3];
		}
		

		
		[self LoadUserConfig];
		
		[m_DataController UpdateAppUsedTime:appUsedTime];
	}
}

-(void)UpdateProgressBar
{
	[m_LoadingProgressBar UpdateProgress];
	
	[NSThread exit];
}

-(void)LoadUserConfig
{
	// get user config data package
	UserConfigDataPackage *userConfig=[m_DataController GetUserConfig];
	
	//load menu border
	if([[userConfig m_MenuBorder] compare:@"none"]==0)
	{
		NSLog(@"no menu border config");
	}
	else 
	{
		[m_MenuBorder ChangeBorderImage:[userConfig m_MenuBorder]];
	}
	
	//load menu background
	if([[userConfig m_MenuBackground] compare:@"none"]==0)
	{
		NSLog(@"no menu background config");
	}
	else 
	{
		[m_MenuBackground ChangeBackgroundImage:[userConfig m_MenuBackground]];
	}
	
	//load info bar background
	if([[userConfig m_InfoBarBackground] compare:@"none"]==0)
	{
		NSLog(@"no info bar background config");
	}
	else 
	{
		[m_InfoBar ChangeBackgroundImage:[userConfig m_InfoBarBackground]];
	}
	
	//load item border
	if([[userConfig m_ItemBorder] compare:@"none"]==0)
	{
		NSLog(@"no item border config");
	}
	else 
	{
		[m_ItemBorder ChangeBorderImage:[userConfig m_ItemBorder]];
	}
	
	//load item background
	if([[userConfig m_ItemBorder] compare:@"none"]==0)
	{
		NSLog(@"no item background config");
	}
	else 
	{
		[m_ItemBackground ChangeBackgroundImage:[userConfig m_ItemBackground]];
	}
	
	//load wallpaper
	if([[userConfig m_Wallpaper] compare:@"none"]==0)
	{
		NSLog(@"no item background config");
	}
	else 
	{
		//check if it is custom wallpaper
		if([m_DataController IsCustomWallpaper:[userConfig m_Wallpaper]])
		{
			//image in iphone
			NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentDir=[documentPaths objectAtIndex:0];
			NSString *imagePath=[documentDir stringByAppendingPathComponent:[userConfig m_Wallpaper]];
			
			[m_WallpaperView ChangeWallpaperCustomize:[UIImage imageWithContentsOfFile:imagePath] WithFileName:[userConfig m_Wallpaper]];
			
		}
		else 
		{
			//image in bundle
			[m_WallpaperView ChangeWallpaperSystem:[userConfig m_Wallpaper]];
		}

	}
	
	//load pool background color
	[m_PoolBackground ChangeBackgroundColor:[UIColor colorWithRed:[userConfig m_PoolRed] green:[userConfig m_PoolGreen] blue:[userConfig m_PoolBlue] alpha:[userConfig m_PoolAlpha]]];
	
	
	//load pool
	if([[userConfig m_LastPoolName] compare:@"none"]==0)
	{
		NSLog(@"no pool config");
		
		[self NoCustomAlert:@"Alert" WithMessage:@"There is no last custom pool found please choose one to start"];

	}
	else 
	{
		[m_Utility LoadCustomPool:[userConfig m_LastPoolName]];
	}
	
	//load top border
	if([[userConfig m_TopRightBorder] compare:@"none"]==0)
	{
		NSLog(@"no top right border config");
	}
	else 
	{
		[m_TopRightBorder ChangeBorderImage:[userConfig m_TopRightBorder]];
	}
	
	//load top border 2
	if([[userConfig m_TopRightBorder2] compare:@"none"]==0)
	{
		NSLog(@"no top right border2  config");
	}
	else 
	{
		[m_TopRightBorder2 ChangeBorderImage:[userConfig m_TopRightBorder2]];
	}
	
	[userConfig release];

}



- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	
	//for shacking
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	
	isAlertOn=NO;
	
	m_LoadingImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
	[m_LoadingImage setImage:[UIImage imageNamed:@"title screen.png"]];
	[m_LoadingImage setAlpha:1];
	[window addSubview:m_LoadingImage];
	
	
	if(!LoadingProgressView)
	{
		m_LoadingActivity=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, (480/2)-10, 40, 40)];
		[m_LoadingActivity setCenter:CGPointMake(320/2, 480/2)];
		[m_LoadingActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
		[window addSubview:m_LoadingActivity];
		[m_LoadingActivity startAnimating];
		
	}
	else 
	{
		m_LoadingProgressBar=[[LoadingProgressBar alloc] initWithFrame:CGRectMake((320/2)-(200/2), 480-100, 200, 100)];
		[window addSubview:m_LoadingProgressBar];
	}
	
	[self performSelector:@selector(LoadApp) withObject:nil afterDelay:0.5];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	UserConfigDataPackage *userConfig=[[UserConfigDataPackage alloc] init];
	
	NSString *menuBorder=[m_MenuBorder m_ImageFileName];
	NSString *menuBackground=[m_MenuBackground m_ImageFileName];
	NSString *infoBarBackground=[m_InfoBar m_ImageFileName];
	NSString *itemBorder=[m_ItemBorder m_ImageFileName];
	NSString *itemBackground=[m_ItemBackground m_ImageFileName];
	NSString *wallpaper=[m_WallpaperView m_ImageFileName];
	CGFloat poolRed=[m_PoolBackground m_Red];
	CGFloat poolGreen=[m_PoolBackground m_Green];
	CGFloat poolBlue=[m_PoolBackground m_Blue];
	CGFloat poolAlpha=[m_PoolBackground m_Alpha];
	NSString *lastPoolName;
	
	if([m_PoolView m_CurrentPage]!=nil)
	{
		lastPoolName=[(PoolPageView*)[m_PoolView m_CurrentPage] m_PageName];
	}
	else 
	{
		lastPoolName=@"none";
	}

	
	NSString *topRightBorder=[m_TopRightBorder m_ImageFileName];
	NSString *topRightBorder2=[m_TopRightBorder2 m_ImageFileName];
	
	if(menuBorder!=nil)
	{
		[userConfig setM_MenuBorder:menuBorder];
	}
	else 
	{
		[userConfig setM_MenuBorder:@"none"];
	}

	
	if(menuBackground!=nil)
	{
		[userConfig setM_MenuBackground:menuBackground];
	}
	else 
	{
		[userConfig setM_MenuBackground:@"none"];
	}
	
	if(infoBarBackground!=nil)
	{
		[userConfig setM_InfoBarBackground:infoBarBackground];
	}
	else
	{
		[userConfig setM_InfoBarBackground:@"none"];
	}
	
	if(itemBorder!=nil)
	{
		[userConfig setM_ItemBorder:itemBorder];
	}
	else 
	{
		[userConfig setM_ItemBorder:@"none"];
	}
	
	if(itemBackground!=nil)
	{
		[userConfig setM_ItemBackground:itemBackground];
	}
	else 
	{
		[userConfig setM_ItemBackground:@"none"];
	}
	
	if(wallpaper!=nil)
	{
		[userConfig setM_Wallpaper:wallpaper];
	}
	else 
	{
		[userConfig setM_Wallpaper:@"none"];
	}
	
	[userConfig setM_PoolRed:poolRed];
	[userConfig setM_PoolGreen:poolGreen];
	[userConfig setM_PoolBlue:poolBlue];
	[userConfig setM_PoolAlpha:poolAlpha];
	
	if(lastPoolName!=nil)
	{
		[userConfig setM_LastPoolName:lastPoolName];
	}
	else 
	{
		[userConfig setM_LastPoolName:@"none"];
	}
	
	if(topRightBorder!=nil)
	{
		[userConfig setM_TopRightBorder:topRightBorder];
	}
	else 
	{
		[userConfig setM_TopRightBorder:@"none"];
	} 
	
	if(topRightBorder2!=nil)
	{
		[userConfig setM_TopRightBorder2:topRightBorder2];
	}
	else 
	{
		[userConfig setM_TopRightBorder2:@"none"];
	}
	
	[m_DataController SaveUserConfig:userConfig];
	
	[m_PoolView CloseCurrentPool];
	
	[userConfig release];

}

//test
-(void)Zoom
{
	if(zoom==NO)
	{
		//ease out
		[m_MenuBackground EaseOut];
		[m_ItemBackground EaseOut];
		
		//pool zoom in
		[m_PoolBackground ZoomIn];
		
		zoom=YES;
	}
	else 
	{
		
		[self BringMenuToTop];
		//ease in
		[m_MenuBackground EaseIn];
		[m_ItemBackground EaseIn];
		
		//pool zoom out
		[m_PoolBackground ZoomOut];
		
		zoom=NO;
	}

	
}

-(void)NoCustomAlert:(NSString*)title WithMessage:(NSString*)message
{
	m_Mode=@"NoCustom";
	
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title
												  message:message delegate:self 
										cancelButtonTitle:@"Cancel" otherButtonTitles:@"Blank", @"Master", @"Sample", nil];
	
	//make buttons line up as coloumn
	[alert show];
	[alert release];
}



- (void)applicationWillEnterForeground:(UIApplication *)application
{
	[(ItemPageView*)[m_ItemView m_CurrentPage] StartAnimation];
	[(CatalogView*)[m_InfoBar m_CatalogView] StartAnimation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	UserConfigDataPackage *userConfig=[[UserConfigDataPackage alloc] init];
	
	NSString *menuBorder=[m_MenuBorder m_ImageFileName];
	NSString *menuBackground=[m_MenuBackground m_ImageFileName];
	NSString *infoBarBackground=[m_InfoBar m_ImageFileName];
	NSString *itemBorder=[m_ItemBorder m_ImageFileName];
	NSString *itemBackground=[m_ItemBackground m_ImageFileName];
	NSString *wallpaper=[m_WallpaperView m_ImageFileName];
	CGFloat poolRed=[m_PoolBackground m_Red];
	CGFloat poolGreen=[m_PoolBackground m_Green];
	CGFloat poolBlue=[m_PoolBackground m_Blue];
	CGFloat poolAlpha=[m_PoolBackground m_Alpha];
	NSString *lastPoolName;
	
	if([m_PoolView m_CurrentPage]!=nil)
	{
		lastPoolName=[(PoolPageView*)[m_PoolView m_CurrentPage] m_PageName];
	}
	else 
	{
		lastPoolName=@"none";
	}
	
	
	NSString *topRightBorder=[m_TopRightBorder m_ImageFileName];
	NSString *topRightBorder2=[m_TopRightBorder2 m_ImageFileName];
	
	if(menuBorder!=nil)
	{
		[userConfig setM_MenuBorder:menuBorder];
	}
	else 
	{
		[userConfig setM_MenuBorder:@"none"];
	}
	
	
	if(menuBackground!=nil)
	{
		[userConfig setM_MenuBackground:menuBackground];
	}
	else 
	{
		[userConfig setM_MenuBackground:@"none"];
	}
	
	if(infoBarBackground!=nil)
	{
		[userConfig setM_InfoBarBackground:infoBarBackground];
	}
	else
	{
		[userConfig setM_InfoBarBackground:@"none"];
	}
	
	if(itemBorder!=nil)
	{
		[userConfig setM_ItemBorder:itemBorder];
	}
	else 
	{
		[userConfig setM_ItemBorder:@"none"];
	}
	
	if(itemBackground!=nil)
	{
		[userConfig setM_ItemBackground:itemBackground];
	}
	else 
	{
		[userConfig setM_ItemBackground:@"none"];
	}
	
	if(wallpaper!=nil)
	{
		[userConfig setM_Wallpaper:wallpaper];
	}
	else 
	{
		[userConfig setM_Wallpaper:@"none"];
	}
	
	[userConfig setM_PoolRed:poolRed];
	[userConfig setM_PoolGreen:poolGreen];
	[userConfig setM_PoolBlue:poolBlue];
	[userConfig setM_PoolAlpha:poolAlpha];
	
	if(lastPoolName!=nil)
	{
		[userConfig setM_LastPoolName:lastPoolName];
	}
	else 
	{
		[userConfig setM_LastPoolName:@"none"];
	}
	
	if(topRightBorder!=nil)
	{
		[userConfig setM_TopRightBorder:topRightBorder];
	}
	else 
	{
		[userConfig setM_TopRightBorder:@"none"];
	} 
	
	if(topRightBorder2!=nil)
	{
		[userConfig setM_TopRightBorder2:topRightBorder2];
	}
	else 
	{
		[userConfig setM_TopRightBorder2:@"none"];
	}
	
	[m_DataController SaveUserConfig:userConfig];
	
	[userConfig release];
	
}

- (void)dealloc {
	
	if(m_DataController!=nil)
	{
		[m_DataController release];
	}
	
	if(m_Utility!=nil)
	{
		[m_Utility release];
	}
	
	if(m_TopRightBorder2!=nil)
	{
		[m_TopRightBorder2 release];
	}
	
	if(m_TopRightBorder!=nil)
	{
		[m_TopRightBorder release];
	}
	
	if(m_InfoBar!=nil)
	{
		[m_InfoBar release];
	}
	
	if(m_MenuView!=nil)
	{
		[m_MenuView release];
	}

	if(m_MenuBorder!=nil)
	{
		[m_MenuBorder release];
	}
	
	if(m_MenuBackground!=nil)
	{
		[m_MenuBackground release];
	}
	
	if(m_ItemView!=nil)
	{
		[m_ItemView release];
	}
	
	if(m_ItemBorder!=nil)
	{
		[m_ItemBorder release];
	}
	
	if(m_ItemBackground!=nil)
	{
		[m_ItemBackground release];
	}
	
	if(m_PoolView!=nil)
	{
		[m_PoolView release];
	}
	
	if(m_ImportPhotoImageView!=nil)
	{
		[m_ImportPhotoImageView release];
	}
	
	if(m_WallpaperView!=nil)
	{
		[m_WallpaperView release];
	}
	
	if(m_PoolBackground!=nil)
	{
		[m_PoolBackground release];
	}
	
	if(m_MainBackground!=nil)
	{
		[m_MainBackground release];
	}
	
    [window release];
    [super dealloc];
}


@end
