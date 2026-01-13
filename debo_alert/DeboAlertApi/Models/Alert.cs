using System;
using System.ComponentModel.DataAnnotations;

namespace DeboAlertApi.Models
{
    public class Alert
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public string Title { get; set; } = string.Empty;
        public string? Description { get; set; }
        public string Region { get; set; } = string.Empty;
        public string Severity { get; set; } = "Medium";
        public string Status { get; set; } = "Active"; // Active, Verified, Resolved
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}