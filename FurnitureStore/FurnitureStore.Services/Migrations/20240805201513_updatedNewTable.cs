using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FurnitureStore.Services.Migrations
{
    /// <inheritdoc />
    public partial class updatedNewTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_GiftCardUsers_GiftCards_GiftCardId1",
                table: "GiftCardUsers");

            migrationBuilder.DropIndex(
                name: "IX_GiftCardUsers_GiftCardId1",
                table: "GiftCardUsers");

            migrationBuilder.DropColumn(
                name: "GiftCardId1",
                table: "GiftCardUsers");

            migrationBuilder.AlterColumn<long>(
                name: "GiftCardId",
                table: "GiftCardUsers",
                type: "bigint",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.CreateIndex(
                name: "IX_GiftCardUsers_GiftCardId",
                table: "GiftCardUsers",
                column: "GiftCardId");

            migrationBuilder.AddForeignKey(
                name: "FK_GiftCardUsers_GiftCards_GiftCardId",
                table: "GiftCardUsers",
                column: "GiftCardId",
                principalTable: "GiftCards",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_GiftCardUsers_GiftCards_GiftCardId",
                table: "GiftCardUsers");

            migrationBuilder.DropIndex(
                name: "IX_GiftCardUsers_GiftCardId",
                table: "GiftCardUsers");

            migrationBuilder.AlterColumn<string>(
                name: "GiftCardId",
                table: "GiftCardUsers",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(long),
                oldType: "bigint");

            migrationBuilder.AddColumn<long>(
                name: "GiftCardId1",
                table: "GiftCardUsers",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);

            migrationBuilder.CreateIndex(
                name: "IX_GiftCardUsers_GiftCardId1",
                table: "GiftCardUsers",
                column: "GiftCardId1");

            migrationBuilder.AddForeignKey(
                name: "FK_GiftCardUsers_GiftCards_GiftCardId1",
                table: "GiftCardUsers",
                column: "GiftCardId1",
                principalTable: "GiftCards",
                principalColumn: "Id");
        }
    }
}
