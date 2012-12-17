//
//  ToDoTaskData.m
//  ToDoList
//
//  Created by Tiffany Lee on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ToDoTaskData.h"


@implementation ToDoTaskData

@synthesize taskName, note;

-(void)dealloc{
	[taskName release];
	[note release];
	[super dealloc];
}

@end
