//
//  ChooseViewController.h
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseViewController : GAITrackedViewController {
    
    
    __weak IBOutlet UIView *valueHolder;
    __weak IBOutlet UITextField *plateTextField;
    __weak IBOutlet UILabel *label;
    
    
    __weak IBOutlet UISegmentedControl *typeSegmented;
    __weak IBOutlet UISegmentedControl *userIDSegmented;
    
    
}

@end
