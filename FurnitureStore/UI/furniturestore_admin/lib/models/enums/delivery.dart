enum Delivery { InStorePickup, HomeDelivery, CourierService, ExpressDelivery }

extension DeliveryExtension on Delivery {
  String get displayName {
    switch (this) {
      case Delivery.InStorePickup:
        return 'Preuzimanje u trgovini';
      case Delivery.HomeDelivery:
        return 'Dostava na adresu';
      case Delivery.CourierService:
        return 'Kurirska služba';
      case Delivery.ExpressDelivery:
        return 'Ekspresna dostava';
      default:
        return '';
    }
  }
}
