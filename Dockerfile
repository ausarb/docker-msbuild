# escape=`
FROM microsoft/windowsservercore

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN New-Item C:\Nuget -type directory; `
	Invoke-WebRequest https://dist.nuget.org/win-x86-commandline/v4.3.0/nuget.exe -OutFile C:\Nuget\nuget.exe -UseBasicParsing; `
	`
	Invoke-WebRequest https://aka.ms/vs/15/release/vs_buildtools.exe -OutFile vs_buildtools.exe -UseBasicParsing; `
	Start-Process vs_buildtools.exe -ArgumentList '--add Microsoft.VisualStudio.Workload.MSBuildTools --add Microsoft.VisualStudio.Workload.NetCoreBuildTools --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.WebBuildTools --quiet --wait' -Wait; `
	Remove-Item -Force vs_buildtools.exe; `
	`
	[Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\Nuget;C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin', [EnvironmentVariableTarget]::Machine);
	
#Now we found out that we need .NETFramework 4.5 also
RUN Invoke-WebRequest https://download.microsoft.com/download/4/3/B/43B61315-B2CE-4F5B-9E32-34CCA07B2F0E/NDP452-KB2901951-x86-x64-DevPack.exe -OutFile framework452.exe -UseBasicParsing; `
	Start-Process framework452.exe -ArgumentList '/q' -Wait; `
	Remove-Item -Force framework452.exe
	
#Certs - These certs will be installed in a later process, not part of a public Git repo.
#COPY .\Certs C:\CertsSource
#RUN "C:\CertsSource\InstallAllCerts.ps1"	