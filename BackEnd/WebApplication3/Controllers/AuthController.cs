using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WebApplication3.Contract;

namespace WebApplication3.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IAuthservice _authService;
        public AuthController(IAuthservice authservice)
        {
            _authService = authservice;
        }


        [HttpPost("register")]

        public async Task<IActionResult> Register(string username, string emailID, string password)
        {
            var result = await _authService.RegisterUserAsync(username, emailID, password);
            return Ok(result);
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login( string emailID, string password)
        {
            var result = await _authService.LoginUserAsync( emailID, password);
            return Ok(result);
        }
    }
}

