# Windows 10/11 Hardware Reporting Site

This site was originally intended to report VMmem and System Memory and CPU utilization to a simple HTML page. The website can be viewed by opening index.html in your desired browser or it  can be hosted with any generic server such as `python3 -m http.server`.

Requirements:
* PowerShell
* Groovy
* HTTP Server

How to launch:
1. Navigate to the directory that this repo is cloned to.
2. Run `.\get-hardware-resources.ps1`
3. (Optional) Run your desired HTTP Server
4. Navigate to the deployed website 

The PowerShell script will read and write resource utilization every 5 seconds.
The HTML page is set to auto-refresh every 5 seconds.