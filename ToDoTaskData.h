//
//  ToDoTaskData.h
//  ToDoList
//
//  Created by Tiffany Lee on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ToDoTaskData : NSObject {
	NSMutableString *taskName;
	NSMutableString *note;
}

@property (retain) NSMutableString *taskName;
@property (retain) NSMutableString *note;

-(void)dealloc;

@end
