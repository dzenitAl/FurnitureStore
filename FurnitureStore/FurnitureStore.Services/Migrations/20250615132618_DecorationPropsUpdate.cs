using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FurnitureStore.Services.Migrations
{
    /// <inheritdoc />
    public partial class DecorationPropsUpdate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsAvailableInStore",
                table: "DecorativeItems",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "IsAvailableOnline",
                table: "DecorativeItems",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsAvailableInStore",
                table: "DecorativeItems");

            migrationBuilder.DropColumn(
                name: "IsAvailableOnline",
                table: "DecorativeItems");
        }
    }
}
