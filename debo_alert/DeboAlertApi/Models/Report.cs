namespace DeboAlertApi.Models
{
    public class Report
    {
        public int Id { get; set; }
        public string? Category { get; set; }
        public string? Description { get; set; }
        public string? MediaUrl { get; set; }
        public bool IsVideo { get; set; }
        public DateTime Timestamp { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public string? Status { get; set; }
        public string? UserId { get; set; }
    }

    public class UpdateReportStatusDto
    {
        public string Status { get; set; }
    }
}