# Assist SDK for iOS

## Integration simple payments

1. Register your account in Assist
1. Download the last version of AssistMobile.framework or build it
2. Add the framework to your project
3. Set option Build Settings -> Build Options -> Embedded Content Contains Swift Code to YES in project settings
4. Add AssisyMobile.framework to  General->Embedded Binaries property
5. Add key NSLocationWhenInUseUsageDescription to Info.plist -> Information Property List, set type to String and value 'Permit to send geolocation data to Assist'

### Fiscalization
Fiscal parameters and order items are transferred among other payment parameters (see test application). Assist Fiscalization Documentation: https://docs.assist.ru/pages/viewpage.action?pageId=5768155

### Code sample Swift

    import UIKit
    import AssistMobile

    class ViewController: UIViewController, AssistPayDelegate {
        @IBOutlet weak var result: UILabel!  
        var data = PayData()
   
        @IBAction func startPay(sender: UIButton) {

            data.merchantId = "123456"
            data.orderNumber = "test_payment_01"
            data.orderAmount = "100.05"
            data.orderComment = "This is a test!"
            data.orderCurrency = .RUB      
            data.lastname = "Ivanov"
            data.firstname = "Ivan"
            data.middlename = "Ivanovich"
            data.email = "i3@mail.ru"
            data.mobilePhone = "+79210000000"
            data.address = "Nevskiy prospekt, 1"
            data.country = "Russian Federation"
            data.state = "Saint-Petersburg"
            data.city = "Saint-Petersburg"
        
            let pay = AssistPay(delegate: self)
            pay.start(self, withData: data)
        }  

        func payFinished(bill: String, status: PaymentStatus, message: String?) {
            let msg = message ?? ""
            result.text = "Finished: bill = \(bill), status = \(status.rawValue), message = \(msg)"
        }
    }

###Code sample Objective C

ViewController.h

    #import <UIKit/UIKit.h>
    #import "AssistMobile/AssistMobile.h"
  
    @interface ViewController : UIViewController<AssistPayDelegate>
    @property (weak, nonatomic) IBOutlet UILabel *result;
    - (IBAction)pay:(UIButton *)sender;
 
    @end

ViewController.m

    #import "ViewController.h"
    @interface ViewController ()
 
    @property (strong, nonatomic) PayData* data;
    @end
 
    @implementation ViewController
    - (IBAction)pay:(UIButton *)sender {
        if (!_data) {
            _data = [[PayData alloc] init];
        }
    
        _data.orderAmount = @"100.05";
        _data.orderNumber = @"test_payment_002";
        _data.merchantId = @"679471";
     
        AssistPay* assistPay = [[AssistPay alloc] initWithDelegate: self];
        [assistPay start:self withData: _data];
    }
 
    - (void)payFinished:(NSString * __nonnull)bill status:(NSString * __nonnull)status message:(NSString * __nullable)message
    {
        NSString* res = @"status: ";
        res = [res stringByAppendingString: status];
        res = [res stringByAppendingString: @", billnumber: "];
        res = [res stringByAppendingString: bill];
        res = [res stringByAppendingString: @", message: "];
        res = [res stringByAppendingString: message];
        _result.text = res;
    }
 
    @end

## Integration ApplePay payments

1. Perform steps described in 'Integration payments' chapter
2. Register Apple ID and developer account
3. Create merchant ID and certificate in developer.apple.com
4. Switch on setting in your project settings Capabilities -> ApplePay
5. Switch on your merchant ID in ApplePay settings

### Code sample Swift

    import UIKit
    import AssistMobile

    class ViewController: UIViewController, AssistPayDelegate {
        @IBOutlet weak var result: UILabel!  
        var data = PayData()
        
        @available(iOS 10.0, *)
        @IBAction func payWithApplePay(_ sender: UIButton) {
            data = PayData()
            pay = AssistPay(delegate: self)
            data.merchantId = "your merhcnt id in assist"
            var apmid = "murchant.id.in.apple"
            data.login = "your account login in assist"
            data.password = "your account password in assist"
            data.orderNumber = "order number"
            data.orderComment = "comment"
            data.orderAmount = "100.05"
            data.orderCurrency = .RUB
            data.lastname = "Ivanov"
            data.firstname = "Ivan"
            data.email = "ivan@mailhost.ru"
        
            AssistLinks.currentHost = "https://payments.assist.ru"
        
            pay!.startWithApplePay(self, withData: data, applePayMerchantId: apmid)
        }
        
         func payFinished(bill: String, status: PaymentStatus, message: String?) {
            let msg = message ?? ""
            result.text = "Finished: bill = \(bill), status = \(status.rawValue), message = \(msg)"
        }
    }
