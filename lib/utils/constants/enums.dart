/* --
      LIST OF Enums
      They cannot be created inside a class.
-- */

/// Switch of Custom Brand-Text-Size Widget
enum AppRole { admin, user }

enum TransactionType { buy, sell }

enum ProductType { single, variable }

enum ProductVisibility { published, hidden }

enum TextSizes { small, medium, large }

enum ImageType { asset, network, memory, file }

enum MediaCategory { folders, brands, categories, products, users,customers,salesman,guarantees,shop }

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

enum PaymentMethods { paypal, googlePay, applePay, visa, masterCard, creditCard, paystack, razorPay, paytm }


enum VariationType { Regular , small , medium , large }

enum StockLocation { Shop , Garage1 , Garage2  } // temporary



enum SaleType { Cash  , CreditSale  , Installment }


enum DurationType { Duration,Monthly , Quarterly  , Yearly   }


enum UnitType { item, dozen   }
