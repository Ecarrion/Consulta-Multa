//
//  ChooseViewController.m
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "ChooseViewController.h"
#import "SelectAddressViewController.h"

@interface ChooseViewController () <UITextFieldDelegate>

@end

@implementation ChooseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"Ingresa tu placa";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Atras" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([plateTextField respondsToSelector:@selector(setTintColor:)]) {
        plateTextField.tintColor = GREEN_APP_COLOR;
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [plateTextField becomeFirstResponder];
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    [self.consultaController reloadBaseUrlOnCompletion:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [self.consultaController selectSearchCriteria:1 onCompletion:^(NSError *error) {
       
        if (!error) {
            
            [self.consultaController setPlate:textField.text onCompletion:^(NSError *error) {
                [SVProgressHUD dismiss];
                
                if (!error) {
                    
                    SelectAddressViewController * savc = [[SelectAddressViewController alloc] init];
                    [self.navigationController pushViewController:savc animated:YES];
                    
                } else {
                    
                    puts("finished with error");
                }
                
            }];
            
        } else {
            
            [SVProgressHUD dismiss];
        }
        
    }];
    
    return [textField resignFirstResponder];
}

#pragma mark - Status Bar


#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && self.view.window == nil) {
        
        self.view = nil;
    }
    
    if (![self isViewLoaded]) {
        
        //Clean outlets here
    }
    
    //Clean rest of resources here eg:arrays, maps, dictionaries, etc
}

@end
