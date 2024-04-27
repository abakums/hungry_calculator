import 'item.dart';

class Receipt {
  Item item;

  Receipt({required this.item});

  factory Receipt.fromJson(Map<String, dynamic> json) => Receipt(
    item: Item.fromJson(json['items']),
  );

  Map<String, dynamic> toJson() => {
    'items': item,
  };
}

/*
{
  "ocr_type" : "receipts",
  "request_id" : "P_77.234.209.245_loymnett_kci",
  "ref_no" : "AspDemo_1699984116052_20",
  "file_name" : "ÑÐµÐº.jpg",
  "request_received_on" : 1699984115921,
  "success" : true,
  "image_width" : 1600,
  "image_height" : 1200,
  "image_rotation" : 0,
  "recognition_completed_on" : 1699984116740,
  "receipts" : [ {
    "merchant_name" : "СУПЕРМАРКЕТ",
    "merchant_address" : null,
    "merchant_phone" : null,
    "merchant_website" : null,
    "merchant_tax_reg_no" : null,
    "merchant_company_reg_no" : null,
    "region" : null,
    "mall" : null,
    "country" : "US",
    "receipt_no" : null,
    "date" : "2018-07-02",
    "time" : "21:55",
    "items" : [ {
      "amount" : 119.60,
      "category" : null,
      "description" : "2: 20530 ТВОРОГ АГУША классический 100г",
      "flags" : " B",
      "qty" : 29.90,
      "remarks" : null,
      "tags" : null,
      "unitPrice" : 4.000 }, {
      "amount" : 69.90,
      "category" : null,
      "description" : "3062836 ЯЙЦО ОКСКОЕ",
      "flags" : " B",
      "qty" : 69.90,
      "remarks" : null,
      "tags" : null,
      "unitPrice" : 1.000 }, {
      "amount" : 179.70,
      "category" : null,
      "description" : "3438671 Изделия LA MOLISANA 450",
      "flags" : " B",
      "qty" : 59.90,
      "remarks" : null,
      "tags" : null,
      "unitPrice" : 3.000 }, {
      "amount" : 0.00,
      "category" : null,
      "description" : "1.000 =",
      "flags" : " C",
      "qty" : 0.00,
      "remarks" : null,
      "tags" : null,
      "unitPrice" : null
    }, {
      "amount" : 0.01,
      "category" : null,
      "description" : "Ваша скидка составила:",
      "flags" : "",
      "qty" : null,
      "remarks" : null,
      "tags" : null,
      "unitPrice" : null
    }, {
      "amount" : 559.78,
      "category" : null,
      "description" : "ПРОМЕЖУТОЧНЫЙ ИТОГ:",
      "flags" : "",
      "qty" : null,
      "remarks" : null,
      "tags" : null,
      "unitPrice" : null
    }, {
      "amount" : 559.79,
      "category" : null,
      "description" : "ИТОГ без учета скидок:",
      "flags" : "",
      "qty" : null,
      "remarks" : null,
      "tags" : null,
      "unitPrice" : null
    }, {
      "amount" : 0.01,
      "category" : null,
      "description" : "ВАША СУММАРНАЯ СКИДКА:",
      "flags" : "",
      "qty" : null,
      "remarks" : null,
      "tags" : null,
      "unitPrice" : null
    } ],
    "currency" : "USD",
    "total" : 559.79,
    "subtotal" : null,
    "tax" : null,
    "service_charge" : null,
    "tip" : null,
    "payment_method" : null,
    "payment_details" : null,
    "credit_card_type" : null,
    "credit_card_number" : null,
    "ocr_text" : "                              СУПЕРМАРКЕТ\n ******* ГОРЯЧАЯ ЛИНИЯ 8-800-200-95-55:\n                   КАССОВЫЙ ЧЕК\n Касса: 5                                 док: 8474\n 1: 3757 Бананы 1кг\n               55.90 *    1.624 =          90.78 с\n 2: 20530 ТВОРОГ АГУША классический 100г\n               29.90 *    4.000           119.60 B\n   3062836 ЯЙЦО ОКСКОЕ\n               69.90 *    1.000 =          69.90 B\n  3438671 Изделия LA MOLISANA 450\n               59.90 * 3.000 =            179.70 B\n  3468710 шоколад молочный 90г\n               49.90 2.000 =              99.80 С\n  3648145 Этикетка красная RSMM\n                0.00      1.000 =          0.00 C\n Ваша скидка составила:                      0,01\n ПРОМЕЖУТОЧНЫЙ ИТОГ: 559,78\n ИТОГ без учета скидок:                    559,79\n ВАША СУММАРНАЯ СКИДКА:                      0,01\n * - товар участвует в акции.\n Акция от: 07.02.2018 21:55\n Вы получите ПЕРСОНАЛЬНЫЙ КУПОН-ЧЕК\n за любые покупки с картой Клуба \"\n Оформите карту на кассе Или\n в мобильном приложении Мой Перекресток",
    "ocr_confidence" : 93.64,
    "width" : 1097,
    "height" : 1078,
    "avg_char_width" : 22.1517,
    "avg_line_height" : 40.3692,
    "conf_amount" : 79,
    "source_locations" : {
      "date" : [ [ { "y" : 968, "x" : 448 }, { "y" : 968, "x" : 836 }, { "y" : 1009, "x" : 836 }, { "y" : 1009, "x" : 448 } ] ],
      "merchant_name" : [ [ { "y" : 105, "x" : 883 }, { "y" : 111, "x" : 1133 }, { "y" : 143, "x" : 1132 }, { "y" : 137, "x" : 882 } ] ],
      "doc" : [ [ { "y" : 53, "x" : 176 }, { "y" : 53, "x" : 1382 }, { "y" : 1238, "x" : 1382 }, { "y" : 1238, "x" : 176 } ] ]
    }
  } ]
}
 */