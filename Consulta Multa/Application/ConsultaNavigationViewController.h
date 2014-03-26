//
//  ConsultaNavigationViewController.h
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsultaNavigationViewController : UINavigationController


-(void)selectSearchCriteria:(NSInteger)number;
-(void)setPlate:(NSString *)plate;
-(void)selectAddress:(NSInteger)addresIndex;
-(void)openPDFAtIndex:(NSInteger)index;

@end
