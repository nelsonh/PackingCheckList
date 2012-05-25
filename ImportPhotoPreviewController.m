//
//  ImportPhotoPreviewController.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PackingCheckListAppDelegate.h"
#import "ImportPhotoPreviewController.h"
#import "ImportPhotoPreviewView.h"
#import "Utility.h"
#import "ImportPhoto.h"
#import "NamePhotoController.h"
#import "NamePhotoView.h"

@implementation ImportPhotoPreviewController


@synthesize m_ImportPhotoPreviewView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/
-(void)SetupUI
{
	//setup navigation ui
	UIBarButtonItem *LeftButton=[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(UserCancel)];
	UIBarButtonItem *RightButton=[[UIBarButtonItem alloc] initWithTitle:@"Use" style:UIBarButtonItemStylePlain target:self action:@selector(UserUse)];
	
	self.navigationItem.leftBarButtonItem=LeftButton;
	self.navigationItem.rightBarButtonItem=RightButton;
}

-(void)UserCancel
{
	[[[(PackingCheckListAppDelegate*)[[UIApplication sharedApplication] delegate] m_Utility] m_ImportPhotoFunction] CloseImportPhotoUtility];
}

-(void)UserUse
{
	
	//[self.view removeFromSuperview];
	//retrieve name photo controller
	NamePhotoController *NPC=[[[(PackingCheckListAppDelegate*)[[UIApplication sharedApplication] delegate] m_Utility] m_ImportPhotoFunction] m_NamePhotoController];
	[self.navigationController pushViewController:NPC animated:YES];
	
	UIImageView *imageView=[(NamePhotoView*)NPC.view m_ImageView];
	
	UIImage *mImage=[[(ImportPhotoPreviewView*)self.view m_PreviewImage] image];
	
	UIImageOrientation orient=[mImage imageOrientation];
	
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
	
	[NPC NameImageAlert];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	//init view
	m_ImportPhotoPreviewView=[[ImportPhotoPreviewView alloc] init];
	
	
	self.view=m_ImportPhotoPreviewView;

	//setup navigation ui
	UIBarButtonItem *LeftButton=[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(UserCancel)];
	UIBarButtonItem *RightButton=[[UIBarButtonItem alloc] initWithTitle:@"Use" style:UIBarButtonItemStylePlain target:self action:@selector(UserUse)];
	
	self.navigationItem.leftBarButtonItem=LeftButton;
	self.navigationItem.rightBarButtonItem=RightButton;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	if(m_ImportPhotoPreviewView!=nil)
	{
		[m_ImportPhotoPreviewView removeFromSuperview];
		m_ImportPhotoPreviewView=nil;
	}
	
    [super dealloc];
}


@end
