using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FurnitureStore.Services.Migrations
{
    /// <inheritdoc />
    public partial class updateproductreservationtable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Payments_ProductReservations_ProductReservationId",
                table: "Payments");

            migrationBuilder.DropIndex(
                name: "IX_Payments_ProductReservationId",
                table: "Payments");

            migrationBuilder.DropColumn(
                name: "ProductReservationId",
                table: "Payments");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "ProductReservationId",
                table: "Payments",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);

            migrationBuilder.CreateIndex(
                name: "IX_Payments_ProductReservationId",
                table: "Payments",
                column: "ProductReservationId");

            migrationBuilder.AddForeignKey(
                name: "FK_Payments_ProductReservations_ProductReservationId",
                table: "Payments",
                column: "ProductReservationId",
                principalTable: "ProductReservations",
                principalColumn: "Id");
        }
    }
}
