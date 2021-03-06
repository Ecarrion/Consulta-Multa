//
//  ConsultaNavigationViewController.h
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kPlate = 1,
    kUser = 2,
} SearchCriteriaType;

typedef enum : NSUInteger {
    kCC = 1,
    kCE,
    kNIT,
    kPassport,
    kTI,
} IdType;

typedef void(^webCompletionBlock)(NSError * error);

@interface ConsultaNavigationViewController : UINavigationController {
    
}

-(void)reloadBaseUrlOnCompletion:(webCompletionBlock)block;
-(void)selectSearchCriteria:(SearchCriteriaType)type onCompletion:(webCompletionBlock)block;
-(void)setPlate:(NSString *)plate onCompletion:(webCompletionBlock)block;
-(void)setID:(NSString *)id forIdType:(IdType)type onCompletion:(webCompletionBlock)block;
-(void)selectAddress:(NSInteger)addresIndex onCompletion:(webCompletionBlock)block;
-(void)openPDFAtIndex:(NSInteger)index onCompletion:(webCompletionBlock)block;
-(BOOL)getToManyAttepmsError;

-(void)showWebView;
-(void)hideWebView;

-(void)handleError:(NSError *)error;

-(NSArray *)getAddresses;
-(NSArray *)getFines;

@end
