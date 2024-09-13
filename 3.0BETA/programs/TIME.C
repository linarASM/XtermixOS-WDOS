using System;
 
namespace wdt
{
    class Program
    {
        static void Main(string[] args)
        {
            var n = 365;
            var ts = TimeSpan.FromMinutes(n);
            Console.WriteLine(ts.ToString(@"hh\:mm"));
            Console.ReadKey();
        }
    }
}

