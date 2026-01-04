namespace DeboAlertApi.Models
{
    public class ReportDto
    {
        public string Category { get; set; }
        public string Description { get; set; }
        public bool IsVideo { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public IFormFile? Media { get; set; }
    }
}