using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FurnitureStore.Services.Migrations
{
    /// <inheritdoc />
    public partial class addImagePath : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "ImagePath",
                table: "Subcategories",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "ImagePath",
                table: "Promotions",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "ImagePath",
                table: "GiftCards",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "ImagePath",
                table: "Categories",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ImagePath",
                table: "Subcategories");

            migrationBuilder.DropColumn(
                name: "ImagePath",
                table: "Promotions");

            migrationBuilder.DropColumn(
                name: "ImagePath",
                table: "GiftCards");

            migrationBuilder.DropColumn(
                name: "ImagePath",
                table: "Categories");
        }
    }
}
