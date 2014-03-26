//
//  Fine.m
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "Fine.h"

@implementation Fine

- (id)initWithArray:(NSArray *)array {
    
    self = [super init];
    if (self) {
        
        if (array.count >= 5) {
            
            self.plate = array[0];
            self.dateString = array[1];
            self.address = array[2];
            self.id = array[3];
            self.description = array[4];
            
        }
    }
    
    return self;
}

@end
