using DeboAlertApi.Data;
using DeboAlertApi.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);

// Configure Kestrel for larger file uploads
builder.WebHost.ConfigureKestrel(options =>
{
    options.Limits.MaxRequestBodySize = 20_000_000; // 20MB
});

builder.Services.AddControllers();
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Add CORS policy - Add this section
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        policy =>
        {
            policy.AllowAnyOrigin()
                  .AllowAnyMethod()
                  .AllowAnyHeader()
                  .WithExposedHeaders("*")
                  .SetIsOriginAllowed(origin => true);
        });
});

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.Authority = "https://securetoken.google.com/debo-alert";
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = "https://securetoken.google.com/debo-alert",
            ValidateAudience = true,
            ValidAudience = "debo-alert",
            ValidateLifetime = true,
            ClockSkew = TimeSpan.FromMinutes(5),
            NameClaimType = "email" // Add this line
        };
        // Add detailed logging for authentication failures
        options.Events = new JwtBearerEvents
        {
            OnAuthenticationFailed = context =>
            {
                var logger = context.HttpContext.RequestServices.GetRequiredService<ILogger<Program>>();
                logger.LogError($"Authentication failed: {context.Exception.Message}");
                if (context.Exception is SecurityTokenExpiredException)
                    logger.LogError("Token is expired");
                else if (context.Exception is SecurityTokenInvalidAudienceException)
                    logger.LogError($"Invalid audience. Expected: debo-alert");
                else if (context.Exception is SecurityTokenInvalidIssuerException)
                    logger.LogError($"Invalid issuer. Expected: https://securetoken.google.com/debo-alert");
                return Task.CompletedTask;
            },
            OnTokenValidated = context =>
            {
                var logger = context.HttpContext.RequestServices.GetRequiredService<ILogger<Program>>();
                logger.LogInformation($"Token validated for: {context.Principal.Identity?.Name}");
                foreach (var claim in context.Principal.Claims)
                {
                    logger.LogDebug($"Claim: {claim.Type} = {claim.Value}");
                }
                return Task.CompletedTask;
            },
            OnChallenge = context =>
            {
                var logger = context.HttpContext.RequestServices.GetRequiredService<ILogger<Program>>();
                logger.LogError($"Challenge error: {context.Error}, Description: {context.ErrorDescription}");
                return Task.CompletedTask;
            }
        };
    });

var app = builder.Build();

app.UseCors("AllowAll"); // Add this before other middleware
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.UseStaticFiles();
app.MapControllers();

app.MapGet("/api/test", () => new { message = "Server is running", time = DateTime.UtcNow })
   .AllowAnonymous();
app.MapGet("/health", () => new { status = "Healthy", time = DateTime.UtcNow }).AllowAnonymous();
// Add this before app.Run()
app.MapGet("/", () => "DeboAlert API is running. Use /api/test to verify.");

// Log all registered endpoints
if (app.Environment.IsDevelopment())
{
    app.MapGet("/debug/routes", (IEnumerable<EndpointDataSource> endpointSources) =>
    {
        var sb = new StringBuilder();
        sb.AppendLine("Registered routes:");
        foreach (var endpointSource in endpointSources)
        {
            foreach (var endpoint in endpointSource.Endpoints.OfType<RouteEndpoint>())
            {
                sb.AppendLine($"{endpoint.DisplayName}");
                sb.AppendLine($"  Pattern: {endpoint.RoutePattern.RawText}");
                foreach (var metadata in endpoint.Metadata)
                {
                    sb.AppendLine($"  Metadata: {metadata}");
                }
                sb.AppendLine();
            }
        }
        return sb.ToString();
    }).AllowAnonymous();
}

Console.WriteLine("Application starting on: http://10.2.71.11:5099");
Console.WriteLine("Available endpoints:");
Console.WriteLine("  GET /api/test");
Console.WriteLine("  GET /api/userprofile/test-auth");
Console.WriteLine("  GET /api/userprofile/test-protected");
Console.WriteLine("  GET /api/userprofile/me");

app.Run("http://*:5099");

[ApiController]
[Route("api/[controller]")]
public class UserProfileController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly ILogger<UserProfileController> _logger;

    public UserProfileController(AppDbContext context, ILogger<UserProfileController> logger)
    {
        _context = context;
        _logger = logger;
    }

    [HttpPost("upsert")]
    [RequestSizeLimit(50 * 1024 * 1024)] // 50 MB
    public async Task<IActionResult> UpsertProfile([FromBody] UserProfile profile)
    {
        if (profile == null)
        {
            return BadRequest("Profile data is null.");
        }

        try
        {
            var existingProfile = await _context.UserProfiles.FindAsync(profile.Id);
            if (existingProfile == null)
            {
                // Create new profile
                _context.UserProfiles.Add(profile);
                _logger.LogInformation($"Profile created: {profile.Id}");
            }
            else
            {
                // Update existing profile
                existingProfile.Email = profile.Email;
                existingProfile.PhoneNumber = profile.PhoneNumber;
                existingProfile.ProfileImageUrl = profile.ProfileImageUrl;
                existingProfile.UpdatedAt = DateTime.UtcNow;
                existingProfile.FirebaseUserId = profile.FirebaseUserId;
                _logger.LogInformation($"Profile updated: {profile.Id}");
            }

            await _context.SaveChangesAsync();
            return Ok(profile);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error upserting profile");
            return StatusCode(500, "Internal server error");
        }
    }

    // ...existing actions...
}