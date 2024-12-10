using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FurnitureStore.Services.Migrations
{
    /// <inheritdoc />
    public partial class updatedReportTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "CustomerId",
                table: "Reports",
                type: "nvarchar(450)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_Reports_CustomerId",
                table: "Reports",
                column: "CustomerId");

            migrationBuilder.AddForeignKey(
                name: "FK_Reports_Users_CustomerId",
                table: "Reports",
                column: "CustomerId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Reports_Users_CustomerId",
                table: "Reports");

            migrationBuilder.DropIndex(
                name: "IX_Reports_CustomerId",
                table: "Reports");

            migrationBuilder.DropColumn(
                name: "CustomerId",
                table: "Reports");
        }
    }
}
