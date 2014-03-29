//
//  SelectAddressViewController.h
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectAddressViewController : UIViewController {
    
    __weak IBOutlet UITableView *addressTableView;
    __weak IBOutlet UIButton *continueButton;
    __weak IBOutlet UIImageView *noFinesView;
    __weak IBOutlet UILabel *infoLabel;
    
    
}

@end
