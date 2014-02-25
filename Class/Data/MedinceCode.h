//
//  MedinceCode.h
//  HealthManager
//
//  Created by user on 14-2-24.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedinceCode : NSObject<NSXMLParserDelegate>
{
    NSMutableString *_currentString;
    int _parseIndex;
}

@property (nonatomic, copy) NSString *code;//药监码
@property (nonatomic, copy) NSString *firstQueryTime;//第一次查询时间
@property (nonatomic, copy) NSString *name;//产品名称
@property (nonatomic, copy) NSString *productCode;//商品条码
@property (nonatomic, copy) NSString *outputCompany;//生产企业
@property (nonatomic, copy) NSString *outputBatch;//生产批次
@property (nonatomic, copy) NSString *outputDate;//生产日期
@property (nonatomic, copy) NSString *validExpire;//有效期至
@property (nonatomic, copy) NSString *formulationCode;//剂型代码
@property (nonatomic, copy) NSString *dosageSpecification;//制剂规格
@property (nonatomic, copy) NSString *dosageUnit;//制剂单位
@property (nonatomic, copy) NSString *packUnit;//包装单位
@property (nonatomic, copy) NSString *packSpecification;//包装规格
@property (nonatomic, copy) NSString *category;//药品类别
@property (nonatomic, copy) NSString *approvalNumber;//批准文号
@property (nonatomic, copy) NSString *approvalNumberValidExpire;//批准文号有效期
@property (nonatomic, copy) NSString *circulationUnit;//药品当前的状态信息（即流向单位）
@end
