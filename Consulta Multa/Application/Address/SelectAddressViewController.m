//
//  SelectAddressViewController.m
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "SelectAddressViewController.h"
#import "FinesViewController.h"

@interface SelectAddressViewController ()

@property (nonatomic, strong) NSArray * addresses;

@end

@implementation SelectAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Elige tu dirección";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.addresses = [self.consultaController getAddresses];
    if (!self.addresses) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Enhorabuena!" message:@"No tienes fotomultas" delegate:nil cancelButtonTitle:@"Continuar" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)goPressed:(id)sender {
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSInteger index = [addressTableView indexPathForSelectedRow].row;
    [self.consultaController selectAddress:index onCompletion:^(NSError *error) {
        [SVProgressHUD dismiss];
        
        if (!error) {
            
            FinesViewController * fvc = [[FinesViewController alloc] init];
            [self.navigationController pushViewController:fvc animated:YES];
        }
    }];
}


#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addresses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"AddressCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.addresses[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

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
