//
//  instruccionesViewController.m
//  Desperta+
//
//  Created by Aitor Brazaola on 11/07/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import "instruccionesViewController.h"

@interface instruccionesViewController ()

@end

@implementation instruccionesViewController

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
    // Do any additional setup after loading the view from its nib.
    [tituloMensaje setText:NSLocalizedString(@"Mensaje Importante!", @"TituloMensaje")];
    [textView setText:NSLocalizedString(@"Para que esta app funcione correctamente, recomendamos que antes de ir a dormir, bloquees el telefono teniendo la app abierta, de este modo cuando suene la alarma y desbloquees el telefono, podras ver la pantalla de suma.Nada mas, esperamos que disfrutes la app y nos dejes tu valoracion en iTunes!", @"AvisoPrimeraVez")];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - IBActions
-(IBAction)comenzar:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
