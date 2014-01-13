//
//  ConstantAndDefine.h
//  HealthManager
//
//  Created by LiShuo on 13-11-29.
//
//

#ifndef HealthManager_ConstantAndDefine_h
#define HealthManager_ConstantAndDefine_h

typedef enum {
    kMainViewController = 0,
    kBlood = 1,
    kDoctor,
    kAlert,
    kManager,
    kKnowledge,
    kSetting,
    kMore
} kPartType;

#define BASEURL @"www.baidu.com:8080"
#define DEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define DEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define FULLSCREEN CGRectMake(0, 44, DEVICE_WIDTH, DEVICE_HEIGHT -44 -20)
#define IS_IPHONE4 (CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size))
#define IS_IPHONE5 (CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size))
#define UICOLORFROMRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define FONT_DETAIL [UIFont systemFontOfSize:14]
/**
 *  基类
 */
#import "AppDelegate.h"
#import "RootSuperViewController.h"
#import "NavigationBarViewController.h"
#import "BackButtonViewController.h"
#import "SuperListViewController.h"

#import "RootSuperCell.h"

/**
 *  功能模块类
 */
#import "LoginViewController.h"
#import "MainViewController.h"
#import "BloodViewController.h"
#import "DoctorViewController.h"
#import "AlertViewController.h"
#import "ManagerViewController.h"
#import "KnowledgeViewController.h"
#import "SettingViewController.h"
#import "MoreViewController.h"
/**
 *  模型类
 */
#import "Knowledge.h"

/**
 *  控件，工具，库等
 */
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "LSBackGrayView.h"
#import "BloodRecord.h"
#import "HttpRequestManager.h"
#import "MBProgressHUD.h"
#endif


