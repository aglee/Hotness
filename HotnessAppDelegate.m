//
//  HotnessAppDelegate.m
//  Hotness
//
//  Created by Andy Lee on 7/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HotnessAppDelegate.h"
#import "DDHotKeyCenter.h"

@implementation HotnessAppDelegate

#pragma mark -
#pragma mark HotKey event handling

- (void)runScriptAtIndex:(int)scriptIndex
{
	// Calculate the path of the AppleScript corresponding to scriptIndex.
	NSArray *		scriptNames = [NSArray arrayWithObjects:
								   @"Google",
								   @"SayDate",
								   @"iTunesPlay",
								   @"iTunesPause",
								   @"SleepComputer",
								   nil];
	NSString *		scriptPath = [[NSBundle mainBundle]
								  pathForResource:[scriptNames objectAtIndex:scriptIndex]
								  ofType:@"scpt"];
	
	// Load the AppleScript at that path, if there is one.
	NSDictionary *	errorDict = nil;
	NSAppleScript *	script = nil;
	
	if (scriptPath != nil)
	{
		NSURL *	scriptURL = [NSURL fileURLWithPath:scriptPath];
		
		script = [[[NSAppleScript alloc] initWithContentsOfURL:scriptURL
														 error:&errorDict] autorelease];
		
		if (script == nil)
		{
			NSLog(@"ERROR loading script: %@", errorDict);
		}
	}
	
	// If we successfully loaded a script, execute it.
	if (script != nil)
	{
		NSAppleEventDescriptor *	scriptResult = [script executeAndReturnError:&errorDict];
		
		if (scriptResult == nil)
		{
			NSLog(@"ERROR executing script: %@", errorDict);
		}
	}
}

- (void)handleHotkeyWithEvent:(NSEvent *)event object:(id)object
{
	if ([(NSNumber *)object intValue] == 0)
	{
		[NSApp activateIgnoringOtherApps:YES];
	}
	else
	{
		NSInteger	scriptIndex = [(NSNumber *)object intValue] - 1;
		
		[self runScriptAtIndex:scriptIndex];
	}
}


#pragma mark -
#pragma mark Action methods

- (IBAction)doHotButtonAction:(id)sender
{
	if (sender == hotButtonsMatrix)
	{
		NSInteger		row;
		NSInteger		col;
		
		[sender getRow:&row column:&col ofCell:[hotButtonsMatrix selectedCell]];
		
		NSInteger		scriptIndex = (row * [hotButtonsMatrix numberOfColumns]) + col;
		
		[self runScriptAtIndex:scriptIndex];
	}
}


#pragma mark -
#pragma mark NSApplication delegate methods

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// I got the key codes for the numeric keys via this link:
	// http://boredzo.org/blog/archives/2007-05-22/virtual-key-codes
	static int keyCodesFor0Through9[] = { 29, 18, 19, 20, 21, 23, 22, 26, 28, 25 };
	
	// Register our hotkeys -- ^1 for the first button, ^2 for the second, etc.
	// ^0 brings this app front.
	DDHotKeyCenter *	hotKeyCenter = [[[DDHotKeyCenter alloc] init] autorelease];
	for (int i = 0; i <= 5; i++)
	{
		if (![hotKeyCenter registerHotKeyWithKeyCode:keyCodesFor0Through9[i]
									   modifierFlags:NSControlKeyMask
											  target:self
											  action:@selector(handleHotkeyWithEvent:object:)
											  object:[NSNumber numberWithInt:i]])
		{
			NSLog(@"failed to register hotkey %d", i);
		}
	}
}


@end
