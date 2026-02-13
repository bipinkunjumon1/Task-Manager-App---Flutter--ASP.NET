using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using WebApplication3.Contract;
using WebApplication3.Services;

namespace WebApplication3.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TaskController : ControllerBase
    {
        private readonly ITaskservice _taskService;
        public TaskController(ITaskservice taskservice)
        {
            _taskService = taskservice;
        }

        [HttpPost("addtask")]
        public async Task<IActionResult> AddTaskAsync(string Title, string Descrip, string Status, DateTime Deadline, int UserID)
        {
            var result = await _taskService.AddTaskAsync(Title, Descrip, Status, Deadline, UserID);
            return Ok(result);
        }

        [HttpPost("deletetask")]
        public async Task<IActionResult> DeleteTaskAsync(int taskID)
        {
            var results = await _taskService.DeleteTaskAsync(taskID);
            return Ok(results);
        }

        [HttpPost("updatetask")]
        public async Task<IActionResult> UpdateTaskAsync(int taskID, string Title, string Descrip, string Status, DateTime Deadline, int UserID)
        {
            var result = await _taskService.UpdateTaskAsync(taskID, Title, Descrip, Status, Deadline, UserID);
            return Ok(result);
        }


      
        [HttpGet("gettask")]
        public async Task<IActionResult> GetTaskAsync(int taskID)
        {
            var result = await _taskService.GetTaskAsync(taskID);
            return Ok(result);
        }

       
        [HttpGet("get_list_of_tasks")]

        public async Task<IActionResult> GetallTaskAsync(int userID)
        {
            var result = await _taskService.GetallTaskAsync(userID);
            return Ok(result);
        }

    


    }
}