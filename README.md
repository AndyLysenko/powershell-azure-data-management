# powershell-azure-data-management
Powershell tools to manage data stored in Azure Storage Accounts

# Examples of usage from command prompt
```
Get-CommonTestData -storageAccountName "<accountName>" -storageAccountKey "<accountKey>" -destinationFolder "C:\Temp"
Get-CommonTestDataArchive -storageAccountName "<accountName>" -storageAccountKey "<accountKey>" -destinationFolde "C:\Temp" -azureFilePath "CommonTestData.zip"
```
  
# Examples of usage in C#
```
protected void GetCommonTestData(string archiveName = "CommonTestData.zip", bool keepArchive = true)
{
	string scriptDirectory = Environment.CurrentDirectory;
	if (File.Exists(Path.Combine(scriptDirectory, archiveName)))
		return;

	var scriptPath = Path.Combine(scriptDirectory, "TestDataPsHepler.ps1");
	var script = File.ReadAllText(scriptPath);

	PowerShell powershell = PowerShell.Create()
		.AddScript($@"Import-Module {scriptDirectory}\CommonHelpers.ps1 -Verbose -ErrorAction Continue")
		.AddScript($@"Import-Module {scriptDirectory}\AzureDataHelper.ps1 -Verbose -ErrorAction Continue")
		   .AddScript(@script, false);
	powershell.Invoke();

	powershell.Commands.Clear();
	powershell.AddCommand("Get-CommonTestDataArchive")
		.AddParameter("storageAccountName", "<accountName>")
		.AddParameter("storageAccountKey",
			"<accountKey>")
		.AddParameter("azureFilePath", archiveName)
		.AddParameter("destinationFolder", scriptDirectory)
		.AddParameter("keepArchive", keepArchive);
	powershell.Invoke();
}
```
  
