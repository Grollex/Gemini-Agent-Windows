using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Linq;

namespace GeminiLauncher
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Title = "Gemini CLI Autonomous Agent";
            
            string baseDir = AppDomain.CurrentDomain.BaseDirectory;
            string scriptName = "GeminiAgent.ps1";
            string scriptPath = Path.Combine(baseDir, scriptName);

            // If script doesn't exist, try to extract it from resources
            if (!File.Exists(scriptPath))
            {
                if (!ExtractResource(scriptName, scriptPath))
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine("CRITICAL ERROR: GeminiAgent.ps1 not found and could not be extracted!");
                    Console.ResetColor();
                    Console.ReadLine();
                    return;
                }
            }

            ProcessStartInfo psi = new ProcessStartInfo();
            psi.FileName = "powershell.exe";
            // ExecutionPolicy Bypass allows running the script without signing
            psi.Arguments = string.Format("-NoProfile -ExecutionPolicy Bypass -File \"{0}\"", scriptPath);
            psi.UseShellExecute = false;
            
            try
            {
                Process p = Process.Start(psi);
                p.WaitForExit();
            }
            catch (Exception ex)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("Failed to launch Gemini Agent: " + ex.Message);
                Console.ResetColor();
                Console.ReadLine();
            }
        }

        static bool ExtractResource(string resourceName, string outputPath)
        {
            try
            {
                var assembly = Assembly.GetExecutingAssembly();
                // Resource names are usually Namespace.Filename or just Filename
                string resourcePath = assembly.GetManifestResourceNames()
                    .FirstOrDefault(r => r.EndsWith(resourceName));

                if (string.IsNullOrEmpty(resourcePath)) return false;

                using (Stream stream = assembly.GetManifestResourceStream(resourcePath))
                using (FileStream fileStream = new FileStream(outputPath, FileMode.Create))
                {
                    stream.CopyTo(fileStream);
                }
                return true;
            }
            catch
            {
                return false;
            }
        }
    }
}
