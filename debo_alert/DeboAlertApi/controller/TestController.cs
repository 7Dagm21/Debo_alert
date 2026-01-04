using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

namespace DeboAlertApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TestController : ControllerBase
    {
        [HttpGet]
        public IActionResult Get()
        {
            return Ok(new { message = "API is working", time = DateTime.UtcNow });
        }

        [HttpGet("public")]
        public IActionResult Public()
        {
            return Ok(new { message = "Public endpoint works", time = DateTime.UtcNow });
        }

        [HttpGet("protected")]
        [Authorize]
        public IActionResult Protected()
        {
            var claims = User.Claims.Select(c => new { c.Type, c.Value }).ToList();
            return Ok(new { 
                message = "Protected endpoint reached",
                isAuthenticated = User.Identity?.IsAuthenticated,
                name = User.Identity?.Name,
                email = User.FindFirst("email")?.Value,
                claims 
            });
        }
    }
}