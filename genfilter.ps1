$DOMAIN_LIST = if ($env:DOMAIN_LIST) { $env:DOMAIN_LIST } else { ".\list.txt" };
$OUTPUT_FILE = if ($env:OUTPUT_FILE) { $env:OUTPUT_FILE } else { ".\mailFilters.xml" };

$xml = @"
<?xml version='1.0' encoding='UTF-8'?><feed xmlns='http://www.w3.org/2005/Atom' xmlns:apps='http://schemas.google.com/apps/2006'>

"@

foreach($line in Get-Content $DOMAIN_LIST) {
    $xml += @"
    <entry>
        <category term='filter'></category>
        <title>Mail Filter</title>
        <apps:property name='from' value='$line'/>
        <apps:property name='shouldTrash' value='true'/>
        <apps:property name='sizeOperator' value='s_sl'/>
        <apps:property name='sizeUnit' value='s_smb'/>
    </entry>

"@
}

$xml += @"
</feed>
"@

$xml | Tee-Object -FilePath $OUTPUT_FILE

# Generate a comma separated value file for use for importing into Zoho and other
# mail systems that do not use the gmail style XML format
function Generate-CSV-file {
	$csv = ""
	$CSV_FILE = ".\mailFilters.csv"
	
	foreach($line in Get-Content $DOMAIN_LIST) {
		$csv += $line + ","
	}
	
	# Remove the last comma
	$csv = $csv.SubString(0, $csv.Length - 1)
	
	# Output the CSV File
	$csv | Tee-Object -FilePath $CSV_FILE
}

Generate-CSV-file
