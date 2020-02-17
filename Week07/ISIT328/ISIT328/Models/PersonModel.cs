using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ISIT328.Models
{
    /// <summary>
    /// Just a model to hold the information from the Person
    /// </summary>
    public class PersonModel
    {
        public string FName { get; set; }
        public string LName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string PersonID { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
    }
}
