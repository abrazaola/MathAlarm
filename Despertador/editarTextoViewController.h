//
//  editarTextoViewController.h
//  Despertador
//
//  Created by Aitor Brazaola on 30/05/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface editarTextoViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *textField;
    NSString *cadena;
    NSString *tituloVentana;
    UINavigationItem *navigationItem;
}
@property (nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) NSString *cadena;
@property (nonatomic) NSString *tituloVentana;
@end
