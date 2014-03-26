//
//  ConsultaNavigationViewController.h
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^webCompletionBlock)(NSError * error);

@interface ConsultaNavigationViewController : UINavigationController

-(void)reloadBaseUrlOnCompletion:(webCompletionBlock)block;
-(void)selectSearchCriteria:(NSInteger)number onCompletion:(webCompletionBlock)block;
-(void)setPlate:(NSString *)plate onCompletion:(webCompletionBlock)block;
-(void)selectAddress:(NSInteger)addresIndex onCompletion:(webCompletionBlock)block;
-(void)openPDFAtIndex:(NSInteger)index onCompletion:(webCompletionBlock)block;


-(NSArray *)getAddresses;
-(NSArray *)getFines;

@end
