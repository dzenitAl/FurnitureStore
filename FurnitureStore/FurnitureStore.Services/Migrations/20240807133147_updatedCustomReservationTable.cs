using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FurnitureStore.Services.Migrations
{
    /// <inheritdoc />
    public partial class updatedCustomReservationTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CustomFurnitureReservations_Users_AdminId",
                table: "CustomFurnitureReservations");

            migrationBuilder.DropColumn(
                name: "Address",
                table: "CustomFurnitureReservations");

            migrationBuilder.DropColumn(
                name: "Content",
                table: "CustomFurnitureReservations");

            migrationBuilder.DropColumn(
                name: "Email",
                table: "CustomFurnitureReservations");

            migrationBuilder.DropColumn(
                name: "FirstName",
                table: "CustomFurnitureReservations");

            migrationBuilder.DropColumn(
                name: "LastName",
                table: "CustomFurnitureReservations");

            migrationBuilder.RenameColumn(
                name: "PhoneNumber",
                table: "CustomFurnitureReservations",
                newName: "Note");

            migrationBuilder.RenameColumn(
                name: "AdminId",
                table: "CustomFurnitureReservations",
                newName: "UserId");

            migrationBuilder.RenameIndex(
                name: "IX_CustomFurnitureReservations_AdminId",
                table: "CustomFurnitureReservations",
                newName: "IX_CustomFurnitureReservations_UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_CustomFurnitureReservations_Users_UserId",
                table: "CustomFurnitureReservations",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CustomFurnitureReservations_Users_UserId",
                table: "CustomFurnitureReservations");

            migrationBuilder.RenameColumn(
                name: "UserId",
                table: "CustomFurnitureReservations",
                newName: "AdminId");

            migrationBuilder.RenameColumn(
                name: "Note",
                table: "CustomFurnitureReservations",
                newName: "PhoneNumber");

            migrationBuilder.RenameIndex(
                name: "IX_CustomFurnitureReservations_UserId",
                table: "CustomFurnitureReservations",
                newName: "IX_CustomFurnitureReservations_AdminId");

            migrationBuilder.AddColumn<string>(
                name: "Address",
                table: "CustomFurnitureReservations",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Content",
                table: "CustomFurnitureReservations",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Email",
                table: "CustomFurnitureReservations",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "FirstName",
                table: "CustomFurnitureReservations",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "LastName",
                table: "CustomFurnitureReservations",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddForeignKey(
                name: "FK_CustomFurnitureReservations_Users_AdminId",
                table: "CustomFurnitureReservations",
                column: "AdminId",
                principalTable: "Users",
                principalColumn: "Id");
        }
    }
}
