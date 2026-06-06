using AutoMapper;
using MediatR;
using Microsoft.Extensions.Logging;
using SD_Server.Application.Features.Professionals.Commands.Update;
using SD_Server.Application.Features.Professionals.DTO;
using SD_Server.Domain.Base;
using SD_Server.Domain.Exceptions;
using SD_Server.Domain.Features.Professionals;
using SD_SharedKernel.Helpers;

namespace SD_Server.Application.Features.Professionals.Handlers
{
    public class UpdateProfessionalCommandHandler(
        ILogger<UpdateProfessionalCommandHandler> logger,
        IProfessionalRepository repository,
        IUnitOfWork unitOfWork,
        IMapper mapper) : IRequestHandler<UpdateProfessionalCommand, Result<Exception, ProfessionalDTO>>
    {
        public async Task<Result<Exception, ProfessionalDTO>> Handle(UpdateProfessionalCommand request, CancellationToken cancellationToken)
        {
            logger.LogInformation("Atualizando profissional Id: {Id}", request.Id);

            var existingResult = await repository.GetByIdAsync(request.Id);
            if (existingResult.IsFailure)
                return new BusinessException(ErrorCodes.NotFound, $"Profissional {request.Id} não encontrado.");

            await unitOfWork.BeginTransactionAsync(cancellationToken);
            try
            {
                var professional = existingResult.Success;

                if (!string.IsNullOrWhiteSpace(request.Name))        professional.Name        = request.Name;
                if (!string.IsNullOrWhiteSpace(request.Email))       professional.Email       = request.Email;
                if (!string.IsNullOrWhiteSpace(request.Phone))       professional.Phone       = request.Phone;
                if (!string.IsNullOrWhiteSpace(request.Bio))         professional.Bio         = request.Bio;
                if (!string.IsNullOrWhiteSpace(request.Specialty))   professional.Specialty   = request.Specialty;
                if (!string.IsNullOrWhiteSpace(request.Methodology)) professional.Methodology = request.Methodology;
                if (!string.IsNullOrWhiteSpace(request.Experience))  professional.Experience  = request.Experience;
                if (request.Price.HasValue)                           professional.Price       = request.Price;

                var updateResult = await repository.UpdateAsync(professional);
                if (updateResult.IsFailure)
                {
                    await unitOfWork.RollbackAsync(cancellationToken);
                    return updateResult.Failure;
                }

                await unitOfWork.CommitAsync(cancellationToken);

                var updatedResult = await repository.GetByIdAsync(request.Id);
                return updatedResult.IsFailure
                    ? new Exception("Erro ao recuperar profissional atualizado.")
                    : mapper.Map<ProfessionalDTO>(updatedResult.Success);
            }
            catch (Exception ex)
            {
                await unitOfWork.RollbackAsync(cancellationToken);
                return ex;
            }
        }
    }
}
