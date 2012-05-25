//
//  NamePhotoController.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/4/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PackingCheckListAppDelegate.h"
#import "NamePhotoController.h"
#import "NamePhotoView.h"
#import "Utility.h"
#import "ImportPhoto.h"
#import "DataController.h"
#import "TextFieldAlertView.h"

@implementation NamePhotoController

@synthesize m_NamePhotoView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

//this will be showed up at first time since user confirm photo
-(void)NameImageAlert
{
	/*
	//init an alert
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Name Photo" message:@"Enter a name for photo" 
												 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	
	//add a textfield to alert
	[alert addTextFieldWithValue:@"" label:@"Enter Name"];
	
	//retrieve that textfield
	UITextField *mTextField=[alert textFieldAtIndex:0];
	
	//adjust textfield
	[mTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
	[mTextField setKeyboardType:UIKeyboardTypeAlphabet];
	[mTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[mTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
	[mTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
	
	[alert show];
	[alert release];
	*/
	

	TextFieldAlertView *alert=[[TextFieldAlertView alloc] InitWithTitle:@"Name Photo" WithMessage:@"Enter a name for photo" 
																WithDelegate:self WithPlaceHolder:@"Enter name" WithButtons:[NSArray arrayWithObjects:@"OK", nil]];
	
	[alert show];
	[alert release];
}

-(void)ImageOverWriteAlert
{
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Overwrite photo" message:@"The photo is exist would you like over write" 
												 delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"OK", nil];
	
	[alert show];
	[alert release];
}

-(void)NameImageAlertWithTitle:(NSString*)mTitle WithMessage:(NSString*)message
{
	/*
	//init an alert
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:mTitle message:message 
												 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	
	//add a textfield to alert
	[alert addTextFieldWithValue:@"" label:@"Enter Name"];
	
	//retrieve that textfield
	UITextField *mTextField=[alert textFieldAtIndex:0];
	
	//adjust textfield
	[mTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
	[mTextField setKeyboardType:UIKeyboardTypeAlphabet];
	[mTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[mTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
	[mTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
	
	[alert show];
	[alert release];
	*/
	
	TextFieldAlertView *alert=[[TextFieldAlertView alloc] InitWithTitle:mTitle WithMessage:message
																WithDelegate:self WithPlaceHolder:@"Enter name" WithButtons:[NSArray arrayWithObjects:@"OK", nil]];
	
	[alert show];
	[alert release];
}

//if user not enter name for photo this will be showed up at second time
-(void)BlankNameAlert
{
	/*
	//init an alert
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Name Image" message:@"Name can not be blank" 
												 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	
	//add a textfield to alert
	[alert addTextFieldWithValue:@"" label:@"Enter Name"];
	
	//retrieve that textfield
	UITextField *mTextField=[alert textFieldAtIndex:0];
	
	//adjust textfield
	[mTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
	[mTextField setKeyboardType:UIKeyboardTypeAlphabet];
	[mTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[mTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
	[mTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
	
	[alert show];
	[alert release];
	*/
	
	TextFieldAlertView *alert=[[TextFieldAlertView alloc] InitWithTitle:@"Name Image" WithMessage:@"Name can not be blank" 
																WithDelegate:self WithPlaceHolder:@"Enter name" WithButtons:[NSArray arrayWithObjects:@"OK", nil]];
	
	[alert show];
	[alert release];
}

-(BOOL)IsEnterNameUsedBySystem:(NSString*)enterName
{
	return [[(PackingCheckListAppDelegate*)[[UIApplication sharedApplication] delegate] m_DataController] IsNameUsedBySystem:enterName];
}
-(BOOL)IsEnterNameExistInCustomizeList:(NSString *)enterName
{
	return [[(PackingCheckListAppDelegate*)[[UIApplication sharedApplication] delegate] m_DataController] IsEnterNameExistInCustomizeList:enterName];
}

//when user click any button in alert view 
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	
	if(m_PhotoOverWrite)
	{
		if(buttonIndex==0)
		{
			//user dont want to overwrite
			[self NameImageAlert];
			
			m_PhotoOverWrite=NO;
		}
		else if(buttonIndex==1)
		{
			//user want to overwrite
			
			//pop this name photo controller dont need to release since this is a reused controller
			[[[(PackingCheckListAppDelegate*)[[UIApplication sharedApplication] delegate] m_Utility] m_ImportPhotoFunction] FinishImportPhotoUtility: [[(NamePhotoView*)self.view m_ImageView] image] WithImageName:m_Text];
			
			m_PhotoOverWrite=NO;
			
			m_Text=nil;
		}
	}
	else 
	{
		//retrieve that textfield
		UITextField *mTextField=[(TextFieldAlertView*)alertView m_TextField];
		[mTextField resignFirstResponder];
		
		//get back text user input
		m_Text=[[mTextField text] retain];
		
		if([m_Text compare:@""]==0 && buttonIndex==1)
		{
			//user didnt enter any text and click button ok
			
			[self BlankNameAlert];
			return;
		}
		else if(buttonIndex==0)
		{
			//user click button cancel
	
			[[[(PackingCheckListAppDelegate*)[[UIApplication sharedApplication] delegate] m_Utility] m_ImportPhotoFunction] CloseImportPhotoUtility];
			
			[m_Text release];
			m_Text=nil;
		}
		else 
		{
			// use enter text and click button ok
			
			//first check if enter name is used by system
			if([self IsEnterNameUsedBySystem:m_Text])
			{
				//enter name has been used by system
				[self NameImageAlertWithTitle:@"Name exist" WithMessage:@"The name you enter has been used by system please enter different name"];

			}
			//check if enter name is already exist in customize list
			else if([self IsEnterNameExistInCustomizeList:m_Text])
			{
				
				[self ImageOverWriteAlert];
				m_PhotoOverWrite=YES;
			}
			else 
			{
				//pop this name photo controller dont need to release since this is a reused controller
				[[[(PackingCheckListAppDelegate*)[[UIApplication sharedApplication] delegate] m_Utility] m_ImportPhotoFunction] FinishImportPhotoUtility:[[(NamePhotoView*)self.view m_ImageView] image] WithImageName:m_Text];
				
				[m_Text release];
				m_Text=nil;
			}

		
			
		}
	}


	
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	m_NamePhotoView=[[NamePhotoView alloc] init];
	
	self.view=m_NamePhotoView;
	
	
	m_PhotoOverWrite=NO;
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
	
	if(m_NamePhotoView!=nil)
	{
		[m_NamePhotoView removeFromSuperview];
		self.m_NamePhotoView=nil;
	}

	
	if(m_Text!=nil)
	{
		[m_Text release];
	}
	
    [super dealloc];
}


@end
