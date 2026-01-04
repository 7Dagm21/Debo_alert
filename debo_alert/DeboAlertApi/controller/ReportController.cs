using Microsoft.AspNetCore.Mvc;
using DeboAlertApi.Data;
using DeboAlertApi.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore; // ADD THIS

namespace DeboAlertApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReportController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IWebHostEnvironment _env;

        public ReportController(AppDbContext context, IWebHostEnvironment env)
        {
            _context = context;
            _env = env;
        }

        [HttpPost]
        [RequestSizeLimit(10_000_000)] // 10MB limit
        public async Task<IActionResult> PostReport([FromForm] ReportDto dto)
        {
            // Validate required fields
            if (string.IsNullOrEmpty(dto.Category) || string.IsNullOrEmpty(dto.Description))
            {
                return BadRequest(new { error = "Category and Description are required." });
            }

            string? mediaUrl = null;

            if (dto.Media != null && dto.Media.Length > 0)
            {
                var uploads = Path.Combine(_env.WebRootPath, "uploads");
                Directory.CreateDirectory(uploads);
                var fileName = $"{Guid.NewGuid()}_{dto.Media.FileName}";
                var filePath = Path.Combine(uploads, fileName);
                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await dto.Media.CopyToAsync(stream);
                }
                mediaUrl = $"/uploads/{fileName}";
            }

            var report = new Report
            {
                Category = dto.Category,
                Description = dto.Description,
                MediaUrl = mediaUrl,
                IsVideo = dto.IsVideo,
                Timestamp = DateTime.UtcNow,
                Latitude = dto.Latitude,
                Longitude = dto.Longitude,
                Status = "New"
            };

            _context.Reports.Add(report);
            await _context.SaveChangesAsync();

            return Ok(new {
                message = "Report submitted successfully",
                reportId = report.Id
            });
        }

        // GET: api/report
        [HttpGet]
        public async Task<IActionResult> GetReports()
        {
            var reports = await _context.Reports
                .OrderByDescending(r => r.Timestamp)
                .ToListAsync();
            return Ok(reports);
        }
    }
}