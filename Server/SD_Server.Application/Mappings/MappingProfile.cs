using AutoMapper;
using SD_Server.Application.Features.Avaliations.DTO;
using SD_Server.Application.Features.Professionals.DTO;
using SD_Server.Application.Features.Students.DTO;
using SD_Server.Domain.Features.Avaliations;
using SD_Server.Domain.Features.Professionals;
using SD_Server.Domain.Features.Students;

namespace SD_Server.Application.Mappings
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Professional, ProfessionalDTO>();
            CreateMap<Student, StudentDTO>();
            CreateMap<Avaliation, AvaliationDTO>()
                .ForMember(dest => dest.StudentName,      opt => opt.MapFrom(src => src.Student != null ? src.Student.Name : null))
                .ForMember(dest => dest.ProfessionalName, opt => opt.MapFrom(src => src.Professional != null ? src.Professional.Name : null));
        }
    }
}
