//
//  ToDoList.h
//  ToDoList
//
//  Created by Tiffany Lee on 7/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ToDoTaskData.h"
#import "ToDoTaskController.h"

@interface ToDoList : NSWindowController <NSApplicationDelegate>{
	
	IBOutlet NSTextField *nameOne;
	IBOutlet NSTextField *nameTwo;
	IBOutlet NSButton *buttonOne;
	IBOutlet NSButton *buttonTwo;
	IBOutlet NSButton *checkOne;
	IBOutlet NSButton *checkTwo;
	BOOL openBeforeOne;
	BOOL openBeforeTwo;
	NSDate *reminderDateOne;
	NSDate *reminderDateTwo;
	NSTimer *reminderTimerOne;
	NSTimer *reminderTimerTwo;

	ToDoTaskController *windowOne;
	ToDoTaskController *windowTwo;
}

@property (nonatomic, retain) IBOutlet NSTextField *nameOne;
@property (nonatomic, retain) IBOutlet NSTextField *nameTwo;
@property (nonatomic, retain) IBOutlet NSButton *buttonOne;
@property (nonatomic, retain) IBOutlet NSButton *buttonTwo;
@property (nonatomic, retain) IBOutlet NSButton *checkOne;
@property (nonatomic, retain) IBOutlet NSButton *checkTwo;

@property (nonatomic) BOOL openBeforeOne;
@property (nonatomic) BOOL openBeforeTwo;
@property (nonatomic,retain) NSDate *reminderDateOne;
@property (nonatomic,retain) NSDate *reminderDateTwo;
@property (nonatomic,retain) NSTimer *reminderTimerOne;
@property (nonatomic,retain) NSTimer *reminderTimerTwo;

@property (nonatomic, retain) ToDoTaskController *windowOne;
@property (nonatomic, retain) ToDoTaskController *windowTwo;


// NEED UPDATING
-(IBAction)reminder:(id)sender;
-(IBAction)pressCheckedOne:(id)sender;
-(IBAction)pressCheckedTwo:(id)sender;
-(void)pressChecked:(ToDoTaskController *)task check:(NSButton *)c name:(NSTextField *)n;
-(IBAction)pressButtonOne:(id)sender;
-(IBAction)pressButtonTwo:(id)sender;
//-(void)pressButton:(ToDoTaskController *)task name:(NSTextField *)n openBefore:(bool)b msg:(NSString*)m;
-(void)selector1:(NSNotification *)notification;
-(void)selector2:(NSNotification *)notification;
-(void)dealloc;

@end
