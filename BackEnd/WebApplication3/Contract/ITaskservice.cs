using WebApplication3.Models;

namespace WebApplication3.Contract
{
    public interface ITaskservice
    {
        Task<string> AddTaskAsync(string title, string descrip, string status, DateTime deadline, int userID);

        Task<string> DeleteTaskAsync(int taskID);

        Task<string> UpdateTaskAsync(int taskId, string Title, string Descrip, string Status, DateTime Deadline, int UserID);

        Task<Taskmanager> GetTaskAsync(int taskID);

        Task<IEnumerable<Taskmanager>> GetallTaskAsync(int userID);
    }
}
