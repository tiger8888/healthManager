//
//  KnowledgeDetailViewController.h
//  HealthManager
//
//  Created by 潘朋 on 14-1-9.
//  Copyright (c) 2014年 PanPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KnowledgeDetailViewController : BackButtonViewController<UIWebViewDelegate>

//@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) Knowledge *knowledgeModel;
@end
