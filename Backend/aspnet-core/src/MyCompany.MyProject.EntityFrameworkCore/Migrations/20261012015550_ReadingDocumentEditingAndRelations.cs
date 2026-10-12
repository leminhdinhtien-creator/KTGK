using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MyCompany.MyProject.Migrations
{
    /// <inheritdoc />
    public partial class ReadingDocumentEditingAndRelations : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ReadingQuestions_ReadingGroups_GroupId",
                table: "ReadingQuestions");

            migrationBuilder.DropForeignKey(
                name: "FK_ReadingQuestions_ReadingParts_PartId",
                table: "ReadingQuestions");

            migrationBuilder.DropIndex(
                name: "IX_ReadingQuestions_GroupId",
                table: "ReadingQuestions");

            migrationBuilder.DropIndex(
                name: "IX_ReadingQuestions_PartId",
                table: "ReadingQuestions");

            migrationBuilder.AddColumn<bool>(
                name: "TextWasEdited",
                table: "ReadingDocuments",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddUniqueConstraint(
                name: "AK_ReadingParts_Id_ExamId",
                table: "ReadingParts",
                columns: new[] { "Id", "ExamId" });

            migrationBuilder.AddUniqueConstraint(
                name: "AK_ReadingGroups_Id_PartId",
                table: "ReadingGroups",
                columns: new[] { "Id", "PartId" });

            migrationBuilder.CreateIndex(
                name: "IX_ReadingQuestions_GroupId_PartId",
                table: "ReadingQuestions",
                columns: new[] { "GroupId", "PartId" });

            migrationBuilder.CreateIndex(
                name: "IX_ReadingQuestions_PartId_ExamId",
                table: "ReadingQuestions",
                columns: new[] { "PartId", "ExamId" });

            migrationBuilder.AddForeignKey(
                name: "FK_ReadingQuestions_ReadingGroups_GroupId_PartId",
                table: "ReadingQuestions",
                columns: new[] { "GroupId", "PartId" },
                principalTable: "ReadingGroups",
                principalColumns: new[] { "Id", "PartId" },
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_ReadingQuestions_ReadingParts_PartId_ExamId",
                table: "ReadingQuestions",
                columns: new[] { "PartId", "ExamId" },
                principalTable: "ReadingParts",
                principalColumns: new[] { "Id", "ExamId" },
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ReadingQuestions_ReadingGroups_GroupId_PartId",
                table: "ReadingQuestions");

            migrationBuilder.DropForeignKey(
                name: "FK_ReadingQuestions_ReadingParts_PartId_ExamId",
                table: "ReadingQuestions");

            migrationBuilder.DropIndex(
                name: "IX_ReadingQuestions_GroupId_PartId",
                table: "ReadingQuestions");

            migrationBuilder.DropIndex(
                name: "IX_ReadingQuestions_PartId_ExamId",
                table: "ReadingQuestions");

            migrationBuilder.DropUniqueConstraint(
                name: "AK_ReadingParts_Id_ExamId",
                table: "ReadingParts");

            migrationBuilder.DropUniqueConstraint(
                name: "AK_ReadingGroups_Id_PartId",
                table: "ReadingGroups");

            migrationBuilder.DropColumn(
                name: "TextWasEdited",
                table: "ReadingDocuments");

            migrationBuilder.CreateIndex(
                name: "IX_ReadingQuestions_GroupId",
                table: "ReadingQuestions",
                column: "GroupId");

            migrationBuilder.CreateIndex(
                name: "IX_ReadingQuestions_PartId",
                table: "ReadingQuestions",
                column: "PartId");

            migrationBuilder.AddForeignKey(
                name: "FK_ReadingQuestions_ReadingGroups_GroupId",
                table: "ReadingQuestions",
                column: "GroupId",
                principalTable: "ReadingGroups",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_ReadingQuestions_ReadingParts_PartId",
                table: "ReadingQuestions",
                column: "PartId",
                principalTable: "ReadingParts",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
