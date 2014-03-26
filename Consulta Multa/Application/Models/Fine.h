//
//  Fine.h
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fine : NSObject

@property (nonatomic, strong) NSString * plate;
@property (nonatomic, strong) NSString * dateString;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * description;

- (id)initWithArray:(NSArray *)array;


@end
