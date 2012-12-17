//
//  ToDoTaskController.m
//  ToDoList
//
//  Created by Tiffany Lee on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ToDoTaskController.h"
//not sure if need these:
#import "ToDoTaskData.h"
#import "ToDoList.h"


@implementation ToDoTaskController

@synthesize name, note, done, priority, reminderCheck, reminderDate, reminderDatePicker, reminderTimer, doneLabel;

-(id)initSpecial:(NSString *)windowNibName priority:(NSString *)p{
	
	self.priority = p;
	
	if ([p isEqualToString:@"PriorityOne"]) {
		
		// for setting taskName
		[[NSNotificationCenter defaultCenter] 
		 addObserver:self 
		 selector:@selector(setTaskName:) 
		 name:@"PriorityOne" 
		 object:nil];
		
	} else if ([p isEqualToString:@"PriorityTwo"]) {
		[[NSNotificationCenter defaultCenter] 
		 addObserver:self 
		 selector:@selector(setTaskName:) 
		 name:@"PriorityTwo" 
		 object:nil];
		
	}
	
	return [self initWithWindowNibName:windowNibName];
}

-(void)setTaskName:(NSNotification *)notification{
	NSString *obj = [notification object];
	[self.name setStringValue:obj];
}

-(IBAction)pressReminder:(id)sender{
	
	if([reminderCheck state] == 1){ // on state
		NSDate *now = [[NSDate alloc] init];
		[reminderDatePicker setDateValue:now];
		// resize window
		NSRect frame = [self.window frame];
		frame.size.height += 25;
		[self.window setFrame:frame display:true animate:true];
		[reminderDatePicker setHidden:false];
		
		NSRect buttonFrame = [self.done frame];
		buttonFrame.origin.y -= 25;
		
		// DOESN'T WORK
		/*
		[NSAnimationContext beginGrouping];
		[[NSAnimationContext currentContext] setDuration:1.0];
		[[self.done animator] setFrame:buttonFrame display:true];
		[NSAnimationContext endGrouping];
		*/
		[self.done setFrame:buttonFrame];
	} else {
		
		// THIS IS ONLY DISABLED ONCE YOU PRESS DONE!!! IF DON'T WANT THIS ADD IT HERE
		
		NSRect frame = [self.window frame];
		frame.size.height -= 25;
		[self.window setFrame:frame display:true animate:true];
		[reminderDatePicker setHidden:true];
		
		NSRect buttonFrame = [self.done frame];
		buttonFrame.origin.y += 25;
		//[self.done setFrame:buttonFrame display:true animate:true]; 
		[self.done setFrame:buttonFrame];
	}
}
/*
-(void)getReminderTimerReady:(NSDate *)date{
	reminderDate = date;//[reminderDatePicker dateValue];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	
	NSLog(@"Date: %@", [dateFormatter stringFromDate:reminderDate]);
	
	reminderTimer = [[NSTimer alloc] 
					 initWithFireDate:reminderDate 
					 interval:600
					 target:self 
					 selector:@selector(fireReminder:) 
					 userInfo:nil 
					 repeats:true];
	
	NSRunLoop *runner = [NSRunLoop currentRunLoop];
	[runner addTimer:reminderTimer forMode: NSDefaultRunLoopMode];
	[reminderTimer release]; // why release here?!?!
}*/

-(IBAction)pressDoneButton:(id)sender{
	
	if ([reminderCheck state] == 1) {
		//[self getReminderTimerReady:[reminderDatePicker dateValue]];
		/*
		reminderDate = [reminderDatePicker dateValue];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		
		NSLog(@"Date: %@", [dateFormatter stringFromDate:reminderDate]);
		
		reminderTimer = [[NSTimer alloc] 
						 initWithFireDate:reminderDate 
						 interval:600
						 target:self 
						 selector:@selector(fireReminder:) 
						 userInfo:nil 
						 repeats:true];
		
		NSRunLoop *runner = [NSRunLoop currentRunLoop];
		[runner addTimer:reminderTimer forMode: NSDefaultRunLoopMode];
		[reminderTimer release]; // why release here?!?!
		 */
	}
	NSLog(@"pressed done");
	
	if ([self.priority isEqualToString:@"PriorityOne"]) {
		NSLog(@"yayyyy!!!");
		[[NSNotificationCenter defaultCenter] postNotificationName:@"one" object:[reminderDatePicker dateValue]];

	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"two" object:[reminderDatePicker dateValue]];
	}
	NSLog(@"notification done");
}

-(void)fireReminder:(NSTimer*)theTimer{
	NSLog(@"timer went off :)");
	// IMPLEMENT: set an icon
	NSAlert *alert = [[NSAlert alloc] init];
	[alert setMessageText:[self.name stringValue]];
	[alert setInformativeText:[self.note stringValue]];
	[alert setAlertStyle:1];
	//[alert setAccessoryView:accessory]; if want to write more
	[alert runModal];
	[alert release];
	
}

-(void)dealloc{ // UPDATE
	// release outlets?!?!?
	[priority release];
	[[NSNotificationCenter defaultCenter]removeObserver:self];
	[super dealloc];
}
@end
