//
//  ImportPhoto.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImportPhoto.h"
#import "PackingCheckListAppDelegate.h"
#import "ImportPhotoPreviewController.h"
#import "NamePhotoController.h"
#import "NamePhotoView.h"
#import "ImportPhotoImageView.h"
#import "ImportPhotoPreviewView.h"
#import "MainBackground.h"

@implementation ImportPhoto

@synthesize mDelegate;
@synthesize m_NavController;
@synthesize m_ImportPhotoPreviewController;
@synthesize m_NamePhotoController;

-(id)InitImportPhotoWithDelegate:(PackingCheckListAppDelegate*)delegate
{
	if(self=[super init])
	{
		self.mDelegate=delegate;
	}
	
	return self;
}

//start action sheet
-(void)ActiveImportPhotoMenu
{
	
	//every time when user active import photo then need to check if previous image picker controller instance is exist, if so the release it also 
	//remove form superview
	
	if(m_NavController!=nil)
	{
		[self ReleaseNavigation];
	}
	
	

	//init action sheet depend on device
	UIActionSheet *actionSheet;
	if([[mDelegate m_DeviceModel] compare:@"iPhone"]==0)
	{
		//user use iphone
		//init action sheet but dont show it yet until user trigger
		actionSheet=[[UIActionSheet alloc] initWithTitle:@"Import photo" 
												  delegate:self cancelButtonTitle:@"Cancel" 
									destructiveButtonTitle:@"From camera" otherButtonTitles:@"From library", nil];
		
		m_IsUserUseIphone=YES;
	}
	else
	{
		//user not user iphone
		//init action sheet but dont show it yet until user trigger
		actionSheet=[[UIActionSheet alloc] initWithTitle:@"Import photo" 
												  delegate:self cancelButtonTitle:@"Cancel" 
									destructiveButtonTitle:@"From library" otherButtonTitles:nil];
		
		m_IsUserUseIphone=NO;
	}
	
	
	[actionSheet showInView:(UIView*)[mDelegate m_MainBackground]];
	
	[actionSheet release];
	
	UINavigationController *navController=[[UINavigationController alloc] init];
	self.m_NavController=navController;
	[navController release];
	[[m_NavController navigationBar] setTintColor:[UIColor grayColor]];
	[[m_NavController navigationBar] setHidden:YES];
	[(MainBackground*)[mDelegate m_MainBackground] addSubview:m_NavController.view];


}

//user close this utility during operation
-(void)CloseImportPhotoUtility
{
	if(m_UserSelectedType==Camera)
	{
		[m_NavController popToRootViewControllerAnimated:YES];
		
		//remove navigation
		[self ReleaseNavigation];
		
		
	}
	else if(m_UserSelectedType==PhotoLibrary)
	{
		[m_NavController popToRootViewControllerAnimated:YES];
		
		//remove navigation
		[self ReleaseNavigation];
		
	}
	
	if(m_NamePhotoController!=nil)
	{
		m_NamePhotoController=nil;
	}
	
	if(m_ImportPhotoPreviewController!=nil)
	{
		m_ImportPhotoPreviewController=nil;
	}

}

//user has finished operation 
-(void)FinishImportPhotoUtility:(UIImage*)mImage WithImageName:(NSString*)imageName;
{
	if(m_UserSelectedType==Camera)
	{
		// make a copy of image
		//UIImage *copyImage=[mImage copy];
		
		//tell pool view to pop up a view that can let user to view the photo they take
		[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] ShowWithImage:mImage WithImageName:imageName];
		
		[m_NavController popToRootViewControllerAnimated:YES];
		
		//remove navigation
		[self ReleaseNavigation];
		
		
	}
	else if(m_UserSelectedType==PhotoLibrary)
	{
		
		// make a copy of image
		//UIImage *copyImage=[mImage copy];
		
		//tell pool view to pop up a view that can let user to view the photo they take
		[(ImportPhotoImageView*)[mDelegate m_ImportPhotoImageView] ShowWithImage:mImage WithImageName:imageName];
		
		[m_NavController popToRootViewControllerAnimated:YES];
		
		//remove navigation
		[self ReleaseNavigation];
				
	}
	
	if(m_NamePhotoController!=nil)
	{
		m_NamePhotoController=nil;
	}
	
	if(m_ImportPhotoPreviewController!=nil)
	{
		m_ImportPhotoPreviewController=nil;
	}
	
}

-(void)ReleaseNavigation
{
	//remove navigation 
	if(m_NavController!=nil)
	{
		[m_NavController.view removeFromSuperview];
		self.m_NavController=nil;
	}

}


//when user press any button in action sheet this delegate will be called
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(m_IsUserUseIphone)
	{
		//user is using iphone
		
		if(buttonIndex==0)
		{
			//user press button "from camera"
			
			//init a image picker
			UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
			imagePicker.delegate=self;
			
			//start with camera
			imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
			
			//allow user to edit photo after photo has been taken
			[imagePicker setAllowsEditing:YES];
			
			//add this controller's view to main background view so image picker controller's view will show up
			[m_NavController presentModalViewController:imagePicker animated:YES];
			
			//change user selected type to camera
			m_UserSelectedType=Camera;
			
			[imagePicker release];
			
		}
		else if(buttonIndex==1)
		{
			//user press button "from library"
			
			//init a image picker
			UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
			imagePicker.delegate=self;
			
			
			//start with photo library
			imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
			
			//allow user to edit photo after photo has been choose from photo library
			[imagePicker setAllowsEditing:YES];
			
			//add this controller's view to main background view so image picker controller's view will show up
			//[[mDelegate m_MainBackground] addSubview:m_ImagePickerController.view];
			[m_NavController presentModalViewController:imagePicker animated:YES];
			
			//change user selected type to photo library
			m_UserSelectedType=PhotoLibrary;
			
			[imagePicker release];
		}
		else 
		{
			//user cancel action sheet
			if(m_NamePhotoController!=nil)
			{
				
				[m_NamePhotoController release];
				m_NamePhotoController=nil;
			}
			
			if(m_ImportPhotoPreviewController!=nil)
			{
				
				[m_ImportPhotoPreviewController release];
				m_ImportPhotoPreviewController=nil;
			}
			
			if(m_NavController!=nil)
			{
				[m_NavController.view removeFromSuperview];
				self.m_NavController=nil;
			}
		}

	}
	else 
	{
		//user not use iphone
		
		if(buttonIndex==0)
		{
			//user press button "from library"
			
			//init a image picker
			UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
			imagePicker.delegate=self;
			
			
			//start with photo library
			imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
			
			//allow user to edit photo after photo has been choose from photo library
			[imagePicker setAllowsEditing:YES];
			
			//add this controller's view to main background view so image picker controller's view will show up
			//[[mDelegate m_MainBackground] addSubview:m_ImagePickerController.view];
			[m_NavController presentModalViewController:imagePicker animated:YES];

			//change user selected type to photo library
			m_UserSelectedType=PhotoLibrary;
			
			[imagePicker release];
		}
		else 
		{
			//user cancel action sheet
			if(m_NamePhotoController!=nil)
			{
				
				[m_NamePhotoController release];
				m_NamePhotoController=nil;
			}
			
			if(m_ImportPhotoPreviewController!=nil)
			{
				
				[m_ImportPhotoPreviewController release];
				m_ImportPhotoPreviewController=nil;
			}
			
			if(m_NavController!=nil)
			{
				[m_NavController.view removeFromSuperview];
				self.m_NavController=nil;
			}
			
		}

	}


}

//when user confirm photo and press choose button this delegate will be called
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *mImage;
	
	//retrieve image and copy it
	mImage=[info objectForKey:@"UIImagePickerControllerEditedImage"];
	
	if(m_UserSelectedType==Camera)
	{
		//user was selected camera
		
		//init name photo controller
		NamePhotoController *namePhotoController=[[NamePhotoController alloc] init];
		self.m_NamePhotoController=namePhotoController;
		[namePhotoController release];
		
		[picker dismissModalViewControllerAnimated:YES];
		
		[m_NavController pushViewController:m_NamePhotoController animated:YES];
		
		
		//prepare image for name photo view
		UIImageView *imageView=[(NamePhotoView*)[m_NamePhotoController view] m_ImageView];
		
		//retrieve image orientation
		UIImageOrientation orient=[mImage imageOrientation];
		
		//put to correct orientation
		if(orient==UIImageOrientationRight || orient==UIImageOrientationLeft)
		{
			[imageView setContentMode:UIViewContentModeScaleToFill];
			[imageView setFrame:CGRectMake(0, 0, 320, 480)];
			[imageView setImage:mImage];
		}
		else if(orient==UIImageOrientationUp || orient==UIImageOrientationDown)
		{
			[imageView setContentMode:UIViewContentModeScaleAspectFit];
			[imageView setImage:mImage];
		}
		
		[m_NamePhotoController NameImageAlert];
	}
	else if(m_UserSelectedType==PhotoLibrary)
	{
		//user was selected photo library
		
		//init name photo controller
		NamePhotoController *namePhotoController=[[NamePhotoController alloc] init];
		self.m_NamePhotoController=namePhotoController;
		[namePhotoController release];

		//init import photo preview controller
		[[m_NavController navigationBar] setHidden:NO];
		
		ImportPhotoPreviewController *importPhotoPreviewController=[[ImportPhotoPreviewController alloc] init];
		self.m_ImportPhotoPreviewController=importPhotoPreviewController;
		[importPhotoPreviewController release];
		
		[picker dismissModalViewControllerAnimated:YES];

		//init a new view with navigation
		[m_NavController pushViewController:m_ImportPhotoPreviewController animated:YES];
		

		//prepare image for name photo view
		UIImageView *imageView=[(ImportPhotoPreviewView*)m_ImportPhotoPreviewController.view m_PreviewImage];
		
		
		//retrieve image orientation
		UIImageOrientation orient=[mImage imageOrientation];
		
		//put to correct orientation
		if(orient==UIImageOrientationRight || orient==UIImageOrientationLeft)
		{
			[imageView setContentMode:UIViewContentModeScaleToFill];
			[imageView setFrame:CGRectMake(0, 0, 320, 480)];
			[imageView setImage:mImage];
		}
		else if(orient==UIImageOrientationUp || orient==UIImageOrientationDown)
		{
			[imageView setContentMode:UIViewContentModeScaleAspectFit];
			[imageView setImage:mImage];
		}

		
	}

}

//when user press cancel button during  operating image picker controller's camera or photo library
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

	//user press cancel so remove image picker controller's view from superview;
	[picker dismissModalViewControllerAnimated:NO];
	
	if(m_NavController!=nil)
	{
		[m_NavController.view removeFromSuperview];
		m_NavController=nil;
	}
	

	

}

- (void)dealloc {
	

	if(m_NavController!=nil)
	{
		m_NavController=nil;
	}
	
	if(m_ImportPhotoPreviewController!=nil)
	{
		m_ImportPhotoPreviewController=nil;
	}
	
	if(m_NamePhotoController!=nil)
	{
		m_NamePhotoController=nil;
	}
	
    [super dealloc];
}

@end
