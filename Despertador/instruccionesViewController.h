//
//  instruccionesViewController.h
//  Desperta+
//
//  Created by Aitor Brazaola on 11/07/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface instruccionesViewController : UIViewController
{
    IBOutlet UITextView *textView;
    IBOutlet UILabel *tituloMensaje;
}

-(IBAction)comenzar:(id)sender;

@end
