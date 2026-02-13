using BCrypt.Net;
using Dapper;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.Data;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using WebApplication3.Contract;
using WebApplication3.dto;
using WebApplication3.Models;

namespace WebApplication3.Services
{
    public class Authservices : IAuthservice
    {
        private readonly IDbConnection _dbConnection;
        private readonly IConfiguration _configuration;

        public Authservices(IDbConnection dbConnection , IConfiguration configuration)
        {
            _dbConnection = dbConnection;
            _configuration = configuration;


        }


        public async Task<string> RegisterUserAsync(string username, string emailID, string password)
        {
            var existingUser = await _dbConnection.QueryFirstOrDefaultAsync<User>(
                "SELECT * FROM Users WHERE emailID = @emailID", new { emailID });
            if (existingUser != null)
            {
                return "User already exists";

            }

            var hashedpassword = BCrypt.Net.BCrypt.HashPassword(password);

            var result = await _dbConnection.ExecuteAsync(
                "INSERT INTO Users (Username,emailID,Password) VALUES (@username, @emailID, @password)",
                new { Username = username, emailID = emailID, Password = hashedpassword });

            //return result > 0 ? "Registarion Succesful!" : "failed to register user.";

            if (result > 0)
                return "Registarion Succesful!";
            else
                return "failed";




        }
        public async Task<loginresponse> LoginUserAsync(string emailID, string password)
        {


           

            var existingUser = await _dbConnection.QueryFirstOrDefaultAsync<User>(
                "SELECT * FROM Users WHERE emailID = @emailID ", new { emailID=emailID });
            if (existingUser == null)
            {
                return new loginresponse
                {
                    message="incorrect credentials"
                };
            }
            var hashedpassword = BCrypt.Net.BCrypt.Verify(password, existingUser.password);
            var token = GenerateJwtToken(existingUser);
            if (hashedpassword == true)
            {
           
                return new loginresponse
                {
                    UserID = existingUser.UserID,
                    username = existingUser.username,
                    message= "login sucessful",
                    token = token



                };
            }
            else
            {
                return new loginresponse
                {
                    
                    message = "incorrect credentials"
                };
            }
        }

        private string GenerateJwtToken(User user)
        {
            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.UserID.ToString()),
                new Claim(ClaimTypes.Name, user.username),
                new Claim(ClaimTypes.Role, user.role),
            };
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:SecretKey"]));
            var creds= new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                _configuration["Jwt:Issuer"],
                _configuration["Jwt:Audience"],
                claims,
                expires: DateTime.Now.AddHours(5),
                signingCredentials : creds);
            return new JwtSecurityTokenHandler().WriteToken(token);
                

        }




    }

}

