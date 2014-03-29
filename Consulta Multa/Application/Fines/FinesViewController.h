//
//  FinesViewController.h
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinesViewController : UIViewController {
    
    
    __weak IBOutlet UILabel *infoLabel;
    __weak IBOutlet UIImageView *imageView;
    
}


@property (weak, nonatomic) IBOutlet UITableView *finesTableView;

@end
