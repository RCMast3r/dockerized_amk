# Use the Windows Server Core image as the base
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Metadata indicating an image maintainer
LABEL maintainer="you@example.com"

# Set up environment variables for the installation processes and for running the server
ENV chocolateyUseWindowsCompression=false

# Install Chocolatey
RUN powershell -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));

# Use Chocolatey to install TightVNC
RUN powershell -Command choco install tightvnc -y

# Download and unzip Aipex Pro software
RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Uri "https://www.amk-motion.com/media/daten/downloads/software/AIPEX/AipexPro_304_SP03_2216_207986.zip" -OutFile "C:\AipexPro.zip"; \
    Expand-Archive -LiteralPath "C:\AipexPro.zip" -DestinationPath "C:\AipexPro"; \
    Remove-Item "C:\AipexPro.zip" -Force

# Assuming the ZIP contains an installer or executable at a known path, and it can be installed silently
# Replace 'YourInstaller.exe' and its parameters with the actual installer and required silent install parameters for Aipex Pro
# RUN "C:\AipexPro\YourInstaller.exe" /S /someOtherOption

# Set up TightVNC server - adjust according to your needs and security requirements
RUN powershell -Command "& 'C:\Program Files\TightVNC\tvnserver.exe' -install"
RUN powershell -Command "& 'C:\Program Files\TightVNC\tvnserver.exe' -start"

# Expose the default VNC port
EXPOSE 5900

# Set the default command to run the VNC server
CMD ["C:\\Program Files\\TightVNC\\tvnserver.exe", "-run"]
