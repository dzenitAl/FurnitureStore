using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FurnitureStore.Services.Migrations
{
    /// <inheritdoc />
    public partial class addedNewTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_GiftCards_Users_UserId",
                table: "GiftCards");

            migrationBuilder.DropForeignKey(
                name: "FK_Users_Cities_CityId",
                table: "Users");

            migrationBuilder.DropIndex(
                name: "IX_GiftCards_UserId",
                table: "GiftCards");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "GiftCards");

            migrationBuilder.CreateTable(
                name: "GiftCardUsers",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    GiftCardId = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    GiftCardId1 = table.Column<long>(type: "bigint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GiftCardUsers", x => x.Id);
                    table.ForeignKey(
                        name: "FK_GiftCardUsers_GiftCards_GiftCardId1",
                        column: x => x.GiftCardId1,
                        principalTable: "GiftCards",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_GiftCardUsers_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_GiftCardUsers_GiftCardId1",
                table: "GiftCardUsers",
                column: "GiftCardId1");

            migrationBuilder.CreateIndex(
                name: "IX_GiftCardUsers_UserId",
                table: "GiftCardUsers",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Users_Cities_CityId",
                table: "Users",
                column: "CityId",
                principalTable: "Cities",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Users_Cities_CityId",
                table: "Users");

            migrationBuilder.DropTable(
                name: "GiftCardUsers");

            migrationBuilder.AddColumn<string>(
                name: "UserId",
                table: "GiftCards",
                type: "nvarchar(450)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_GiftCards_UserId",
                table: "GiftCards",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_GiftCards_Users_UserId",
                table: "GiftCards",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Users_Cities_CityId",
                table: "Users",
                column: "CityId",
                principalTable: "Cities",
                principalColumn: "Id");
        }
    }
}
