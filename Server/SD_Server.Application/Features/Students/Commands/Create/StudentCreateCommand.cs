using MediatR;
using SD_Server.Application.Features.Students.DTO;
using SD_SharedKernel.Helpers;

namespace SD_Server.Application.Features.Students.Commands.Create
{
    public class StudentCreateCommand : IRequest<Result<Exception, StudentDTO>>
    {
        public string Name { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public int Age { get; set; }
        public string CellPhone { get; set; } = string.Empty;

        public int? ProfessionalId { get; set; } = null;
    }
}
