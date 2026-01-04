using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using DeboAlertApi.Models;

namespace DeboAlertApi.Models
{
    public class UserProfile
    {
        [Key]
        public int Id { get; set; }
        
        [Required]
        public string Email { get; set; } = string.Empty;
        
        public string? PhoneNumber { get; set; }
        
        public string? ProfileImageUrl { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        public DateTime? UpdatedAt { get; set; }
        
        // Add FirebaseUserId if you need it
        public string? FirebaseUserId { get; set; }
    }
}