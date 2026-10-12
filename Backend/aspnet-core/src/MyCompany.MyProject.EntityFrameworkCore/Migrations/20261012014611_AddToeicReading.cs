using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MyCompany.MyProject.Migrations
{
    /// <inheritdoc />
    public partial class AddToeicReading : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "ReadingExams",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    DurationMinutes = table.Column<int>(type: "int", nullable: false),
                    TotalQuestions = table.Column<int>(type: "int", nullable: false),
                    AnswerStatus = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    SourceHash = table.Column<string>(type: "nvarchar(64)", maxLength: 64, nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ReadingExams", x => x.Id);
                    table.CheckConstraint("CK_ReadingExam", "[DurationMinutes]=75 AND [TotalQuestions]=100 AND [AnswerStatus] IN ('proposed','verified')");
                });

            migrationBuilder.CreateTable(
                name: "ReadingAttempts",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ExamId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<long>(type: "bigint", nullable: false),
                    StartedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Deadline = table.Column<DateTime>(type: "datetime2", nullable: false),
                    SubmittedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    Correct = table.Column<int>(type: "int", nullable: false),
                    Wrong = table.Column<int>(type: "int", nullable: false),
                    Skipped = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ReadingAttempts", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ReadingAttempts_AbpUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AbpUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_ReadingAttempts_ReadingExams_ExamId",
                        column: x => x.ExamId,
                        principalTable: "ReadingExams",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "ReadingParts",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ExamId = table.Column<int>(type: "int", nullable: false),
                    Number = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ReadingParts", x => x.Id);
                    table.CheckConstraint("CK_ReadingPart", "[Number] IN (5,6,7)");
                    table.ForeignKey(
                        name: "FK_ReadingParts_ReadingExams_ExamId",
                        column: x => x.ExamId,
                        principalTable: "ReadingExams",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ReadingGroups",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PartId = table.Column<int>(type: "int", nullable: false),
                    Key = table.Column<string>(type: "nvarchar(80)", maxLength: 80, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ReadingGroups", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ReadingGroups_ReadingParts_PartId",
                        column: x => x.PartId,
                        principalTable: "ReadingParts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ReadingDocuments",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    GroupId = table.Column<int>(type: "int", nullable: false),
                    Order = table.Column<int>(type: "int", nullable: false),
                    Text = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Image = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    ImageMime = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ReadingDocuments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ReadingDocuments_ReadingGroups_GroupId",
                        column: x => x.GroupId,
                        principalTable: "ReadingGroups",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ReadingQuestions",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ExamId = table.Column<int>(type: "int", nullable: false),
                    PartId = table.Column<int>(type: "int", nullable: false),
                    GroupId = table.Column<int>(type: "int", nullable: true),
                    Number = table.Column<int>(type: "int", nullable: false),
                    Text = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CorrectAnswer = table.Column<string>(type: "nvarchar(1)", maxLength: 1, nullable: false),
                    AnswerStatus = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ReadingQuestions", x => x.Id);
                    table.CheckConstraint("CK_ReadingQuestion", "[Number] BETWEEN 101 AND 200 AND [CorrectAnswer] IN ('A','B','C','D') AND [AnswerStatus] IN ('proposed','verified')");
                    table.ForeignKey(
                        name: "FK_ReadingQuestions_ReadingExams_ExamId",
                        column: x => x.ExamId,
                        principalTable: "ReadingExams",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_ReadingQuestions_ReadingGroups_GroupId",
                        column: x => x.GroupId,
                        principalTable: "ReadingGroups",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_ReadingQuestions_ReadingParts_PartId",
                        column: x => x.PartId,
                        principalTable: "ReadingParts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ReadingAnswers",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AttemptId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    QuestionId = table.Column<int>(type: "int", nullable: false),
                    Letter = table.Column<string>(type: "nvarchar(1)", maxLength: 1, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ReadingAnswers", x => x.Id);
                    table.CheckConstraint("CK_ReadingAnswer", "[Letter] IN ('A','B','C','D')");
                    table.ForeignKey(
                        name: "FK_ReadingAnswers_ReadingAttempts_AttemptId",
                        column: x => x.AttemptId,
                        principalTable: "ReadingAttempts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ReadingAnswers_ReadingQuestions_QuestionId",
                        column: x => x.QuestionId,
                        principalTable: "ReadingQuestions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "ReadingChoices",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    QuestionId = table.Column<int>(type: "int", nullable: false),
                    Letter = table.Column<string>(type: "nvarchar(1)", maxLength: 1, nullable: false),
                    Text = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ReadingChoices", x => x.Id);
                    table.CheckConstraint("CK_ReadingChoice", "[Letter] IN ('A','B','C','D')");
                    table.ForeignKey(
                        name: "FK_ReadingChoices_ReadingQuestions_QuestionId",
                        column: x => x.QuestionId,
                        principalTable: "ReadingQuestions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ReadingAnswers_AttemptId_QuestionId",
                table: "ReadingAnswers",
                columns: new[] { "AttemptId", "QuestionId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ReadingAnswers_QuestionId",
                table: "ReadingAnswers",
                column: "QuestionId");

            migrationBuilder.CreateIndex(
                name: "IX_ReadingAttempts_ExamId",
                table: "ReadingAttempts",
                column: "ExamId");

            migrationBuilder.CreateIndex(
                name: "IX_ReadingAttempts_Status_Deadline",
                table: "ReadingAttempts",
                columns: new[] { "Status", "Deadline" });

            migrationBuilder.CreateIndex(
                name: "IX_ReadingAttempts_UserId_ExamId_Status",
                table: "ReadingAttempts",
                columns: new[] { "UserId", "ExamId", "Status" });

            migrationBuilder.CreateIndex(
                name: "IX_ReadingChoices_QuestionId_Letter",
                table: "ReadingChoices",
                columns: new[] { "QuestionId", "Letter" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ReadingDocuments_GroupId_Order",
                table: "ReadingDocuments",
                columns: new[] { "GroupId", "Order" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ReadingExams_SourceHash",
                table: "ReadingExams",
                column: "SourceHash",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ReadingGroups_PartId_Key",
                table: "ReadingGroups",
                columns: new[] { "PartId", "Key" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ReadingParts_ExamId_Number",
                table: "ReadingParts",
                columns: new[] { "ExamId", "Number" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ReadingQuestions_ExamId_Number",
                table: "ReadingQuestions",
                columns: new[] { "ExamId", "Number" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ReadingQuestions_GroupId",
                table: "ReadingQuestions",
                column: "GroupId");

            migrationBuilder.CreateIndex(
                name: "IX_ReadingQuestions_PartId",
                table: "ReadingQuestions",
                column: "PartId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ReadingAnswers");

            migrationBuilder.DropTable(
                name: "ReadingChoices");

            migrationBuilder.DropTable(
                name: "ReadingDocuments");

            migrationBuilder.DropTable(
                name: "ReadingAttempts");

            migrationBuilder.DropTable(
                name: "ReadingQuestions");

            migrationBuilder.DropTable(
                name: "ReadingGroups");

            migrationBuilder.DropTable(
                name: "ReadingParts");

            migrationBuilder.DropTable(
                name: "ReadingExams");
        }
    }
}
