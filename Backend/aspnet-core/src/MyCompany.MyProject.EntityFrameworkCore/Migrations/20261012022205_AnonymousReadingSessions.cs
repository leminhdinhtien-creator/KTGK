using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MyCompany.MyProject.Migrations
{
    /// <inheritdoc />
    public partial class AnonymousReadingSessions : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<long>(
                name: "UserId",
                table: "ReadingAttempts",
                type: "bigint",
                nullable: true,
                oldClrType: typeof(long),
                oldType: "bigint");

            migrationBuilder.AddColumn<string>(
                name: "GuestKeyHash",
                table: "ReadingAttempts",
                type: "nvarchar(64)",
                maxLength: 64,
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_ReadingAttempts_GuestKeyHash_ExamId_Status",
                table: "ReadingAttempts",
                columns: new[] { "GuestKeyHash", "ExamId", "Status" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_ReadingAttempts_GuestKeyHash_ExamId_Status",
                table: "ReadingAttempts");

            migrationBuilder.DropColumn(
                name: "GuestKeyHash",
                table: "ReadingAttempts");

            migrationBuilder.AlterColumn<long>(
                name: "UserId",
                table: "ReadingAttempts",
                type: "bigint",
                nullable: false,
                defaultValue: 0L,
                oldClrType: typeof(long),
                oldType: "bigint",
                oldNullable: true);
        }
    }
}
