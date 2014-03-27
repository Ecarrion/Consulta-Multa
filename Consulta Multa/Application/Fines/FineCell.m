//
//  FineCell.m
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/27/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "FineCell.h"
#define DESCRIPTION_FRAME CGRectMake(16, 38, 297, 61)

@implementation FineCell

-(void)awakeFromNib {
    
    viewButton.layer.cornerRadius = 6;
}

-(void)prepareForReuse {
    
    self.descriptionLabel.frame = DESCRIPTION_FRAME;
    
}

- (IBAction)viewPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(viewButtonPressedInCell:)]) {
        
        [self.delegate viewButtonPressedInCell:self];
    }
}


@end
