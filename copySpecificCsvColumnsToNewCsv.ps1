#give the path of your CSV files without ending slash
$inputFileDir = Read-Host "`nEnter the folder path of your CSV files without ending slash"

#when asked to enter, enter the list of columns separated by comma
$enterColumns = Read-Host "`nEnter comma separated list of columns"

$columns = $enterColumns.split(",")

$outputFileDir = "$inputFileDir\copySpecificColumns_output"

#outPut folder creation
if (Test-Path $outputFileDir) {
	
    Write-Host "`n$outputFileDir already exists"
	
} else {
	
	Write-Host "`n$outputFileDir does not exist, creating"
	
    New-Item -ItemType Directory -Force -Path "$inputFileDir\copySpecificColumns_output"

}

#counter to count number of file(s)
$counter = 0

#message befroe starting to process file(s)
Write-Host "`nColumn(s) to copy:"($columns -join ",")"`n"

$startDate = Get-Date

Get-ChildItem $inputFileDir\*.csv |

Foreach-Object {

	Write-Host "processing: "$_.Name
	
	$processingStartDate = Get-Date
	
	$timestamp = Get-Date -UFormat "%Y%m%d%T" | ForEach-Object { $_ -replace ":", "" }
	$outputFile="$outputFileDir\"+($_.Name -replace $_.Extension,"")+"_"+($columns -join ",")+"_"+$timestamp+".csv"

	$columnsFromInputs=(Import-Csv $_.FullName | Select $columns)
	$columnsFromInputs | Export-Csv -Path $outputFile -Append -NoTypeInformation

	$counter++
	$processingEndDate = Get-Date
	$processingTime = $processingEndDate-$processingStartDate
	
	Write-Host "processed : "$_.Name
	Write-Host "duration  : "$processingTime"`n"

	}

$endDate = Get-Date
$completeDuration = $endDate-$startDate

Write-Host $counter" files processed in "$completeDuration"`n"
