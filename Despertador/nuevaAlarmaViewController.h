//
//  nuevaAlarmaViewController.h
//  Despertador
//
//  Created by Aitor Brazaola on 16/05/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Alarma;
@class editarTextoViewController;
@class sonidosViewController;

@interface nuevaAlarmaViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource>
{
    Alarma *editingAlarma;
    
    editarTextoViewController *editarVC;
    sonidosViewController *sonidosVC;
        
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UITableView *uiTableView;
    
    UINavigationItem *navigationItem;
    NSString *tituloVentana;
    NSMutableArray *arrayAlarmas;
    
    IBOutlet UITableViewCell *celdaEstado;
}
//Metodos de clase
-(void)guardar;
-(void)cancelar;
-(void)preservarHora;
-(IBAction)cambiarEstado:(id)sender;

@property (nonatomic)IBOutlet UITableView *uiTableView;
@property (nonatomic)NSMutableArray *arrayAlarmas;
@property (nonatomic)Alarma *editingAlarma;
@property (nonatomic)IBOutlet UIDatePicker *datePicker;
@property (nonatomic)NSString *tituloVentana;
@property (nonatomic)UITableViewCell *celdaEstado;

@end
