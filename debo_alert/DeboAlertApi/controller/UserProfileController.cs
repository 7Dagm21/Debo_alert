using Microsoft.AspNetCore.Mvc;
using DeboAlertApi.Data;
using DeboAlertApi.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using System.Security.Claims;
using Microsoft.AspNetCore.Hosting;

namespace DeboAlertApi.Controllers
{
    [ApiController]
    [Route("api/userprofile")]
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    public class UserProfileController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IWebHostEnvironment _env;
        private readonly ILogger<UserProfileController> _logger;

        public UserProfileController(
            AppDbContext context, 
            IWebHostEnvironment env,
            ILogger<UserProfileController> logger)
        {
            _context = context;
            _env = env;
            _logger = logger;
        }

        // GET: api/userprofile/me
        [HttpGet("me")]
        public async Task<IActionResult> GetMyProfile()
        {
            try
            {
                var email = User.Claims.FirstOrDefault(c => c.Type == "email")?.Value
                          ?? User.Claims.FirstOrDefault(c => c.Type.EndsWith("/emailaddress"))?.Value;
                if (string.IsNullOrEmpty(email))
                {
                    _logger.LogWarning("No email claim found in token");
                    return Unauthorized(new { error = "Authentication failed" });
                }
                _logger.LogInformation("Fetching profile for email: {Email}", email);

                var profile = await _context.UserProfiles
                    .AsNoTracking()
                    .FirstOrDefaultAsync(u => u.Email == email);
                
                if (profile == null)
                {
                    _logger.LogInformation("No profile found for email: {Email}, returning default", email);
                    return Ok(new { 
                        email,
                        phoneNumber = "",
                        profileImageUrl = ""
                    });
                }

                return Ok(new
                {
                    profile.Email,
                    profile.PhoneNumber,
                    profile.ProfileImageUrl
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting profile");
                return StatusCode(500, new { error = "Internal server error" });
            }
        }

        // POST: api/userprofile/me
        [HttpPost("me")]
        [RequestSizeLimit(20_000_000)] // 20MB limit
        public async Task<IActionResult> UpsertProfile()
        {
            try
            {
                var email = User.Claims.FirstOrDefault(c => c.Type == "email")?.Value
                          ?? User.Claims.FirstOrDefault(c => c.Type.EndsWith("/emailaddress"))?.Value;
                if (string.IsNullOrEmpty(email))
                {
                    _logger.LogWarning("No email claim found in token");
                    return Unauthorized(new { error = "Authentication failed" });
                }
                _logger.LogInformation("Updating profile for email: {Email}", email);

                // Get form data
                var form = await Request.ReadFormAsync();
                var phoneNumber = form["phoneNumber"].FirstOrDefault();
                var profileImage = form.Files.FirstOrDefault(f => f.Name == "profileImage");

                _logger.LogInformation($"Form fields: phoneNumber={phoneNumber}, file count={form.Files.Count}.");
                foreach (var file in form.Files)
                {
                    _logger.LogInformation($"Received file: name={file.Name}, filename={file.FileName}, contentType={file.ContentType}, length={file.Length}");
                }

                string? imageUrl = null;

                // Validate and handle image upload
                if (profileImage != null && profileImage.Length > 0)
                {
                    if (!profileImage.ContentType.StartsWith("image/"))
                    {
                        _logger.LogWarning($"Invalid file type uploaded: {profileImage.ContentType}. Rejecting upload.");
                        return BadRequest(new { error = $"Only image files are allowed. Received: {profileImage.ContentType}" });
                    }
                    if (profileImage.Length > 20 * 1024 * 1024)
                    {
                        _logger.LogWarning($"File too large: {profileImage.Length} bytes. Rejecting upload.");
                        return BadRequest(new { error = $"Image must be less than 4MB. Received: {profileImage.Length} bytes" });
                    }

                    // Create uploads directory
                    var uploadsDir = Path.Combine(_env.WebRootPath, "uploads", "profiles");
                    Directory.CreateDirectory(uploadsDir);

                    // Find existing profile for old image deletion
                    var existingProfile = await _context.UserProfiles.FirstOrDefaultAsync(u => u.Email == email);
                    if (!string.IsNullOrEmpty(existingProfile?.ProfileImageUrl))
                    {
                        var oldPath = Path.Combine(_env.WebRootPath, existingProfile.ProfileImageUrl.TrimStart('/'));
                        if (System.IO.File.Exists(oldPath))
                        {
                            System.IO.File.Delete(oldPath);
                        }
                    }

                    // Generate unique filename
                    var extension = Path.GetExtension(profileImage.FileName).ToLower();
                    var fileName = $"{Guid.NewGuid()}{extension}";
                    var filePath = Path.Combine(uploadsDir, fileName);

                    // Save file
                    using var stream = new FileStream(filePath, FileMode.Create);
                    await profileImage.CopyToAsync(stream);

                    imageUrl = $"/uploads/profiles/{fileName}";
                }

                // Find or create profile
                var profile = await _context.UserProfiles.FirstOrDefaultAsync(u => u.Email == email);
                if (profile == null)
                {
                    profile = new UserProfile
                    {
                        Email = email,
                        PhoneNumber = phoneNumber,
                        ProfileImageUrl = imageUrl
                    };
                    _context.UserProfiles.Add(profile);
                    _logger.LogInformation("Created new profile for email: {Email}", email);
                }
                else
                {
                    profile.PhoneNumber = phoneNumber;
                    if (imageUrl != null)
                    {
                        profile.ProfileImageUrl = imageUrl;
                    }
                    _logger.LogInformation("Updated existing profile for email: {Email}", email);
                }

                await _context.SaveChangesAsync();

                return Ok(new
                {
                    Email = profile.Email,
                    PhoneNumber = profile.PhoneNumber,
                    ProfileImageUrl = profile.ProfileImageUrl ?? ""
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating profile");
                return StatusCode(500, new { error = "Internal server error" });
            }
        }
    }
}