using System;
using System.Collections.Generic;
using System.Text;

namespace NVFRCommon
{
    public static class PasswordUtils
    {
        private static string digits = "0123456789";
        private static string LCaseLetters = "abcdefghijklmnopqrstuvwxyz";
        private static string UCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        private static string SpecChar = " ,.:;!?/\\|@#$%^&*()[]{}<>+=-_«»\"\"<>";
        private static string SpecChar2 = "'";
        private static string SpecChar3 = "æøåÆØÅ";
        private static string CharacterArr;
        private static string PassArr;
        private static Int32 NumLength;
        private static Int32 PassLength;

        static PasswordUtils()
        {
            CharacterArr = digits + LCaseLetters + UCaseLetters + SpecChar + SpecChar2 + SpecChar3;
            PassArr = digits + LCaseLetters + UCaseLetters;
            NumLength = CharacterArr.Length;
            PassLength = PassArr.Length;
        }

        public static string CreatePassword()
        {
            string password;
            try
            {
                Int32 pwdLength = 6;
                Int32 ip;
                password = "";
                Random rnd = new Random();
                for (ip = 0; ip < pwdLength; ip++)
                {
                    double dbl = rnd.NextDouble();

                    password += PassArr.Substring(Convert.ToInt32((dbl * PassLength)) + 1, 1);
                }
            }
            catch
            {
                return CreatePassword();
            }

            return password;
        }

        public static string encode(string stringToEncode)
        {
            string encodedString = "";
            Random r = new Random();
            Int32 numRand = 0;
            Int32 i = 0;
            Int32 o = 0;
            Int32 p = 0;

            encodedString = "";
            numRand = Convert.ToInt32((r.NextDouble() * 89) + 10);
            //numRand = 90;
            for (i = 0; i < stringToEncode.Length; i++)
            {
                for (o = 0; o < NumLength; o++)
                {
                    if (CharacterArr.Substring(o, 1).CompareTo(stringToEncode.Substring(i, 1)) == 0)
                    {
                        p = 10000 + (numRand * 2 * (i + 1)) + (2 * NumLength * (o - 1)) +
                            (((i - 1) ^ 2) + 1 * numRand);
                        encodedString += p.ToString();
                    }
                }
            }
            encodedString += numRand;
            return encodedString;

        }

        public static string decode(string stringToDecode)
        {
            string decodedString = "";
            Int32 NumRand;
            Int32 n;
            Int32 i;
            Int32 p;
            Int32 q;

            NumRand = Convert.ToInt32(stringToDecode.Substring(stringToDecode.Length - 2, 2));
            stringToDecode = stringToDecode.Substring(0, stringToDecode.Length - 2);
            n = 0;
            for (i = 0; i < stringToDecode.Length; i += 5)
            {
                p = Convert.ToInt32(stringToDecode.Substring(i, 5));
                q = (p - 10000 - (NumRand * 2 * n) -
                     ((n ^ 2) + 2 * NumRand)) / (2 * NumLength);
                decodedString += CharacterArr.Substring(q + 1, 1);
                n += 1;
            }
            return decodedString;
        }

    }
}