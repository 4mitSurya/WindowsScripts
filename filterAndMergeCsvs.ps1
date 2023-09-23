#give the path of your CSV files without ending slash
$inputFileDir = Read-Host "`nEnter the folder path of your CSV files without ending slash"

#when asked to enter, enter the list of columns separated by comma
$enterColumns = Read-Host "`nEnter comma separated list of columns"

$columns = $enterColumns.split(",")

#when asked to enter, enter the list of columns separated by comma
$enterValues = Read-Host "`nEnter comma separated list of values for above columns"

$values = $enterValues.split(",")

$outputFileDir = "$inputFileDir\filterAndMerge_output"

#outPut folder creation
if (Test-Path $outputFileDir) {
	
    Write-Host "`nDirectory $outputFileDir already exists"
	
} else {
	
	Write-Host "`nDirectory $outputFileDir does not exist, creating"
	
    New-Item -ItemType Directory -Force -Path "$inputFileDir\filterAndMerge_output"

}

#the CSV file in which the filtered values will be merged
$timestamp = Get-Date -UFormat "%Y%m%d%T" | ForEach-Object { $_ -replace ":", "" }
$outputFile = "$outputFileDir\filteredAndMerged_"+($columns -join ",")+"_"+$timestamp+".csv"

#counter to count number of file(s)
$counter = 0

#message befroe starting to process file(s)
Write-Host "`nColumn(s) to filter from: "($columns -join ",")
Write-Host "value(s) to apply filter to columns: "($values -join ",")"`n"

$startDate = Get-Date


	
For ($i=0; $i -lt $columns.length; $i++) {
	
	if ($i -eq 0) {

		Write-Host "FILTERING WITH"$columns[$i]"="$values[$i]
		
		$processingStartDate = Get-Date
		
		Get-ChildItem $inputFileDir\*.csv |

		Foreach-Object {
			
			$filteredFromInputs = (Import-Csv -Path $_.FullName | ? $columns[$i] -eq $values[$i])
			$filteredFromInputs | Export-Csv -Path $outputFile -Append -NoTypeInformation

			$counter++
				
		}
		
		$processingEndDate = Get-Date
		$processingTime = $processingEndDate-$processingStartDate
		Write-Host "DONE - duration: "$processingTime"`n"
	
	}
	else {

		Write-Host "FILTERING WITH"$columns[$i]"="$values[$i]
		
		$processingStartDate = Get-Date
		
		$filteredFromInputs = (Import-Csv -Path $outputFile | ? $columns[$i] -eq $values[$i])
		$filteredFromInputs | Export-Csv -Path $outputFile -NoTypeInformation
		
		$processingEndDate = Get-Date
		$processingTime = $processingEndDate-$processingStartDate
		Write-Host "DONE - duration: "$processingTime"`n"
		
	}
	
}

$endDate = Get-Date
$completeDuration = $endDate-$startDate

Write-Host $counter" files processed in "$completeDuration"`n"
