using Microsoft.EntityFrameworkCore;
using SD_Server.Domain.Enum;
using SD_Server.Domain.Features.StudentProfessionals;
using SD_Server.Domain.Features.Students;
using SD_Server.Infra.Data.Context;
using SD_SharedKernel.Helpers;

namespace SD_Server.Infra.Data.Features.StudentProfissionals;

public class StudentProfissionalRepository(SdServerDbContext context) : IStudentProfissionalRepository
{
    public async Task<Result<Exception, int>> AddAsync(StudentProfessional entity)
    {
        try
        {
            context.StudentProfessionals.Add(entity);
            await context.SaveChangesAsync();
            return entity.Id;
        }
        catch (Exception ex)
        {
            return new Exception($"Error saving changes: {ex.Message}", ex);
        }
    }

    public Task<Result<Exception, IQueryable<StudentProfessional>>> GetAllAsync()
    {
        return Task.FromResult(
            Result<Exception, IQueryable<StudentProfessional>>.Of(
                context.StudentProfessionals.AsNoTracking().AsQueryable()));
    }

    public async Task<Result<Exception, StudentProfessional>> GetByIdAsync(int id)
    {
        var entity = await context.StudentProfessionals.AsNoTracking()
            .FirstOrDefaultAsync(x => x.Id == id);
        if (entity is null)
            return new KeyNotFoundException($"Vínculo {id} não encontrado.");
        return entity;
    }

    public async Task<Result<Exception, Unit>> UpdateAsync(StudentProfessional entity)
    {
        try
        {
            var existing = await context.StudentProfessionals.FirstOrDefaultAsync(x => x.Id == entity.Id);
            if (existing is null)
                return new KeyNotFoundException($"Vínculo {entity.Id} não encontrado.");
            existing.Status = entity.Status;
            await context.SaveChangesAsync();
            return Unit.Sucessful;
        }
        catch (Exception ex)
        {
            return new Exception($"Erro ao atualizar vínculo: {ex.Message}", ex);
        }
    }

    public async Task<Result<Exception, Unit>> DeleteAsync(StudentProfessional entity)
    {
        try
        {
            var existing = await context.StudentProfessionals.FirstOrDefaultAsync(x => x.Id == entity.Id);
            if (existing is null)
                return new KeyNotFoundException($"Vínculo {entity.Id} não encontrado.");
            existing.Status = StatusEnum.Inactive;
            await context.SaveChangesAsync();
            return Unit.Sucessful;
        }
        catch (Exception ex)
        {
            return new Exception($"Erro ao excluir vínculo: {ex.Message}", ex);
        }
    }

    public Task<Result<Exception, IQueryable<Student>>> GetAllUserIdByProfessionalId(int professionalId)
    {
        return Task.FromResult(Result<Exception, IQueryable<Student>>.Of(context.StudentProfessionals.AsNoTracking().Where(x => x.ProfessionalId == professionalId).Select(x => x.Student).AsQueryable()));
    }
}