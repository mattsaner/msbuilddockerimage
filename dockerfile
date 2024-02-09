# Use a specific version of the Windows Server Core image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Download the Visual Studio Build Tools bootstrapper.
ADD https://aka.ms/vs/17/release/vs_buildtools.exe C:/TEMP/vs_buildtools.exe

# Install MSBuild and the C++ build tools
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache --installPath C:\BuildTools \
    --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 \
    --remove Microsoft.VisualStudio.Component.Windows81SDK \
 || IF "%ERRORLEVEL%"=="3010" EXIT 0

# Cleanup
RUN del C:\TEMP\vs_buildtools.exe

# Set environment variable for MSBuild
ENV MSBUILD_PATH="C:\BuildTools\MSBuild\Current\Bin"
ENV PATH="${PATH};${MSBUILD_PATH}"
