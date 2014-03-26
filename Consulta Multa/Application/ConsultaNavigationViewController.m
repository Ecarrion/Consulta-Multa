//
//  ConsultaNavigationViewController.m
//  Consulta Multa
//
//  Created by Ernesto Carrion on 3/26/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "ConsultaNavigationViewController.h"

#define FOTOMULTAS_BASE_URL @"http://www.medellin.gov.co/qxi_tramites/consultas/consultarComparendoElectronico.jsp"

@interface ConsultaNavigationViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView;

@end

@implementation ConsultaNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = NO;
    self.webView.alpha = 0.7;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
    [self reloadBaseUrl];
}

-(void)reloadBaseUrl {
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:FOTOMULTAS_BASE_URL]];
    [self.webView loadRequest:request];
}

#pragma mark - Foto multa methods
-(void)selectSearchCriteria:(NSInteger)number {
    
    NSString * line1 = @"select = document.getElementsByName(\"criterioBusqueda\")[0];";
    NSString * line2 = [NSString stringWithFormat:@"select.options[%d].selected = true;", number];
    NSString * line3 = @"document.ConsultarComparendoElectronicoForm.submit();";
    NSString * js = [NSString stringWithFormat:@"%@ %@ %@", line1, line2, line3];
    
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

-(void)setPlate:(NSString *)plate {
    
    NSString * line1 = @"placa = document.getElementsByName(\"placa\")[0];";
    NSString * line2 = [NSString stringWithFormat:@"placa.value = \"%@\";", plate];
    NSString * line3 = @"consultarBut = document.getElementsByClassName(\"button\")[0];";
    NSString * line4 =  @"consultarBut.click();";
    NSString * js = [NSString stringWithFormat:@"%@ %@ %@ %@", line1, line2, line3, line4];
    
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

-(void)selectAddress:(NSInteger)addresIndex {
    
    NSString * line1 = @"radios = document.getElementsByName(\"direccionSeleccionada\");";
    NSString * line2 = [NSString stringWithFormat:@"radios[%d].checked = true;", addresIndex];
    NSString * line3 = @"consultarBut = document.getElementsByClassName(\"button\")[0];";
    NSString * line4 =  @"consultarBut.click();";
    //NSString * line4 =  @"";
    NSString * js = [NSString stringWithFormat:@"%@ %@ %@ %@", line1, line2, line3, line4];
    
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

-(void)openPDFAtIndex:(NSInteger)index {
    
    NSString * line1 = [NSString stringWithFormat:@"pdfLink = document.getElementById(\"resultados2\").getElementsByTagName(\"a\")[%d];", index];
    NSString * line2 = @"pdfLink.click();";
    NSString * js = [NSString stringWithFormat:@"%@ %@", line1, line2];
    
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

#pragma mark - WebView

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    puts(request.URL.absoluteString.UTF8String);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    puts("start");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    puts("finish");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    puts("fail");
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
