using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace NVFRCommon.DataTools
{
    /// <summary>
    /// Created: 2/11/09
    /// Created by: Adonis Villanueva
    /// Function: Simplifies ADO.NET handling.
    /// </summary>
    public class DBAccess : IDisposable
    {

        public IDbCommand cmd = new SqlCommand();
        private string strConnectionString = "";
        private bool handleErrors = false;
        private string strLastError = "";

        public DBAccess()
        {
            ConnectionStringSettings objConnectionStringSettings = ConfigurationManager.ConnectionStrings["NVFRConnectionString"];
            strConnectionString = objConnectionStringSettings.ConnectionString;
            SqlConnection cnn = new SqlConnection();
            cnn.ConnectionString = ConnectionString;
            cmd.Connection = cnn;
            cmd.CommandType = CommandType.StoredProcedure;
        }

        /// <summary>
        /// Overload for custom connection.
        /// </summary>
        /// <param name="Connection1"></param>
        public DBAccess(string Connection1)
        {
            SqlConnection cnn = new SqlConnection();
            cnn.ConnectionString = Connection1;
            cmd.Connection = cnn;
            //cmd.CommandType = CommandType.Text;
        }


        /// <summary>
        /// Reads straight data.
        /// </summary>
        /// <returns></returns>
        public IDataReader ExecuteReader()
        {
            IDataReader reader = null;
            try
            {
                Open();
                reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            }
            catch (Exception ex)
            {
                if (handleErrors)
                    strLastError = ex.Message;
                else
                    throw;
            }

            return reader;
        }

        /// <summary>
        /// Provide DataAdapter.
        /// </summary>
        /// <returns>DataAdapter</returns>
        public SqlDataAdapter ExecuteAdapter()
        {
            SqlDataAdapter da = null;
            try
            {
                da = new SqlDataAdapter();
                da.SelectCommand = (SqlCommand)cmd;
            }
            catch (Exception ex)
            {
                if (handleErrors)
                    strLastError = ex.Message;
                else
                    throw;
            }
            return da;
        }

        
        /// <summary>
        /// Used to obtain scalar object from the database.
        /// </summary>
        /// <returns>Scalar Object</returns>
        public object ExecuteScalar()
        {
            object obj = null;
            try
            {
                Open();
                obj = cmd.ExecuteScalar();
                Close();
            }
            catch (Exception ex)
            {
                if (handleErrors)
                    strLastError = ex.Message;
                else
                    throw;
            }

            return obj;
        }

        /// <summary>
        /// Used for non select queries.
        /// </summary>
        /// <returns>Output</returns>
        public int ExecuteNonQuery()
        {
            int i = -1;
            try
            {
                Open();
                i = cmd.ExecuteNonQuery();
                Close();
            }
            catch (Exception ex)
            {
                if (handleErrors)
                    strLastError = ex.Message;
                else
                    throw;
            }
            return i;
        }

        /// <summary>
        /// Returns a dataset from the database.
        /// </summary>
        /// <returns>SQL Dataset</returns>
        public DataSet ExecuteDataSet()
        {
            SqlDataAdapter da = null;
            DataSet ds = null;
            try
            {
                da = new SqlDataAdapter();
                da.SelectCommand = (SqlCommand)cmd;
                ds = new DataSet();
                da.Fill(ds);
            }
            catch (Exception ex)
            {
                if (handleErrors)
                    strLastError = ex.Message;
                else
                    throw;
            }
            return ds;
        }

        /// <summary>
        /// The SQL Command string, the type (ie., Stored Proc or SQL query) is determined in the DbAccess method.
        /// </summary>
        public string CommandText
        {
            get
            {
                return cmd.CommandText;
            }
            set
            {
                cmd.CommandText = value;
                cmd.Parameters.Clear();
            }
        }

        public IDataParameterCollection Parameters
        {
            get
            {
                return cmd.Parameters;
            }
        }

        /// <summary>
        ///Captures Parameter name and values and adds it to the command collection
        /// </summary>
        /// <param name="paramname">@Param</param>
        /// <param name="paramvalue">Value</param>
        public void AddParameter(string paramname, object paramvalue)
        {
            SqlParameter param = new SqlParameter(paramname, paramvalue);
            cmd.Parameters.Add(param);
        }

        public void AddParameter(SqlParameter param)
        {
            cmd.Parameters.Add(param);
        }

        public void AddParameter(IDataParameter param)
        {
            cmd.Parameters.Add(param);
        }

        /// <summary>
        /// The connection string.
        /// </summary>
        public string ConnectionString
        {
            get
            {
                return strConnectionString;
            }
            set
            {
                strConnectionString = value;
            }
        }

        
        /// <summary>
        /// Open the connection for the command.
        /// </summary>
        private void Open()
        {
            cmd.Connection.Open();
        }

        /// <summary>
        /// Close connection.
        /// </summary>
        private void Close()
        {
            cmd.Connection.Close();
        }
        
        /// <summary>
        /// Bool for determining if error has occured.
        /// </summary>

        public bool HandleExceptions
        {
            get
            {
                return handleErrors;
            }
            set
            {
                handleErrors = value;
            }
        }

        /// <summary>
        /// Capture the error message.
        /// </summary>
        public string LastError
        {
            get
            {
                return strLastError;
            }
        }


        public void Dispose()
        {
            cmd.Dispose();
        }
    }
}