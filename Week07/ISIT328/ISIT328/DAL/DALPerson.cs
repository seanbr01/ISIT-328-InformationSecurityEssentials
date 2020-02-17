using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ISIT328.Models;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace ISIT328.DAL
{
    public class DALPerson
    {
        private IConfiguration configuration;

        public DALPerson(IConfiguration configuration)
        {
            this.configuration = configuration;
        }

        internal LinkedList<PersonModel> GetAllPerson()
        {
            //Step #1 - Connect to the DB
            string connStr = configuration.GetConnectionString("MyConnString");
            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            //Step #2 - create a command
            string query = "SELECT FName,LName,email,phone,PersonID,UserName,Password, PersonID FROM Person ";
            SqlCommand cmd = new SqlCommand(query, conn);

            //Step #3 - query the DB
            SqlDataReader reader = cmd.ExecuteReader();
            LinkedList<PersonModel> allPerson = new LinkedList<PersonModel>();

            // get all data coming from the DB
            while (reader.Read())
            {
                PersonModel pm = new PersonModel();
                pm.FName = reader["FName"].ToString();
                pm.LName = reader["LName"].ToString();
                pm.Email = reader["email"].ToString();
                pm.Phone = reader["phone"].ToString();
                pm.UserName = reader["UserName"].ToString();
                pm.PersonID = reader["PersonID"].ToString();
                pm.Password = reader["Password"].ToString();

                // add to the linked list
                allPerson.AddLast(pm);
            }

            // return the linked list
            return allPerson;
        }
        /// <summary>
        /// Checks the database to verify that there is actually a user with the username and password
        /// 
        /// </summary>
        /// <param name="CredentialModel"> CredentialModel with username and password</param>
        /// <returns>Returns the PersonModel if the username and passwords are correct.
        /// Returns null otherwise</returns>
        internal PersonModel CheckLoginCredentials(CredentialModel cm)
        {
            //Step #1 - Connect to the DB
            string connStr = configuration.GetConnectionString("MyConnString");
            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();

            //Step #2 - create a command

            // ---- DANGER ----
            // This is a problem because the query just concatenates the value coming from the user
            // The best solution would be to use stored procedures. But you don't have this option.
            // Your next best option is to use parametized query.

            //string query = "SELECT * from Person where UserName = '" + cm.UserName + "' and Password = '" + cm.Password + "'";
            string query = "SELECT * from Person where UserName = @UserName and Password = @Password";
            SqlCommand cmd = new SqlCommand(query, conn);

            cmd.Parameters.AddWithValue("@UserName", cm.UserName);
            cmd.Parameters.AddWithValue("@Password", cm.Password);

            PersonModel ps = null;

            //Step #3 - query the DB
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                ps = new PersonModel();
                ps.PersonID = reader["PersonID"].ToString();
                ps.FName = reader["FName"].ToString();
            }

            //Step 4
            conn.Close();

            return ps;
        }
    }
}
