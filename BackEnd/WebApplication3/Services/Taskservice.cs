using Dapper;
using System.Data;
using WebApplication3.Contract;
using WebApplication3.Models;

namespace WebApplication3.Services
{
    public class Taskservice : ITaskservice
    {
        private readonly IDbConnection _dbConnection;

        public Taskservice(IDbConnection dbConnection)
        {
            _dbConnection = dbConnection;

        }
        public async Task<string> AddTaskAsync(string Title, string Descrip, string Status, DateTime Deadline, int UserID)
        {
            var result = await _dbConnection.ExecuteAsync(
               "INSERT INTO taskmanger (title,descrip,status,deadline,userID) VALUES (@title, @descrip, @status,@deadline,@userID)",
               new { title = Title, descrip = Descrip, status = Status, deadline = Deadline, userID = UserID });



            if (result > 0)
            {

                return "task created succesfully";
            }
            else
            {
                return "failed";
            }
        }
        public async Task<string> DeleteTaskAsync(int taskID)
        {
            var results = await _dbConnection.ExecuteAsync(
                "DELETE FROM taskmanger where taskID=@taskID", new { taskID = taskID });

            return "deleted sucessfully";
        }

        public async Task<string> UpdateTaskAsync(int taskID, string Title, string Descrip, string Status, DateTime Deadline, int UserID)
        {
            var result = await _dbConnection.ExecuteAsync(
                "UPDATE  taskmanger SET title=@title,descrip=@descrip, status=@status, deadline=@deadline,userID=@userID where taskID=@taskID ",
                new { taskID = taskID, title = Title, descrip = Descrip, status = Status, deadline = Deadline, userID = UserID });

            return "updated succesfully";
        }
        public async Task<Taskmanager> GetTaskAsync(int taskID)

        {
            var result = await _dbConnection.QueryFirstOrDefaultAsync<Taskmanager>(
                "SELECT * FROM taskmanger where taskID=@taskID",
                new { taskID = taskID });

            return result;


        }

        public async Task<IEnumerable<Taskmanager>> GetallTaskAsync(int userID)
        {
            var result = await _dbConnection.QueryAsync<Taskmanager>(
                "SELECT * FROM taskmanger where userID=@userID",
                new
                {
                    userID = userID
                });

            return result;

        }



    }
}

