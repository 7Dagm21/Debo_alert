using Microsoft.AspNetCore.Mvc;
using DeboAlertApi.Data;
using DeboAlertApi.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication.JwtBearer;

namespace DeboAlertApi.Controllers
{
    [ApiController]
    [Route("api/alerts")]
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    public class AlertsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AlertsController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/alerts
        [HttpGet]
        public async Task<IActionResult> GetAlerts([FromQuery] string? region, [FromQuery] string? status)
        {
            var query = _context.Alerts.AsQueryable();
            if (!string.IsNullOrEmpty(region))
                query = query.Where(a => a.Region == region);
            if (!string.IsNullOrEmpty(status))
                query = query.Where(a => a.Status == status);
            var alerts = await query.OrderByDescending(a => a.CreatedAt).ToListAsync();
            return Ok(alerts);
        }

        // POST: api/alerts
        [HttpPost]
        public async Task<IActionResult> CreateAlert([FromBody] Alert alert)
        {
            alert.CreatedAt = DateTime.UtcNow;
            _context.Alerts.Add(alert);
            await _context.SaveChangesAsync();
            return Ok(alert);
        }

        // PATCH: api/alerts/{id}/status
        [HttpPatch("{id}/status")]
        public async Task<IActionResult> UpdateAlertStatus(int id, [FromBody] string status)
        {
            var alert = await _context.Alerts.FindAsync(id);
            if (alert == null) return NotFound();
            alert.Status = status;
            await _context.SaveChangesAsync();
            return Ok(alert);
        }
    }
}
