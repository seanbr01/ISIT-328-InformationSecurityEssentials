using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using ISIT328.Models;
using Microsoft.Extensions.Configuration;
using ISIT328.DAL;
using ISIT328.Models;
using System.Text.RegularExpressions;

namespace ISIT328.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IConfiguration _configuration;

        public HomeController(ILogger<HomeController> logger, IConfiguration config)
        {
            _configuration = config;
            _logger = logger;
        }

        public IActionResult Index(CredentialModel cm)
        {
            // everything is fine here. No need to change anything here
            DALPerson pd = new DALPerson(this._configuration);
            LinkedList<PersonModel> allPerson = pd.GetAllPerson();
            ViewBag.AllPerson = allPerson;

            return View();
        }

        
        public IActionResult UserLogin(CredentialModel cm)
        {

            try
            {
                // write our regex here

                var input = cm.Password;
                var input2 = cm.UserName;

                // just get the info to display all users
                DALPerson pd = new DALPerson(this._configuration);
                LinkedList<PersonModel> allPerson = pd.GetAllPerson();
                ViewBag.AllPerson = allPerson;

                var blackList = new string[] { " ", "'", "\"", "-" };

                bool testPassed = true;
                foreach (string pattern in blackList)
                {
                    foreach (char character in input)
                    {
                        if (Regex.IsMatch(character.ToString(), pattern))
                        {
                            testPassed = false;
                            break;
                        }
                    }
                    foreach (char character in input2)
                    {
                        if (Regex.IsMatch(character.ToString(), pattern))
                        {
                            testPassed = false;
                            break;
                        }
                    }

                }

                // everything is fine here. No need to change anything here
                PersonModel pm = (testPassed) ? pd.CheckLoginCredentials(cm) : null;
                if (pm == null)
                {
                    ViewBag.LoginStatus = "Login Failed!!";
                }
                else
                {
                    ViewBag.LoginStatus = "Login Succeeded";
                }
                return View("Index");

            }

            catch (Exception ex)
            {
                return View("ErrorPage");
            }

            
        }
    }
}
