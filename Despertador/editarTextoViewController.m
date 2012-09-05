//
//  editarTextoViewController.m
//  Despertador
//
//  Created by Aitor Brazaola on 30/05/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import "editarTextoViewController.h"

@interface editarTextoViewController ()

@end

@implementation editarTextoViewController
@synthesize cadena, textField, tituloVentana;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        navigationItem=[self navigationItem];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [navigationItem setTitle:tituloVentana];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [textField setText:cadena];
    [textField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    cadena=[textField text];
}

#pragma mark - Delegado de el textview
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[self navigationController]popViewControllerAnimated:YES];    
    return YES;
}
@end
