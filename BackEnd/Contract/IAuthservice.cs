using WebApplication3.dto;

namespace WebApplication3.Contract
{
    public interface IAuthservice
    {
        Task<string> RegisterUserAsync(string username, string emailID, string password);

        Task<loginresponse> LoginUserAsync(string emailID, string password);



    }
}