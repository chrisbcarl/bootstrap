The current workspace is using an obsolete version of .NET SDK '2.1.4', which is not supported. The C# Dev Kit extension may not work correctly. Please update the computer and potentially global.json file to use a more recent version of .NET SDK.



C:\Users\chris>dotnet --version
2.1.4

C:\Users\chris>where.exe dotnet
C:\Program Files\dotnet\dotnet.exe

C:\Users\chris>dotnet --list-sdks
2.1.2 [C:\Program Files\dotnet\sdk]
2.1.4 [C:\Program Files\dotnet\sdk]

C:\Users\chris>dotnet --list-runtimes
Microsoft.NETCore.App 2.0.3 [C:\Program Files\dotnet\shared\Microsoft.NETCore.App]
Microsoft.NETCore.App 2.0.5 [C:\Program Files\dotnet\shared\Microsoft.NETCore.App]
Microsoft.NETCore.App 8.0.8 [C:\Program Files\dotnet\shared\Microsoft.NETCore.App]
Microsoft.WindowsDesktop.App 8.0.8 [C:\Program Files\dotnet\shared\Microsoft.WindowsDesktop.App]

C:\Users\chris>

https://learn.microsoft.com/en-us/dotnet/core/install/how-to-detect-installed-versions?pivots=os-windows
https://learn.microsoft.com/en-us/dotnet/core/additional-tools/uninstall-tool-overview?pivots=os-windows
https://github.com/dotnet/cli-lab/releases


C:\Users\chris>dotnet-core-uninstall list

This tool cannot uninstall versions of the runtime or SDK that are 
    - SDKs installed using Visual Studio 2019 Update 3 or later.
    - SDKs and runtimes installed via zip/scripts.
    - Runtimes installed with SDKs (these should be removed by removing that SDK).
The versions that can be uninstalled with this tool are:

.NET Core SDKs:
  2.1.4  x64    [Used by Visual Studio. Specify individually or use --force to remove]
  2.1.2  x64

.NET Core Runtimes:

ASP.NET Core Runtimes:

.NET Core Runtime & Hosting Bundles:

C:\Users\chris>


https://learn.microsoft.com/en-us/dotnet/core/additional-tools/uninstall-tool-cli-remove?pivots=os-windows#examples


dotnet-core-uninstall remove 2.1.4 --sdk --yes --force


C:\WINDOWS\system32>dotnet-core-uninstall remove 2.1.2 --sdk --yes --force
Uninstalling: Microsoft .NET Core SDK - 2.1.2 (x64).

C:\WINDOWS\system32>echo %ERRORLEVEL%
0

C:\WINDOWS\system32>dotnet-core-uninstall list










C:\WINDOWS\system32>dotnet-core-uninstall remove 2.1.2 --sdk --yes --force
Uninstalling: Microsoft .NET Core SDK - 2.1.2 (x64).

C:\WINDOWS\system32>echo %ERRORLEVEL%
0

C:\WINDOWS\system32>dotnet-core-uninstall list