//
//  AlertTableView.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/5/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "PackingCheckListAppDelegate.h"
#import "AlertTableView.h"
#import "Utility.h"


@implementation AlertTableView


@synthesize mDelegate;
@synthesize m_Data;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

-(void)PrepareTableWithData:(NSMutableArray*)data WithAction:(NSString*)action WithDelegate:(PackingCheckListAppDelegate*)delegate
{
	self.m_Data=data;
	mDelegate=delegate;
	m_TableHeight=150;
	m_Action=action;
	[self setDelegate:self];
	[self setNeedsDisplay];
	
	m_TableView=[[UITableView alloc] initWithFrame:CGRectMake(16, 50, 250, m_TableHeight) style:UITableViewStylePlain];
	
	[m_TableView setDelegate:self];
	[m_TableView setDataSource:self];
	
	[self addSubview:m_TableView];

}

- (void)setFrame:(CGRect)rect 
{
	[super setFrame:CGRectMake(0, 0, rect.size.width, 270)];
	self.center = CGPointMake(320/2, 480/2);
}

-(void)layoutSubviews
{
	CGFloat buttonTop;
	
	for(UIView *view in self.subviews)
	{
		if([[[view class] description] isEqualToString:@"UIThreePartButton"])
		{
			view.frame = CGRectMake(view.frame.origin.x, self.bounds.size.height-view.frame.size.height-20, view.frame.size.width, view.frame.size.height);
			
			buttonTop = view.frame.origin.y;
		}
	}
}

-(void)show
{
	[super show];
}

//datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

	return [m_Data count];

}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...

	cell.textLabel.text=[m_Data objectAtIndex:[indexPath row]];
	
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	[(Utility*)[mDelegate m_Utility] setM_Index:[indexPath row]];
	[self dismissWithClickedButtonIndex:0 animated:YES];
	

	if([m_Action compare:@"filesystemsample"]==0)
	{
		[(Utility*)[mDelegate m_Utility] StartUtilityWithCommand:m_Action WithObject:@"You will start with a sample list please enter a name for this list"];
	}
	else if([m_Action compare:@"filesystemcustomize"]==0) 
	{
		[(Utility*)[mDelegate m_Utility] StartUtilityWithCommand:m_Action WithObject:@"You will start with a custom list please enter a name for this list"];
	}
	else if([m_Action compare:@"filesystemedit"]==0)
	{
		[(Utility*)[mDelegate m_Utility] StartUtilityWithCommand:m_Action WithObject:@"none"];
	}
	else if([m_Action compare:@"filesystemrename"]==0)
	{
		[(Utility*)[mDelegate m_Utility] StartUtilityWithCommand:m_Action WithObject:@"Please enter a new name for this list"];
	}
	else if([m_Action compare:@"filesystemcopy"]==0)
	{
		[(Utility*)[mDelegate m_Utility] StartUtilityWithCommand:m_Action WithObject:@"Please enter a new name for this list"];
	}
	else if([m_Action compare:@"filesystemdelete"]==0)
	{
		[(Utility*)[mDelegate m_Utility] StartUtilityWithCommand:m_Action WithObject:@"none"];
	}


	
	
	
	self.m_Data=nil;
	
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	[super drawRect:rect];
}


- (void)dealloc {
    [super dealloc];
}


@end
