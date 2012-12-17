//
//  ToDoList.m
//  ToDoList
//
//  Created by Tiffany Lee on 7/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

/*
 TODOLIST:
 -WHAT HAPPENS WHEN THE REMINDER IS OVER - HIDE REMINDER?!?!
 -keep doing reminders till you check your done or you uncheck reminder
 - fix buttonOne, buttonTwo...
 - fix press check b/c its called twice...
 - after editing a task, cursor should got o respective task in todolist!!!
 */


#import "ToDoList.h"
#import "ToDoTaskController.h"
#import "ToDoTaskData.h"

@implementation ToDoList

@synthesize nameOne, nameTwo, buttonOne, buttonTwo, openBeforeOne, openBeforeTwo, windowOne, windowTwo, checkOne, checkTwo, reminderDateOne, reminderDateTwo, reminderTimerOne, reminderTimerTwo;

-(id)init{
	if (self = [super init]) {
		[NSApp setDelegate:self];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	openBeforeOne = NO;
	openBeforeTwo = NO;
	
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self 
	 selector:@selector(selector1:) 
	 name:@"one" 
	 object:nil];
	
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self 
	 selector:@selector(selector2:) 
	 name:@"two" 
	 object:nil];
	
	
	NSUserDefaults *savedData = [NSUserDefaults standardUserDefaults];
	NSLog(@"Got to initiate");
	NSString *n = [[savedData stringForKey:@"nameOne"] copy];
	NSInteger w = [savedData integerForKey:@"windowOne"];
	NSInteger cOne = [savedData integerForKey:@"checkOne"];
	NSInteger reminderCheck = [savedData integerForKey:@"reminderCheckStateOne"];
	
	
	if (cOne == 1) {
		[self.checkOne setState:1];
		[self pressChecked:windowOne check:checkOne name:nameOne]; // PRESSEDCHECKED ALSO NEEDS TO BE ADDED WHEN WINDOWONE IS CREATED!!!!
	}
	
	if (reminderCheck == 1) {
		NSLog(@"gotHere!!!");
		[self getReminderTimerReady:@"one"]; // this doesn't work b/c windowOne hasn't been instantiated yet...
		// plan: instead of keeping the reminder date stuff in todotaskcontroller, just send it to todolist through the done button!!!
	}
					
	[self.nameOne setStringValue:n];
	
}



- (void)applicationWillTerminate:(NSNotification *)aNotifaction {
	// need the states of all buttons
	NSUserDefaults *savedData = [NSUserDefaults standardUserDefaults];
	
	//set the names:
	[savedData setObject:[self.nameOne stringValue] forKey:@"nameOne"];
	[savedData setObject:[self.nameTwo stringValue] forKey:@"nameTwo"];
	
	if ([checkOne state] == 1) {
		[savedData setInteger:(NSInteger)1 forKey:@"checkOne"];					
	} else {
		[savedData setInteger:(NSInteger)0 forKey:@"checkOne"];
	}	
	if ([checkTwo state] == 1) {
		[savedData setInteger:(NSInteger)1 forKey:@"checkTwo"];					
	} else {
		[savedData setInteger:(NSInteger)0 forKey:@"checkTwo"];
	}			
	
	[savedData synchronize];
	
}


-(IBAction)pressCheckedOne:(id)sender{
	[self pressChecked:windowOne check:checkOne name:nameOne];

	// change background color!?!?
	//	[self.nameOne setDrawsBackground:false];
	//	[self.nameOne setBackgroundColor:[NSColor blueColor]];
	
}

-(IBAction)pressCheckedTwo:(id)sender{
	[self pressChecked:windowTwo check:checkTwo name:nameTwo];
}

// need to fix:
-(void)pressChecked:(ToDoTaskController *)task check:(NSButton *)c name:(NSTextField *)n{
	NSUserDefaults *savedData = [NSUserDefaults standardUserDefaults];
	if ([c state] == 1) { // on state
		[task.doneLabel setHidden:false];
		
		NSMutableAttributedString *as = [[n attributedStringValue] mutableCopy];
		[as addAttribute:NSStrikethroughStyleAttributeName value:(NSNumber *)kCFBooleanTrue range:NSMakeRange(0, [as length])];
		[n setAttributedStringValue:[as autorelease]];
		
		[n setEditable:false];
		
		// NEED TO MAKE WINDOW SMALLER
		if ([task.reminderCheck state] == 1) {
			NSRect frame = [task.window frame];
			frame.size.height -= 25;
			[task.window setFrame:frame display:true animate:true];
			[task.reminderDatePicker setHidden:true];
			
			NSRect buttonFrame = [task.done frame];
			buttonFrame.origin.y += 25;
			//[self.done setFrame:buttonFrame display:true animate:true]; 
			[task.done setFrame:buttonFrame];
		}
		
		// turn reminder off - shouldn't take task
		[reminderTimerOne invalidate];
		[task.reminderTimer invalidate]; // do i need this???
		task.reminderTimer = nil;
		[task.reminderCheck setState:0];
		[task.reminderCheck setEnabled:false];
		[task.reminderDatePicker setHidden:true];
		[task.name setEditable:false];
		[task.note setEditable:false];
		
		[savedData setInteger:0 forKey:@"reminderCheckStateOne"];
		[savedData setObject:nil forKey:@"reminderDateOne"];
		
		
	} else {
		NSMutableAttributedString *as = [[n attributedStringValue] mutableCopy];
		[as removeAttribute:NSStrikethroughStyleAttributeName range:NSMakeRange(0, [as length])];
		[n setAttributedStringValue:[as autorelease]];
		
		[n setEditable:true];
		[task.name setEditable:true];
		[task.note setEditable:true];
		[task.reminderCheck setEnabled:true];
		[task.doneLabel setHidden:true];
		
	}
}

-(void)getReminderTimerReady:(NSString*)taskNum{
	NSUserDefaults *savedData = [NSUserDefaults standardUserDefaults];
	if ([taskNum isEqualToString:@"one"]) {
		NSDate *date = [savedData objectForKey:@"reminderDateOne"];
		reminderDateOne = date;
		// REMOVE
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		
		NSLog(@"Date: %@", [dateFormatter stringFromDate:reminderDateOne]);
		// REMOVE 
		
		reminderTimerOne = [[NSTimer alloc] 
						 initWithFireDate:reminderDateOne 
						 interval:600
						 target:self 
						 selector:@selector(fireReminderOne:) 
						 userInfo:nil 
						 repeats:true];
		
		NSRunLoop *runner = [NSRunLoop currentRunLoop];
		[runner addTimer:reminderTimerOne forMode: NSDefaultRunLoopMode];
		//[reminderTimerOne release]; // why release here?!?!
	}
}

-(void)fireReminderOne:(NSTimer*)theTimer{
	NSUserDefaults *savedData = [NSUserDefaults standardUserDefaults];
	NSLog(@"timer went off :)");
	// IMPLEMENT: set an icon
	NSAlert *alert = [[NSAlert alloc] init];
	NSString *name = [savedData objectForKey:@"nameOne"];
	NSString *note = [savedData objectForKey:@"noteOne"];
	[alert setMessageText:name];
	[alert setInformativeText:note]; // CAN'T ACCESS THIS IF WINDOWONE ISN'T INSTANTIATED...
	[alert setAlertStyle:1];
	//[alert setAccessoryView:accessory]; if want to write more
	[alert runModal];
	[alert release];
	// REMOVE REMINDER
	
}

-(void)selector1:(NSNotification *)notification{
	//[self selector:windowOne check:checkOne name:nameOne]; - UNCOMMENT!!! 	
	NSDate *obj = [notification object];
	reminderDateOne = obj;
	NSUserDefaults *savedData = [NSUserDefaults standardUserDefaults];
	[savedData setObject:reminderDateOne forKey:@"reminderDateOne"];
	[self getReminderTimerReady:@"one"];
	
	[nameOne setStringValue:[windowOne.name stringValue]];
	
	if ([checkOne state] == 1) {
		NSMutableAttributedString *as = [[nameOne attributedStringValue] mutableCopy];
		[as addAttribute:NSStrikethroughStyleAttributeName value:(NSNumber *)kCFBooleanTrue range:NSMakeRange(0, [as length])];
		[self.nameOne setAttributedStringValue:[as autorelease]];
	}
	
	if([windowOne window] != nil){
		[[windowOne window] orderOut:self];
	}
	
	// ADDED - NEED TO FIX FOR BUTTON TWO
	// windowOne:
	
	if(self.openBeforeOne){
		NSLog(@"OpenbeforeOne is truee!!!!!");
		[savedData setBool:(BOOL)YES forKey:@"openBeforeOne"];
	} else {
		NSLog(@"OPENBEFOREONE IS FALSE");
		[savedData setBool:NO forKey:@"openBeforeOne"];
	}
	if (self.openBeforeOne) {		
		//[savedData setInteger:(NSInteger)1 forKey:@"windowOne"];
		NSLog(@"saved noteOne here");
		[savedData setObject:[self.windowOne.note stringValue] forKey:@"noteOne"];
		
		if ([self.windowOne.reminderCheck state] == 1) {
			[savedData setInteger:1 forKey:@"reminderCheckStateOne"];
			[savedData setObject:self.windowOne.reminderDate forKey:@"reminderDateOne"];
		} else {
			[savedData setInteger:0 forKey:@"reminderCheckStateOne"];
			[savedData setObject:nil forKey:@"reminderDateOne"]; // NEED?!?!
			[reminderTimerOne invalidate];
		}
		
	}
	
	[savedData synchronize];
	// ADDED DONE
	
}

-(void)selector2:(NSNotification *)notification{
	[self selector:windowTwo check:checkTwo name:nameTwo];
}

-(void)selector:(ToDoTaskController *)task check:(NSButton *) c name:(NSTextField *)n{
	[n setStringValue:[task.name stringValue]];
	
	if ([c state] == 1) {
		NSMutableAttributedString *as = [[n attributedStringValue] mutableCopy];
		[as addAttribute:NSStrikethroughStyleAttributeName value:(NSNumber *)kCFBooleanTrue range:NSMakeRange(0, [as length])];
		[n setAttributedStringValue:[as autorelease]];
	}
	
	if([task window] != nil){
		[[task window] orderOut:self];
	}
	
	// ADDED - NEED TO FIX FOR BUTTON TWO
	// windowOne:
	NSUserDefaults *savedData = [NSUserDefaults standardUserDefaults];
	if(self.openBeforeOne){ // make this better - NOT WORKING!!!
		NSLog(@"OpenbeforeOne is truee!!!!!");
		[savedData setBool:(BOOL)YES forKey:@"openBeforeOne"];
	} else {
		NSLog(@"OPENBEFOREONE IS FALSE");
		[savedData setBool:NO forKey:@"openBeforeOne"];
	}
	if (self.openBeforeOne) {		
		//[savedData setInteger:(NSInteger)1 forKey:@"windowOne"];
		[savedData setObject:[self.windowOne.note stringValue] forKey:@"noteOne"];
		if ([self.windowOne.reminderCheck state] == 1) {
			[savedData setObject:[self.windowOne.reminderCheck state] forKey:@"reminderCheckStateOne"];
			[savedData setObject:self.windowOne.reminderDate forKey:@"reminderDateOne"];
		}		
	} 
	
	[savedData synchronize];
	// ADDED DONE
}

-(IBAction)pressButtonOne:(id)sender{ // sender is the button class?!?!
	
	if(openBeforeOne){
		NSLog(@"opened before!!!");
		[[self.windowOne window] makeKeyAndOrderFront:self];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"PriorityOne" object:[self.nameOne stringValue]];
	} else {	
		NSLog(@"never opened");
		NSUserDefaults *savedData = [NSUserDefaults standardUserDefaults];
		
		NSString *nOne = [savedData stringForKey:@"noteOne"];
		
		openBeforeOne = YES;
		windowOne = [[ToDoTaskController alloc] initSpecial:@"ToDoTaskWindow" priority:@"PriorityOne"];

		// IMPLEMENT: when the check button is pressed down!!!
		
		BOOL obo = [savedData boolForKey:@"openBeforeOne"];
		if (obo) {
			NSLog(@"TEEHEEE");
			// note, reminder, name			
			NSString *note = [savedData stringForKey:@"noteOne"];			
			NSDate *date = [savedData objectForKey:@"reminderDateOne"];
			NSInteger reminderCheck = [savedData integerForKey:@"reminderCheckStateOne"];																		
			//[windowOne showWindow:windowOne];
			[[self.windowOne window] makeKeyAndOrderFront:self];
			
			// put pressed check right here?!?!

			if ([savedData integerForKey:@"checkOne"] == 1) {
				[self pressChecked:windowOne check:checkOne name:nameOne];
			}			
			
			[self.windowOne.note setStringValue:note];						
			if (reminderCheck == 1) {
				NSLog(@"reminderCheck == 1");
				[self.windowOne.reminderCheck setState:1];
				[windowOne pressReminder:nil];
				// set date:
				[self.windowOne.reminderDatePicker setDateValue:date];
				//[self.windowOne getReminderTimerReady]; // THIS NEEDS TO BE WHEN THE APP LAUNCHES
			}
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"PriorityOne" object:[self.nameOne stringValue]];
		} else { // not sure if need this clause
			[[self.windowOne window] makeKeyAndOrderFront:self];
			if ([savedData integerForKey:@"checkOne"] == 1) {
				[self pressChecked:windowOne check:checkOne name:nameOne];
			}	
			[self.windowOne.note setStringValue:nOne];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"PriorityOne" object:[self.nameOne stringValue]];	
		}


			

	}
}

-(IBAction)pressButtonTwo:(id)sender{ // sender is the button class?!?!
	
	if(openBeforeTwo){
		[[windowTwo window] orderFront:self];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"PriorityTwo" object:[self.nameTwo stringValue]];		
	} else {			
		windowTwo = [[ToDoTaskController alloc] initSpecial:@"ToDoTaskWindow" priority:@"PriorityTwo"];
		[windowTwo showWindow:windowTwo];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"PriorityTwo" object:[self.nameTwo stringValue]];	
		openBeforeTwo = YES;
	}
	
}

-(void)dealloc{ // UPDATE!!!
//	[one release];
//	[two release];
//	[savedData release];
	
	[windowOne release];
	[windowTwo release];
	[[NSNotificationCenter defaultCenter]removeObserver:self];
	[super dealloc];
}

@end