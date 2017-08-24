using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Odbc;
using System.Text;

namespace NVFRCommon
{
    public class MAS
    {
        private OdbcConnection conn = null;
        private OdbcCommand cmd = null;

        public DataTable GetARCustomer()
        {
            OdbcConnection Conn = new System.Data.Odbc.OdbcConnection("DSN=MAS");

            OdbcCommand catCMD = new OdbcCommand("SELECT AR_Customer.CustomerNo FROM AR_Customer", Conn);

            Conn.Open();

            DataTable table = new DataTable();

            OdbcDataAdapter adap = new OdbcDataAdapter(cmd);

            adap.Fill(table);

            return table;
        }
    }
}
