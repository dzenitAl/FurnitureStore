﻿
namespace FurnitureStore.Models.OrderItem
{
    public class OrderItem
    {
        public long Id { get; set; }
        public int Quantity { get; set; }
        public long OrderId { get; set; }
        public Order.Order Order { get; set; }
        public long ProductId { get; set; }
        public Product.Product Product { get; set; }
    }
}
