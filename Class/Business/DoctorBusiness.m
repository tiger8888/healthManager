//
//  DoctorBusiness.m
//  HealthManager
//
//  Created by user on 14-1-27.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "DoctorBusiness.h"
#import "SessionMessageSqlite.h"
#import "SessionMessage.h"

static DoctorBusiness *_sharedManager;

@implementation DoctorBusiness
+ (DoctorBusiness *)sharedManager
{
    @synchronized(self)
    {
        if (_sharedManager == nil)
        {
            _sharedManager = [[self alloc] init];
        }
    }
    return _sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_sharedManager == nil)
        {
            _sharedManager = [super allocWithZone:zone];
            return _sharedManager;
        }
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _tmpData = [[NSMutableData alloc] init];
    }
    return self;
}

- (NSString *)getCurrentPatientID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY];
}

- (void)getAllDoctor:(void(^)(NSArray *arr))block superView:(UIView *)superView
{
    [[HttpRequestManager sharedManager] requestWithParameters:nil interface:[NSString stringWithFormat:@"patient/doctor/list/%@.json",[self getCurrentPatientID]] completionHandle:^(id returnObject) {
        //        NSLog(@"%@",[[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding]);
        
        NSDictionary * returnDict = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        block([[returnDict objectForKey:@"resultInfo"] objectForKey:@"list"]);        
    } failed:^{
        
    } hitSuperView:superView method:kGet];
}

- (void)setMyDoctorInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *patientId = [userDefaults objectForKey:PATIENTID_KEY];
    
    NSString *interfaceUrl = [NSString stringWithFormat:@"patient/doctor/%@.json",patientId];
    [[HttpRequestManager sharedManager] requestWithParameters:nil interface:interfaceUrl completionHandle:^(id returnObject) {
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *result = [dataDictionary objectForKey:@"resultInfo"];
        if ( [[Message sharedManager] checkReturnInformationWithInterface:result] ) {
            NSDictionary *doctorInfo = [result objectForKey:@"doctor"];
            NSString *doctorImage = [doctorInfo objectForKey:@"picUrl"];
            
            [userDefaults setObject: [doctorInfo objectForKey:@"name"] forKey:DOCTOR_NAME_KEY];
            [userDefaults setObject:doctorImage forKey:DOCTOR_IMAGE_KEY];
            [userDefaults synchronize];
        }
        
    } failed:^{
        ALERT(@"网络错误", @"您当前的网络不可用，请检查网络后重试", @"返回");
    } hitSuperView:nil method:kGet];
}

- (void)setMyDoctorInfoSync {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *patientId = [userDefaults objectForKey:PATIENTID_KEY];
    
    NSString *interfaceUrl = [NSString stringWithFormat:@"patient/doctor/%@.json",patientId];
    NSLog(@"get doctorinfo interface url is :%@", interfaceUrl);
    [self request:[NSData new] interface:interfaceUrl completionHandle:^(id returnObject) {
//        NSString *str = [[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding];
//        NSLog(@"SUCCESS INFO:%@",str);
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *result = [returnDict categoryObjectForKey:@"resultInfo"];
        if ( [[Message sharedManager] checkReturnInfor:result] ) {
            NSDictionary *doctorInfo = [result objectForKey:@"doctor"];
            NSString *doctorImage = [doctorInfo objectForKey:@"picUrl"];
            
            [userDefaults setObject: [doctorInfo objectForKey:@"name"] forKey:DOCTOR_NAME_KEY];
            [userDefaults setObject:doctorImage forKey:DOCTOR_IMAGE_KEY];
            [userDefaults synchronize];
            
            //            _titleLabel.text = [[doctorInfo objectForKey:@"name"] stringByAppendingString: @"医生"];
            //            [self getAllSessionInfo];
            //            [self getDoctorSessionInfo:nil];
            NSLog(@"set my doctor information");
        }

    } failed:^{
        ALERT(@"网络错误", @"您当前的网络不可用，请检查网络后重试", @"返回");
        NSLog(@"error in method name: %s", __FUNCTION__);
    } hitSuperView:nil requestMethod:kGet];
    
}

- (void)addMyDoctor:(id)obj
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:obj forKey:DOCTORID_KEY];
    [userDef synchronize];
    
    NSString *url = [NSString stringWithFormat:@"patient/doctor/add/%@/%@.json",[userDef objectForKey:PATIENTID_KEY],obj];
    NSLog(@"%@",url);
    [[HttpRequestManager sharedManager] requestWithParameters:nil interface:url completionHandle:^(id returnObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding]);
        
    } failed:^{
        
    } hitSuperView:nil method:kPost];

}

- (void)deleteMyDoctor
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *patientId = [userDefaults objectForKey:PATIENTID_KEY];
    NSString *doctorId = [userDefaults objectForKey:DOCTORID_KEY];
    
    if (doctorId>0 && patientId>0) {
        NSString *url = [NSString stringWithFormat:@"patient/doctor/delete/%@/%@.json", patientId, doctorId];
        NSLog(@"%@",url);
        [[HttpRequestManager sharedManager] requestWithParameters:nil interface:url  completionHandle:^(id returnObject) {
            
            NSLog(@"delete my doctor:%@",[[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding]);
            
        } failed:^{
            
        } hitSuperView:nil method:kPost];
    }
    else {
        NSLog(@"当前患者[%@]的医生ID丢失", patientId);
    }
    [userDefaults removeObjectForKey:DOCTORID_KEY];
    [userDefaults removeObjectForKey:DOCTOR_NAME_KEY];
    [userDefaults removeObjectForKey:DOCTOR_IMAGE_KEY];
    [userDefaults synchronize];
}

- (void)getMyDoctorSessionInfo:(void(^)(SessionMessage* msg))block withSuperView:(UIView *)superView
{    NSString *interfaceUrl = [NSString stringWithFormat:@"chat/list/%@.json", [[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY]];
    
    [[HttpRequestManager sharedManager] requestWithParameters:nil interface:interfaceUrl completionHandle:^(id returnObject) {
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *result = [dataDictionary objectForKey:@"resultInfo"];
        if ( [[Message sharedManager] checkReturnInformationWithInterface:result] ) {
            NSArray *sessionMessageInfoArray = [result objectForKey:@"list"];
            SessionMessage *sessionMsg = [SessionMessage new];
            sessionMsg.patientId = [[[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY] intValue];
            
            for (NSDictionary *msgItem in sessionMessageInfoArray ) {
                sessionMsg.id = 0;
                sessionMsg.senderId = [[msgItem objectForKey:@"doctorId"] intValue];
                sessionMsg.doctorId = [[msgItem objectForKey:@"doctorId"] intValue];
                sessionMsg.senderName = [msgItem objectForKey:@"doctorName"];
                sessionMsg.sendType = SessionMessageSendTypeOther;
                sessionMsg.content = [msgItem objectForKey:@"msg"];
                sessionMsg.timeStamp = [msgItem objectForKey:@"createTime"];
                
                [[SessionMessageSqlite sharedManager] insertOne:sessionMsg];
                block(sessionMsg);
            }
        }
        
    } failed:^{
        ALERT(@"网络错误", @"您当前的网络不可用，请检查网络后重试", @"返回");
    } hitSuperView:superView method:kGet];
}

- (NSArray *)getMyDoctorAllSessionInfo {
    int doctorId = [[[NSUserDefaults standardUserDefaults] objectForKey:DOCTORID_KEY] intValue];
    int patiendId = [[[NSUserDefaults standardUserDefaults] objectForKey:PATIENTID_KEY] intValue];
    
    NSArray *sessionMsgArr = [[SessionMessageSqlite sharedManager] queryAll:doctorId withPatientId:patiendId];
    return sessionMsgArr;
}

- (void)sendSessionMessageToMydoctor:(SessionMessage *)msg withBlock:(void(^)(void))block superView:(UIView *)superView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:[userDefaults objectForKey:DOCTORID_KEY] forKey:@"doctorId"];
    [parameter setObject:msg.content forKey:@"msg"];
    
    NSString *interfaceUrl = [NSString stringWithFormat:@"chat/patient/add/%d.json", msg.senderId];
    
    [[HttpRequestManager sharedManager] requestWithParameters:parameter interface:interfaceUrl completionHandle:^(id returnObject) {        
        [[SessionMessageSqlite sharedManager] insertOne:msg];
        block();
    } failed:^{
        ALERT(@"网络错误", @"您当前的网络不可用，请检查网络后重试", @"返回");
    } hitSuperView:superView method:kPost];
}


#pragma mark - network request method
- (void)request:(NSData *)data interface:(NSString *)interface completionHandle:(LSJSONBlock)block failed:(void(^)(void))failedBlock hitSuperView:(UIView *)superView requestMethod:(requestMethod)method;
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[BASEURL stringByAppendingPathComponent:interface]]];
    
    switch (method) {
        case kPost:
            [request setHTTPMethod:@"POST"];

            break;
        case kGet:
            [request setHTTPMethod:@"GET"];
            break;
        default:
            break;
    }
                [request setHTTPBody:data];
    
    _completeBlock = block;
    _failedBlock = failedBlock;
    
    if (superView) {
        [MBProgressHUD showHUDAddedTo:superView animated:YES];
    }
    
    NSData *reeived = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    block(reeived);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_tmpData resetBytesInRange:NSMakeRange(0, _tmpData.length)];
    [_tmpData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_tmpData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
    
    if (_failedBlock) {
        _failedBlock();
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_completeBlock) {
        _completeBlock(_tmpData);
    }
}

@end
