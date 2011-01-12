//
//  HotnessAppDelegate.h
//  Hotness
//
//  Created by Andy Lee on 7/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HotnessAppDelegate : NSObject
{
	IBOutlet NSPanel *	hotButtonsPanel;
	IBOutlet NSMatrix *	hotButtonsMatrix;
}

- (IBAction)doHotButtonAction:(id)sender;

@end
