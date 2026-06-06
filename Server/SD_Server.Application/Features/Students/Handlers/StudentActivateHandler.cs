using MediatR;
using Microsoft.Extensions.Logging;
using SD_Server.Application.Features.Students.Commands.Activate;
using SD_Server.Domain.Base;
using SD_Server.Domain.Enum;
using SD_Server.Domain.Exceptions;
using SD_Server.Domain.Features.Students;
using SD_SharedKernel.Helpers;
using Unit = SD_SharedKernel.Helpers.Unit;

namespace SD_Server.Application.Features.Students.Handlers
{
    public class StudentActivateHandler
    {
        public class Handler(
            ILogger<Handler> logger,
            IStudentRepository repository,
            IUnitOfWork unitOfWork) : IRequestHandler<ActivateStudentCommand, Result<Exception, Unit>>
        {
            public async Task<Result<Exception, Unit>> Handle(ActivateStudentCommand request, CancellationToken cancellationToken)
            {
                logger.LogInformation("Ativando aluno Id: {Id}", request.Id);

                var studentResult = await repository.GetByIdAsync(request.Id);
                if (studentResult.IsFailure || studentResult.Success == null)
                    return new BusinessException(ErrorCodes.NotFound, $"Aluno {request.Id} não encontrado.");

                await unitOfWork.BeginTransactionAsync(cancellationToken);
                try
                {
                    var student = studentResult.Success;
                    student.Status = StatusEnum.Active;

                    var updateResult = await repository.UpdateAsync(student);
                    if (updateResult.IsFailure)
                    {
                        await unitOfWork.RollbackAsync(cancellationToken);
                        return updateResult.Failure;
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
}
