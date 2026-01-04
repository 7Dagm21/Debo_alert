using Microsoft.EntityFrameworkCore;
using DeboAlertApi.Models;

namespace DeboAlertApi.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options) { }

        public DbSet<UserProfile> UserProfiles { get; set; }
        public DbSet<Report> Reports { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<UserProfile>()
                .HasIndex(u => u.Email)
                .IsUnique();
        }
    }
}
