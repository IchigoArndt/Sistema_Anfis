using MediatR;
using SD_Server.Application.Features.Professionals.DTO;
using SD_SharedKernel.Helpers;

namespace SD_Server.Application.Features.Professionals.Commands.Update
{
    public class UpdateProfessionalCommand : IRequest<Result<Exception, ProfessionalDTO>>
    {
        public int Id { get; set; }
        public string? Name { get; set; }
        public string? Email { get; set; }
        public string? Phone { get; set; }
        public string? Bio { get; set; }
        public string? Specialty { get; set; }
        public string? Methodology { get; set; }
        public decimal? Price { get; set; }
        public string? Experience { get; set; }
    }
}
