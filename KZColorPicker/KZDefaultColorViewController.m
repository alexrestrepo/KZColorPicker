    //
//  CMQGDefaultColorViewController.m
//  Quick Graph
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import "KZDefaultColorViewController.h"
#import "UIColor-Expanded.h"

@implementation KZDefaultColorViewController
@synthesize delegate;
@synthesize selectedColor;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	UIView *container = [[UIView alloc] initWithFrame: IS_IPAD ? CGRectMake(0, 0, 320, 460) :[[UIScreen mainScreen] applicationFrame]];
	container.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	container.backgroundColor = [UIColor clearColor];
	self.view = container;
	[container release];
	
	KZColorPicker *picker = [[KZColorPicker alloc] initWithFrame:container.bounds];
    picker.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	picker.selectedColor = self.selectedColor;
    picker.oldColor = self.selectedColor;
	[picker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:picker];
    [picker release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
- (void)viewDidLoad {
    [super viewDidLoad];
	
}
 */

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [selectedColor release];
    [super dealloc];
}

- (void) pickerChanged:(KZColorPicker *)cp
{	
    self.selectedColor = cp.selectedColor;
	[delegate defaultColorController:self didChangeColor:cp.selectedColor];	
}

#pragma mark -
#pragma mark  Popover support
- (CGSize) contentSizeForViewInPopover
{       	
	return CGSizeMake(320, 416);
}

@end
