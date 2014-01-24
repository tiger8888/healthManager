//
//  SessionMessageStyleManager.h
//  HealthManager
//
//  Created by user on 14-1-24.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionMessage.h"

@interface SessionMessageStyleManager : NSObject
{
    NSURL		*baseURL;
	NSString	*headerHTML;
	NSString	*footerHTML;
	NSString	*baseHTML;
	NSString	*contentHTML;
	NSString	*contentInHTML;
	NSString	*nextContentInHTML;
	NSString	*contextInHTML;
	NSString	*nextContextInHTML;
	NSString	*contentOutHTML;
	NSString	*nextContentOutHTML;
	NSString	*contextOutHTML;
	NSString	*nextContextOutHTML;
	NSString	*statusHTML;
	NSString	*fileTransferHTML;
	NSString	*topicHTML;
//    NSDictionary *emotions;
}

@property(nonatomic,strong)NSURL *baseURL;
@property(nonatomic,strong)NSString	*baseHTML;

+ (SessionMessageStyleManager *)sharedInstance;
- (void)loadTemplate;
- (NSString *)appendScriptForMessage:(SessionMessage *)content;
//- (NSString *)scriptForChangingVariant:(NSString *)variant;
- (NSArray *)availableVariants;
@end
