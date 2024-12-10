
using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class ProductPicture : BaseEntity
    {
        public long Id { get; set; }
        public string ImagePath { get; set; } 
        public long ProductId { get; set; }
        public Product Product { get; set; }
};
}
