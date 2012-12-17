//
//  ToDoTaskController.h
//  ToDoList
//
//  Created by Tiffany Lee on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ToDoTaskController : NSWindowController {
	
	IBOutlet NSTextField *name;
	IBOutlet NSTextField *note;
	IBOutlet NSButton *done;
	IBOutlet NSButton *reminderCheck;
	IBOutlet NSDatePicker *reminderDatePicker;
	IBOutlet NSTextField *doneLabel;
	NSString *priority; // not sure if used...
	
	// for reminder
	NSDate *reminderDate;
	NSTimer *reminderTimer;
	
}

@property (nonatomic, retain) IBOutlet NSTextField *name;
@property (nonatomic, retain) IBOutlet NSTextField *note;
@property (nonatomic, retain) IBOutlet NSButton *done;
@property (nonatomic, retain) IBOutlet NSButton *reminderCheck;
@property (nonatomic, retain) IBOutlet NSDatePicker *reminderDatePicker;
@property (nonatomic, retain) NSDate *reminderDate;
@property (nonatomic, retain) NSTimer *reminderTimer;
@property NSString *priority; // not sure if used...
@property IBOutlet NSTextField *doneLabel;

-(void)fireReminder:(NSTimer*)theTimer;
-(IBAction)pressReminder:(id)sender;
-(id)initSpecial:(NSString *)windowNibName priority:(NSString *)p;
-(IBAction)pressDoneButton:(id)sender;
-(void)dealloc;

@end
