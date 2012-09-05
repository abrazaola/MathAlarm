//
//  alarmasViewController.h
//  Despertador
//
//  Created by Aitor Brazaola on 16/05/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class nuevaAlarmaViewController;
@class alarmaViewController;

@interface listaAlarmasViewController : UITableViewController
{
    NSMutableArray *arrayAlarmas;
    NSTimer *timer;
    
    UINavigationItem *navigationItem;
    
    UINavigationController *naviNuevaAlarma;
    
    nuevaAlarmaViewController *nuevaAlarmaVC; 
    alarmaViewController *alarmaVC;
    
    IBOutlet UITableViewCell *celdaAlarma;
}
@property (nonatomic)NSMutableArray *arrayAlarmas;
@property (nonatomic)UITableViewCell *celdaAlarma;

-(void)nuevaAlarma;
-(void)comprobarAlarmas;
-(void)iniciarTimer;

@end
