using Microsoft.EntityFrameworkCore.Migrations;

namespace VisionDream.Data.Migrations
{
    public partial class AddLibraryManager_BookRepository : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_Book",
                table: "Book");

            migrationBuilder.RenameTable(
                name: "Book",
                newName: "BookEntity");

            migrationBuilder.AddPrimaryKey(
                name: "PK_BookEntity",
                table: "BookEntity",
                column: "Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_BookEntity",
                table: "BookEntity");

            migrationBuilder.RenameTable(
                name: "BookEntity",
                newName: "Book");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Book",
                table: "Book",
                column: "Id");
        }
    }
}
