using MediatR;
using SD_SharedKernel.Helpers;
using Unit = SD_SharedKernel.Helpers.Unit;

namespace SD_Server.Application.Features.Professionals.Commands.Delete
{
    public class DeleteProfessionalCommand : IRequest<Result<Exception, Unit>>
    {
        public int Id { get; set; }
    }
}
