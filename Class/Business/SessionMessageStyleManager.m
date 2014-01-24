//
//  SessionMessageStyleManager.m
//  HealthManager
//
//  Created by user on 14-1-24.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "SessionMessageStyleManager.h"

#define APPEND_MESSAGE @"appendMessage(\"%@\");"

static SessionMessageStyleManager* _sharedInstance = nil;

@implementation SessionMessageStyleManager
@synthesize baseHTML,baseURL;

-(void)loadTemplate{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"Template" ofType:@"html"];
    
    NSString *htm = [NSString stringWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:nil];
    baseURL = [NSURL fileURLWithPath:path];
    baseHTML = [NSString stringWithFormat:htm,						//Template
                [[NSBundle mainBundle] bundlePath],					//Base path
                @"@import url( \"Renkoo/Styles/main.css\" );",		//Import main.css for new enough styles
                @"Renkoo/Variants/Green on Red Alternating.css",	//Variant path
                @"",
                (@"")];
    NSString * contentOutHTMLpath =  [[NSBundle mainBundle] pathForResource:@"Content" ofType:@"html" inDirectory:@"Renkoo/Outgoing"];
    contentOutHTML =  [NSString stringWithContentsOfFile:contentOutHTMLpath encoding:NSUTF8StringEncoding error:nil];
    NSString * contentInHTMLpath =  [[NSBundle mainBundle] pathForResource:@"Content" ofType:@"html" inDirectory:@"Renkoo/Incoming"];
    contentInHTML =  [NSString stringWithContentsOfFile:contentInHTMLpath encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"content in html data is :%@", contentInHTML);
}

- (NSArray *)availableVariants
{
	NSMutableArray	*availableVariants = [NSMutableArray array];
	for (NSString *path in [[NSBundle mainBundle] pathsForResourcesOfType:@"css" inDirectory:@"Renkoo/Variants"]) {
		[availableVariants addObject:[[path lastPathComponent] stringByDeletingPathExtension]];
	}
	//Alphabetize the variants
	[availableVariants sortUsingSelector:@selector(localizedStandardCompare:)];
	
	return availableVariants;
}



-(NSString *)appendScriptForMessage:(SessionMessage *)msg {
    NSString * newHTML= nil;
    if ( msg.sendType == SessionMessageSendTypeMe ) {
        newHTML = [contentInHTML copy];
        newHTML = [newHTML stringByReplacingOccurrencesOfString:@"%messageClasses%" withString:@"incoming message"];
        newHTML = [newHTML stringByReplacingOccurrencesOfString:@"%userIconPath%" withString:@"Renkoo/incoming_icon.png"];
    }else{
        newHTML = [contentOutHTML copy];
        newHTML = [newHTML stringByReplacingOccurrencesOfString:@"%messageClasses%" withString:@"outgoing message"];
        if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"doctorImage"]) {
            newHTML = [newHTML stringByReplacingOccurrencesOfString:@"%userIconPath%" withString:[[NSUserDefaults standardUserDefaults] objectForKey:@"doctorImage"]];
        }
        else {
            newHTML = [newHTML stringByReplacingOccurrencesOfString:@"%userIconPath%" withString:@"Renkoo/outgoing_icon.png"];
        }
        
    }
    newHTML = [newHTML stringByReplacingOccurrencesOfString:@"%sender%" withString:msg.senderName];
//    newHTML = [newHTML stringByReplacingOccurrencesOfString:@"%time%" withString:msg.timeStamp];
    
//    for (NSString *emo in [self emotionKeysFrom:msg.content]){
//        
//        if ([self.emotions valueForKey:emo]) {
//            
//            msg.content = [msg.content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"[%@]",emo] withString:[NSString stringWithFormat:@"<img src=\"%@\" , width = 25, height = 25>",[self.emotions valueForKey:emo]]] ;
//        }
//        
//    }
    newHTML = [newHTML stringByReplacingOccurrencesOfString:@"%message%" withString:msg.content];
    return [NSString stringWithFormat:APPEND_MESSAGE, [self _escapeStringForPassingToScript:newHTML]];
    
}

- (NSString *)_escapeStringForPassingToScript:(NSString *)inString
{
	inString =[inString stringByReplacingOccurrencesOfString:@"\\"
                      withString:@"\\\\"
               ];
	inString= [inString stringByReplacingOccurrencesOfString:@"\""
                      withString:@"\\\""
               ];
	inString =[inString stringByReplacingOccurrencesOfString:@"\n"
                      withString:@""
               ];
	inString = [inString stringByReplacingOccurrencesOfString:@"\r"
                       withString:@"<br>"
                ];
	return inString;
}


+ (SessionMessageStyleManager *)sharedInstance {
    if (!_sharedInstance)
    {
        _sharedInstance = [[SessionMessageStyleManager alloc] init];
    }
    return _sharedInstance;
}

@end
