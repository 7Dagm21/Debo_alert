using Microsoft.AspNetCore.Mvc;
using DeboAlertApi.Data;
using DeboAlertApi.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication.JwtBearer;

namespace DeboAlertApi.Controllers
{
    [ApiController]
    [Route("api/users")]
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    public class UsersController : ControllerBase
    {
        private readonly AppDbContext _context;

        public UsersController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/users
        [HttpGet]
        public async Task<IActionResult> GetUsers()
        {
            var users = await _context.UserProfiles
                .AsNoTracking()
                .Select(u => new {
                    u.Email,
                    u.PhoneNumber,
                    u.ProfileImageUrl,
                    u.CreatedAt,
                    u.IsAdmin
                })
                .ToListAsync();
            return Ok(users);
        }

        // PATCH: api/users/admin
        [HttpPatch("admin")]
        public async Task<IActionResult> SetAdmin([FromBody] SetAdminDto dto)
        {
            var user = await _context.UserProfiles.FirstOrDefaultAsync(u => u.Email == dto.Email);
            if (user == null)
                return NotFound();
            user.IsAdmin = dto.IsAdmin;
            await _context.SaveChangesAsync();
            return Ok(new { user.Email, user.IsAdmin });
        }
    }

    public class SetAdminDto
    {
        public string Email { get; set; }
        public bool IsAdmin { get; set; }
    }
}
