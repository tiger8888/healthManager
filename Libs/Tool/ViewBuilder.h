//
//  ViewBuilder.h
//  HealthManager
//
//  Created by PanPeng on 14-1-23.
//  Copyright (c) 2014年 PanPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewBuilder : NSObject
+ (ViewBuilder *)sharedManager;
- (UILabel *)LabelWithMultiLinesFitHeight:(NSString *)str withLeft:(int)left withTop:(int)top withWidth:(int)width withFont:(UIFont *)font;
@end
