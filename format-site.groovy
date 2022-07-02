import java.nio.file.Files
import java.nio.file.Paths
import java.nio.file.Path
import java.io.File
import java.nio.file.StandardCopyOption
import java.nio.charset.Charset
import java.nio.charset.StandardCharsets;

File serviceMemFile = new File('files\\serviceMem.txt')
File freeTextFile = new File('files\\freeText.txt')
File totalMemoryFile = new File('files\\totalMemory.txt')
File memListFile = new File('files\\memList.txt')
File cpuLoadFile = new File('files\\cpuLoad.txt')

//Extract Service Mem File
String serviceName = ""
String serviceMemText = ""
def line
serviceMemFile.withReader { reader ->
  line = reader.readLine()
  serviceName = line.toString()

  line = reader.readLine()
  serviceMemText = line.toString()
}
double serviceMem
try {
  serviceMem = Double.parseDouble(serviceMemText);
} catch (NumberFormatException e) {}

// Extract Free Text
String freeText = ""
freeTextFile.withReader { reader ->
  line = reader.readLine()
  freeText = line.toString()
}
double freeMem
try {
  freeMem = Double.parseDouble(freeText);
} catch (NumberFormatException e) {}

// Extract Total
String totalText = ""
totalMemoryFile.withReader { reader ->
  line = reader.readLine()
  totalText = line.toString()
}
double totalMem
try {
  totalMem = Double.parseDouble(totalText);
} catch (NumberFormatException e) {}

// Extract Memory List
String memList = ""
memListFile.withReader { reader ->
  line = reader.readLine()
  memList = line.toString() //1st

  line = reader.readLine()
  memList = memList + line.toString() //2nd

  line = reader.readLine()
  memList = memList + line.toString() //3rd

  line = reader.readLine()
  memList = memList + line.toString() //4th
  
  line = reader.readLine()
  memList = memList + line.toString() //5th
}
memList = memList.replaceAll('\\@\\{Name=', '')
memList = memList.replaceAll(';', '')
memList = memList.replaceAll('WS=', '')
memList = memList.replaceAll('}', ' bytes<br />')

// Extract CPU Load
String cpuLoadText = ""
cpuLoadFile.withReader { reader ->
  line = reader.readLine()
  cpuLoadText = line.toString()
}
cpuLoadText = cpuLoadText.replace('@{LoadPercentage=','')
cpuLoadText = cpuLoadText.replace('}','')
double cpuLoad
try {
  cpuLoad = Double.parseDouble(cpuLoadText);
} catch (NumberFormatException e) {}

// Modify Template

Path sourcePath = Paths.get(".\\template\\index-template.html")
Path targetPath = Paths.get(".\\index.html")
Charset charset = StandardCharsets.UTF_8;
//Make sure file exists
Files.copy(sourcePath, targetPath, StandardCopyOption.REPLACE_EXISTING)

String content = new String(Files.readAllBytes(sourcePath), charset);
def remainingMem = ((totalMem-freeMem)/totalMem)*100
content = content.replaceAll( "~remainingMem",  String.valueOf(remainingMem))
def memColor
if (remainingMem < 50) {
  memColor = "darkseagreen"
}
else if (remainingMem < 75) {
  memColor = "gold"
}
else {
  memColor = "firebrick"
}
content = content.replaceAll( "~memColor",  memColor)

content = content.replaceAll( "~serviceName",  serviceName)
content = content.replaceAll( "~serviceMem",  String.valueOf(serviceMem))
content = content.replaceAll( "~freeText",  freeText)
def cpuColor
if (cpuLoad < 50) {
  cpuColor = "darkseagreen"
}
else if (remainingMem < 75) {
  cpuColor = "gold"
}
else {
  cpuColor = "firebrick"
}
content = content.replaceAll( "~cpuUsage",  String.valueOf(cpuLoad))
content = content.replaceAll( "~cpuColor",  cpuColor)

content = content.replaceAll( "~serviceList",  memList)

File index = new File(".\\index.html")
index.bytes = []
index.write(content)