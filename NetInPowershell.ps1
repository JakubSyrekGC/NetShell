$code = @"
using System;
using System.Threading;
using System.Threading.Tasks;
namespace NETShell
{    
    public class Runner
        {
            public static async Task<int> ReturnNumberAsync()
            {
                int result = await Task.Run(async () =>
                {
                    await Task.Delay(1000);
                    return 42;
                });
                return result;
            }
        
            public static async Task<int> RunJobsAsync()
            {
                var t = await ReturnNumberAsync();
                return t;
            }
         }
	public class NetTasks
	{
		public static void Main()  
        {
            Runner.RunJobsAsync().Wait();
        }
	}
}
"@
 
Add-Type -TypeDefinition $code -Language CSharp	
function Await-Task {
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        $task
    )

    process {
        while (-not $task.AsyncWaitHandle.WaitOne(200)) { }
        $task.GetAwaiter().GetResult()
    }
}

$r = [NETShell.Runner]::RunJobsAsync() | Await-Task
$r 

#iex "[NETShell.NetTasks]::Main()"