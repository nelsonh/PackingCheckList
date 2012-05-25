//
//  QuantityAlert.m
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/6/18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QuantityAlert.h"


@implementation QuantityAlert

@synthesize m_TextField;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

-(id)InitWithTitle:(NSString*)title WithMessage:(NSString*)msg WithDelegate:(id)delegte WithPlaceHolder:(NSString*)placeHolder WithButtons:(NSArray*)buttonArray
{
	if (self = [super initWithFrame:CGRectZero]) {
        
		//init text field
		UITextField *textField=[[UITextField alloc] initWithFrame:CGRectZero];
		self.m_TextField=textField;
		[textField release];
		[m_TextField setKeyboardType:UIKeyboardTypeNumberPad];
		[m_TextField setPlaceholder:placeHolder];
		[m_TextField setBorderStyle:UITextBorderStyleRoundedRect];
		[m_TextField setDelegate:self];
		[self addSubview:textField];
		
		[self setTitle:title];
		[self setMessage:[msg stringByAppendingString:@"\n\n"]];
		[self setDelegate:delegte];
		[self setNeedsDisplay];
		
		[self addButtonWithTitle:@"Cancel"];
		
		for(int i=0; i<[buttonArray count]; i++)
		{
			NSString *button=[buttonArray objectAtIndex:i];
			
			[self addButtonWithTitle:button];
		}
		
		[m_TextField becomeFirstResponder];
		
    }
    return self;
}

- (void)setFrame:(CGRect)rect 
{
	[super setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
	self.center = CGPointMake(320/2, rect.size.height/2+20);
}

-(void)layoutSubviews
{
	CGFloat buttonTop;
	
	for(UIView *view in self.subviews)
	{
		if([[[view class] description] isEqualToString:@"UIThreePartButton"])
		{
			view.frame = CGRectMake(view.frame.origin.x, self.bounds.size.height-view.frame.size.height-20, view.frame.size.width, view.frame.size.height);
			[m_TextField setFrame:CGRectMake(self.bounds.origin.x+10, view.frame.origin.y-25, self.bounds.size.width-20, 25)];
			
			buttonTop = view.frame.origin.y;
		}
	}
	
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	[super drawRect:rect];
}


- (void)dealloc {
	
	if(m_TextField!=nil)
	{
		self.m_TextField=nil;
	}
	
    [super dealloc];
}


@end
