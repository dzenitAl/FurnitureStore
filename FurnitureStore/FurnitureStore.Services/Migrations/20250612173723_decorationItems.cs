using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FurnitureStore.Services.Migrations
{
    /// <inheritdoc />
    public partial class decorationItems : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "DecorativeItemId",
                table: "ProductPictures",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddColumn<long>(
                name: "DecorativeItemId",
                table: "OrderItems",
                type: "bigint",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "DecorativeItems",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    StockQuantity = table.Column<int>(type: "int", nullable: false),
                    Material = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Dimensions = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Style = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Color = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsFragile = table.Column<bool>(type: "bit", nullable: false),
                    CareInstructions = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CategoryId = table.Column<long>(type: "bigint", nullable: false),
                    CreatedById = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    LastModifiedBy = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LastModified = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DecorativeItems", x => x.Id);
                    table.ForeignKey(
                        name: "FK_DecorativeItems_Categories_CategoryId",
                        column: x => x.CategoryId,
                        principalTable: "Categories",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_ProductPictures_DecorativeItemId",
                table: "ProductPictures",
                column: "DecorativeItemId");

            migrationBuilder.CreateIndex(
                name: "IX_OrderItems_DecorativeItemId",
                table: "OrderItems",
                column: "DecorativeItemId");

            migrationBuilder.CreateIndex(
                name: "IX_DecorativeItems_CategoryId",
                table: "DecorativeItems",
                column: "CategoryId");

            migrationBuilder.AddForeignKey(
                name: "FK_OrderItems_DecorativeItems_DecorativeItemId",
                table: "OrderItems",
                column: "DecorativeItemId",
                principalTable: "DecorativeItems",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_ProductPictures_DecorativeItems_DecorativeItemId",
                table: "ProductPictures",
                column: "DecorativeItemId",
                principalTable: "DecorativeItems",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_OrderItems_DecorativeItems_DecorativeItemId",
                table: "OrderItems");

            migrationBuilder.DropForeignKey(
                name: "FK_ProductPictures_DecorativeItems_DecorativeItemId",
                table: "ProductPictures");

            migrationBuilder.DropTable(
                name: "DecorativeItems");

            migrationBuilder.DropIndex(
                name: "IX_ProductPictures_DecorativeItemId",
                table: "ProductPictures");

            migrationBuilder.DropIndex(
                name: "IX_OrderItems_DecorativeItemId",
                table: "OrderItems");

            migrationBuilder.DropColumn(
                name: "DecorativeItemId",
                table: "ProductPictures");

            migrationBuilder.DropColumn(
                name: "DecorativeItemId",
                table: "OrderItems");
        }
    }
}
