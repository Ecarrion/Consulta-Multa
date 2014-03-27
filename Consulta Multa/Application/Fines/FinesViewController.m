//
//  FinesViewController.m
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "FinesViewController.h" 
#import "Fine.h"

@interface FinesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray * fines;

@end

@implementation FinesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"Multas";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fines = [self.consultaController getFines];
    if (self.fines.count == 0) {
        
        UIAlertView * a = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Lo siento, la dirección que seleccionaste no fue la correcta" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [a show];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.fines.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FineCell"];
    
    Fine * fine = self.fines[indexPath.row];
    cell.textLabel.text = fine.description;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [self.consultaController openPDFAtIndex:indexPath.row onCompletion:^(NSError *error) {
        
        if (!error) {
            
            //Little hack for giving time to the pdf to render
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                [self.consultaController showWebView];
            });
            
        } else {
            
            [SVProgressHUD dismiss];
        }
    }];
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
