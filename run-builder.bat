if not exist CodeToBuild mkdir CodeToBuild
@docker run -it --rm microsoft/windowsservercore

@REM -v syntax is host:container
docker run -it -v D:\GitClean\Personal\DockerDemo\Build\DockerBuilderDotNetWindows\docker-msbuild\CodeToBuild:C:\CodeToBuild biles/msbuild:latest
@pause