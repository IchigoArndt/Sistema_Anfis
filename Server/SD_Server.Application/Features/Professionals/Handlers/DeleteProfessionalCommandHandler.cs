using MediatR;
using Microsoft.Extensions.Logging;
using SD_Server.Application.Features.Professionals.Commands.Delete;
using SD_Server.Domain.Base;
using SD_Server.Domain.Exceptions;
using SD_Server.Domain.Features.Professionals;
using SD_SharedKernel.Helpers;
using Unit = SD_SharedKernel.Helpers.Unit;

namespace SD_Server.Application.Features.Professionals.Handlers
{
    public class DeleteProfessionalCommandHandler(
        ILogger<DeleteProfessionalCommandHandler> logger,
        IProfessionalRepository repository,
        IUnitOfWork unitOfWork) : IRequestHandler<DeleteProfessionalCommand, Result<Exception, Unit>>
    {
        public async Task<Result<Exception, Unit>> Handle(DeleteProfessionalCommand request, CancellationToken cancellationToken)
        {
            logger.LogInformation("Excluindo profissional Id: {Id}", request.Id);

            var existingResult = await repository.GetByIdAsync(request.Id);
            if (existingResult.IsFailure)
                return new BusinessException(ErrorCodes.NotFound, $"Profissional {request.Id} não encontrado.");

            await unitOfWork.BeginTransactionAsync(cancellationToken);
            try
            {
                var deleteResult = await repository.DeleteAsync(existingResult.Success);
                if (deleteResult.IsFailure)
                {
                    await unitOfWork.RollbackAsync(cancellationToken);
                    return deleteResult.Failure;
                }

                await unitOfWork.CommitAsync(cancellationToken);
                return Unit.Sucessful;
            }
            catch (Exception ex)
            {
                await unitOfWork.RollbackAsync(cancellationToken);
                return ex;
            }
        }
    }
}
