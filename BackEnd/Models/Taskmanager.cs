namespace WebApplication3.Models
{
    public class Taskmanager
    {
        public int taskID { get; set; }

        public string title { get; set; }

        public string descrip { get; set; }

        public string status { get; set; }

        public DateTime deadline{ get; set; }

        public int userID { get; set; }
    }
}
