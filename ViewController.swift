//
//  ViewController.swift
//  PaymentGWIntegration
//
//  Created by Drish on 20/07/20.
//  Copyright © 2020 Drish. All rights reserved.
//

import UIKit

class ViewController: UIViewController , PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate {
 var payPalConfig = PayPalConfiguration() // default
var environment:String = PayPalEnvironmentNoNetwork {
   willSet(newEnvironment) {
     if (newEnvironment != environment) {
       PayPalMobile.preconnect(withEnvironment: newEnvironment)
     }
   }
 }
  override func viewDidLoad() {
  super.viewDidLoad()
  
  // Do any additional setup after loading the view.
  title = "PayPal SDK Demo"
 
  
  // Set up payPalConfig
  payPalConfig.acceptCreditCards = false
  payPalConfig.merchantName = "Awesome Shirts, Inc."
  payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
  payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
  
  // Setting the languageOrLocale property is optional.
  //
  // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
  // its user interface according to the device's current language setting.
  //
  // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
  // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
  // to use that language/locale.
  //
  // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
  
  payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
  
  // Setting the payPalShippingAddressOption property is optional.
  //
  // See PayPalConfiguration.h for details.
  
  payPalConfig.payPalShippingAddressOption = .payPal;
  
  print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
  
}

override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)
    PayPalMobile.preconnect(withEnvironment: "sandbox")
}



    @IBAction func PayPal_Action(_ sender: Any) {
     // Remove our last completed payment, just for demo purposes.
                 
                   
                   // Note: For purposes of illustration, this example shows a payment that includes
                   //       both payment details (subtotal, shipping, tax) and multiple items.
                   //       You would only specify these if appropriate to your situation.
                   //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
                   //       and simply set payment.amount to your total charge.
                   
                   // Optional: include multiple items
                   let item1 = PayPalItem(name: "Old jeans with holes", withQuantity: 2, withPrice: NSDecimalNumber(string: "84.99"), withCurrency: "USD", withSku: "Hip-0037")
                   let item2 = PayPalItem(name: "Free rainbow patch", withQuantity: 1, withPrice: NSDecimalNumber(string: "0.00"), withCurrency: "USD", withSku: "Hip-00066")
                   let item3 = PayPalItem(name: "Long-sleeve plaid shirt (mustache not included)", withQuantity: 1, withPrice: NSDecimalNumber(string: "37.99"), withCurrency: "USD", withSku: "Hip-00291")
                   
                   let items = [item1, item2, item3]
                   let subtotal = PayPalItem.totalPrice(forItems: items)
                   
                   // Optional: include payment details
                   let shipping = NSDecimalNumber(string: "5.99")
                   let tax = NSDecimalNumber(string: "2.50")
                   let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
                   
                   let total = subtotal.adding(shipping).adding(tax)
                   
                   let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Hipster Clothing", intent: .sale)
                   
                   payment.items = items
                   payment.paymentDetails = paymentDetails
                   
                   if (payment.processable) {
                     let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
                    paymentViewController?.modalPresentationStyle = .fullScreen
                     present(paymentViewController!, animated: true, completion: nil)
                   }
                   else {
                     // This particular payment will always be processable. If, for
                     // example, the amount was negative or the shortDescription was
                     // empty, this payment wouldn't be processable, and you'd want
                     // to handle that here.
                     print("Payment not processalbe: \(payment)")
                   }
            }
            // PayPalPaymentDelegate
              
              func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
                print("PayPal Payment Cancelled")
             
                paymentViewController.dismiss(animated: true, completion: nil)
              }
              
              func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
                print("PayPal Payment Success !")
                paymentViewController.modalPresentationStyle = .fullScreen
                paymentViewController.dismiss(animated: true, completion: { () -> Void in
                  // send completed confirmaion to your server
                  print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
                  
                
                })
              }
              
              
              // MARK: Future Payments
              
             
              
              func payPalFuturePaymentDidCancel(_ futurePaymentViewController: PayPalFuturePaymentViewController) {
                print("PayPal Future Payment Authorization Canceled")
               
                futurePaymentViewController.dismiss(animated: true, completion: nil)
              }
              
              func payPalFuturePaymentViewController(_ futurePaymentViewController: PayPalFuturePaymentViewController, didAuthorizeFuturePayment futurePaymentAuthorization: [AnyHashable: Any]) {
                print("PayPal Future Payment Authorization Success!")
                // send authorization to your server to get refresh token.
                futurePaymentViewController.dismiss(animated: true, completion: { () -> Void in
                
                  
                })
              }
              
              // MARK: Profile Sharing
              
            
              
              // PayPalProfileSharingDelegate
              
              func userDidCancel(_ profileSharingViewController: PayPalProfileSharingViewController) {
                print("PayPal Profile Sharing Authorization Canceled")
            
                profileSharingViewController.dismiss(animated: true, completion: nil)
              }
              
              func payPalProfileSharingViewController(_ profileSharingViewController: PayPalProfileSharingViewController, userDidLogInWithAuthorization profileSharingAuthorization: [AnyHashable: Any]) {
                print("PayPal Profile Sharing Authorization Success!")
                // send authorization to your server
                profileSharingViewController.dismiss(animated: true, completion: { () -> Void in
                })

              }
              // MARK: - Navigation
              // In a storyboard-based application, you will often want to do a little preparation before navigation
              override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                // Get the new view controller using segue.destinationViewController.
                // Pass the selected object to the new view controller.
                
        //        if segue.identifier == "pushSettings" {
        //          // [segue destinationViewController] setDelegate:(id)self];
        //          if let flipSideViewController = segue.destination as? FlipsideViewController {
        //            flipSideViewController.flipsideDelegate = self
        //          }
        //        }
              }

              // MARK: Helpers

              // MARK: Memory
              
              override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
              }
            }

