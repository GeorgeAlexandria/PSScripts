It is a set of helpful powershell scripts. Each script has summary what it does and parameters description:

* **ChangeFormat.ps1** – changes files format in the folder 
<br/>*Params*:
    * ***sourcePath*** – input folder
    * ***format*** – output format
    * ***[destinationPath]*** – ouput path, if is not passed will be used the ***sourcePath***
    * ***[includeSourceFormats]*** – Filter of files by their format whose determines files that should be taken
    * ***[excludeSourceFormats]*** – Filter of files by their format whose determines files that should be skipped

* **CopyFolderContent.ps1** – copies the folder child items to destination with overwriting
<br/>*Params*:
    * ***source*** – input folder
    * ***destination*** – ouput folder

* **CopyShareByCredential.ps1** – copies tha share resource by user credential
<br/>*Params*:
    * ***share*** – share resource path
    * ***destination*** – ouput folder
    * ***userName*** – user name
    * ***password*** – password

* **CopyVMDirectory.ps1** – copies folder to the Hyper-V virtual machine
<br/>*Params*:
    * ***vmName*** – virtual machine name
    * ***source*** – input folder
    * ***destination*** – output folder

* **CreateProcess.ps1** – create process by input executable file
<br/>*Params*:
    * ***[serverName]*** – remote machine name, if is not passed will be used the local machine
    * ***executionPath*** – path to executable file
    * ***[commandLine]*** – launch parameters of executable file
    * ***[currentDirectory]*** – current directory that will use by executable file, if is not passed will be used executable file's directory

* **DropDatabase.ps1** – drop databse in MS sql server
<br/>*Params*:
    * ***databaseName*** – database name to drop
    * ***[sqlServerName]*** – sql server name, if is not passed will be used *localdb*

* **ExecuteSqlQuery.ps1** – execute sql query on database
<br/>*Params*:
    * ***databaseName*** – database name
    * ***[sqlServerName]*** – sql server name, if is not passed will be used *localdb*
    * ***sqlQuery*** – input sql query, cannot be used together with ***sqlFilePath***
    * ***sqlFilePath*** – file path whose contains sql query, cannot be used together with ***sqlQuery***

* **InstallWinService.ps1** – install windows service from executable file
<br/>*Params*:
    * ***[serverName]*** – remote machine name, if is not passed will be used the local machine
    * ***serviceName*** – input service name
    * ***servicePath*** – path to executable file
    * ***[serviceType]*** – input service type, if is not passed will be used `0x10`
    * ***[startMode]*** – input service start mode, if is not passed will be used `Automatic`
    * ***[displayName]*** – input service display name, if is not passed will be used ***serviceName***
    * ***[description]*** – input service description
    * ***[userName]*** – input account name under which the service will be run, must be used together with ***password***
    * ***[password]*** – input account password under which the service will be run, must be used together with ***userName*** 
    * ***[errorControl]*** – input severity for the `Win32_Service.Create`, if is not passed will be used `1` 
    * ***[loadOrderGroup]*** – input group name associated with the new service, if is not passed will be used empty value 
    * ***[loadOrderGroupDependcies]*** – set of load-ordering groups that must be started at first, if is not passed will be used empty set
    * ***[dependencies]*** – set of services that must be started beforeat first, if is not passed will be used empty set
    * ***[interactDesktop]*** – determine that service can interact with windows desktop

* **UninstallWinService.ps1** – uninstal windows service
<br/>*Params*:
    * ***[serverName]*** – remote machine name, if is not passed will be used the local machine
    * ***serviceName*** – input service name

* **XdtTransform.ps1** – aplies xdt transformation to xml file 
<br/>*Params*:
    * ***xmlFile*** – input xml file
    * ***xdtFile*** – input xdt transformation file
    * ***[XmlTransformDllPath]*** – path to xdt library, if is not passed library will be try to find it

* **XsltTransform.ps1** – aplies xslt transformation to fil
<br/>*Params*:
    * ***xsltFile*** – input xslt transformation file
    * ***inputFile*** – input file to transform
    * ***[outputFile]*** – path to ouput file, cannotbe used togeter with ***outputFormat***
    * ***[outputFormat]*** – output format of transformed file