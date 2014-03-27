//
//  FineCell.h
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/27/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FineCell;
@protocol FineCellDelegate <NSObject>

-(void)viewButtonPressedInCell:(FineCell *)fineCell;

@end

@interface FineCell : UITableViewCell {
    
    
    __weak IBOutlet UIButton *viewButton;
    
}

@property (nonatomic, strong) IBOutlet UILabel * dateLabel;
@property (nonatomic, strong) IBOutlet UILabel * addressLabel;
@property (nonatomic, strong) IBOutlet UILabel * descriptionLabel;
@property (nonatomic, weak) id<FineCellDelegate> delegate;

@end
