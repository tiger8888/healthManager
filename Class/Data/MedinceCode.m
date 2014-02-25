//
//  MedinceCode.m
//  HealthManager
//
//  Created by user on 14-2-24.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "MedinceCode.h"

@implementation MedinceCode
- (id)init
{
    self = [super init];
    
    if (self) {
    
    }
    
    return self;
}
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
//    NSLog(@"\t%@ found a %@ element", self, elementName);

        if ([elementName isEqual:@"code"]) {
            _currentString = [[NSMutableString alloc] init];
            NSLog(@"value:%@", elementName);
//            [self setCode:_currentString];
        }
        else if ([elementName isEqual:@"firstQuery"]) {
            _currentString = [[NSMutableString alloc] init];
//            [self setFirstQueryTime:_currentString];
        }
        else if ([elementName isEqual:@"infos"]) {
            _parseIndex = 0;
        }
        else if ([elementName isEqual:@"extraInfos"]) {
            _parseIndex = 100;
        }
        else if ([elementName isEqual:@"value"]) {
            _currentString = [[NSMutableString alloc] init];
            _parseIndex++;
        }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)str
{
    [_currentString appendString:str];
}
- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqual:@"code"]) {
        NSLog(@"value:%@", elementName);
        [self setCode:_currentString];
    }
    else if ([elementName isEqual:@"firstQuery"]) {
        NSLog(@"value:%@", elementName);
        [self setFirstQueryTime:_currentString];
    }
    else if ([elementName isEqual:@"value"]) {
        NSLog(@"value:%@", elementName);
        switch (_parseIndex) {
            case 1:
                [self setName:_currentString];
                break;
            case 2:
                [self setProductCode:_currentString];
                break;
            case 3:
                [self setOutputCompany:_currentString];
                break;
            case 4:
                [self setOutputBatch:_currentString];
                break;
            case 5:
                [self setOutputDate:_currentString];
                break;
            case 6:
                [self setValidExpire:_currentString];
                break;
            case 101:
                [self setFormulationCode:_currentString];
                break;
            case 102:
                [self setDosageSpecification:_currentString];
                break;
            case 103:
                [self setDosageUnit:_currentString];
                break;
            case 104:
                [self setPackUnit:_currentString];
                break;
            case 105:
                [self setPackSpecification:_currentString];
                break;
            case 106:
                [self setCategory:_currentString];
                break;
            case 107:
                [self setApprovalNumber:_currentString];
                break;
            case 108:
                [self setApprovalNumberValidExpire:_currentString];
                break;
            case 109:
                if (_currentString.length>7) {
                    [self setCirculationUnit:[_currentString substringFromIndex:7]];
                    self.circulationUnit = [self.circulationUnit stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"”"]];
                }
                break;

            default:
                break;
        }
    }
}

@end
