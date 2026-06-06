using Microsoft.AspNetCore.Mvc;
using SD_Server.Domain.Base;
using SD_Server.Domain.Enum;
using SD_Server.Domain.Features.Users;
using BC = BCrypt.Net.BCrypt;

namespace SD_Server.Api.Controllers.Setup
{
    [ApiController]
    [Route("[controller]")]
    public class SetupController(IUserRepository userRepository, IUnitOfWork unitOfWork) : ControllerBase
    {
        [HttpPost("CreateAdmin")]
        public async Task<IActionResult> CreateAdmin([FromBody] CreateAdminRequest request)
        {
            if (!string.Equals(Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT"), "Development",
                StringComparison.OrdinalIgnoreCase))
                return NotFound();

            var user = new User
            {
                Email        = request.Email,
                Name         = request.Name,
                TypeAccess   = TypeUserEnum.Admin,
                Status       = StatusEnum.Active,
                CreatedAt    = DateTime.UtcNow,
                PasswordHash = BC.HashPassword(request.Password)
            };

            await unitOfWork.BeginTransactionAsync(default);
            try
            {
                var result = await userRepository.AddAsync(user);
                if (result.IsFailure)
                {
                    await unitOfWork.RollbackAsync(default);
                    return BadRequest(result.Failure.Message);
                }
                await unitOfWork.CommitAsync(default);
                return Ok(new { id = result.Success, email = request.Email });
            }
            catch (Exception ex)
            {
                await unitOfWork.RollbackAsync(default);
                return BadRequest(ex.Message);
            }
        }

        public record CreateAdminRequest(string Name, string Email, string Password);
    }
}
