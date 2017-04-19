## $srcFolder = "P:\Immagini\911"
## $srcFolder = "P:\Immagini\Cesenatico-meganevone"
## $srcFolder = "P:\Immagini\dmcfx150"
## $srcFolder = "P:\Immagini\foto_telefoni\(2004 - 2005) - Nokia 6630"
## $srcFolder = "P:\Immagini\foto_telefoni\(2005 - 2007) - Sony Ericsson k750"
## $srcFolder = "P:\Immagini\foto_telefoni\(2007 - 2008) - Nokia e65"
## $srcFolder = "P:\Immagini\foto_telefoni\(2008 - 2010) - iphone 3g"
## $srcFolder = "P:\Immagini\foto_telefoni\(2008 - 2010) - Nokia n82"
## $srcFolder = "P:\Immagini\foto_telefoni\(2010 - 2012) - htc desire"
## $srcFolder = "P:\Immagini\foto_telefoni\(2011 - 2013) - Samsung Galaxy Nexus"
## $srcFolder = "P:\Immagini\foto_telefoni\(2012 - 2015) - Nokia lumia 920"
## $srcFolder = "P:\Immagini\foto_telefoni\(2015 - 2017) - iphone6"
## $srcFolder = "P:\Immagini\luca"
## $srcFolder = "P:\Immagini\varie\capodanno_05"
## $srcFolder = "P:\Immagini\varie\comunione luca"
## $srcFolder = "P:\Immagini\varie\mercatino_europeo"
## $srcFolder = "P:\Immagini\varie\mugello"
## $srcFolder = "P:\Immagini\foto_telefoni\video\Nuova cartella"

$srcFolder = "P:\Immagini\varie\mat_albe"


$taregtFolder = "P:\anno"

$files = Get-ChildItem -Path $srcFolder -include *.* –Recurse 

foreach ($file in $files){
	try{
		$path = $file.FullName
		$shell = New-Object -COMObject Shell.Application
		$folder = Split-Path $path
		$file1 = Split-Path $path -Leaf
		$shellfolder = $shell.Namespace($folder)
		$shellfile = $shellfolder.ParseName($file1)
		
		#0..287 | Foreach-Object { '{0} = {1}' -f $_, $shellfolder.GetDetailsOf($null, $_) }
		#32 CameraMaker,#12 DateTaken,#30 CameraModel
		
		$dateTaken = $shellfolder.GetDetailsOf($shellfile, 12)
			
		if([string]::IsNullOrWhiteSpace($dateTaken)) {    
			$parseDate =[datetime]$file.CreationTime  
		} 	
		else{
			#http://stackoverflow.com/questions/25474023/file-date-metadata-not-displaying-properly
			$dateTaken = ($dateTaken -replace [char]8206) -replace [char]8207
			$parseDate =[datetime]::ParseExact($dateTaken,"g",$null)
		}
		
		$year = $parseDate.Year	
		$monthNr = "{0:MM}" -f $parseDate
		$month = "{0:MMMM}" -f $parseDate		
		
		$fileName = "{0:yyyyMMdd-hhmmss}" -f $parseDate
		$fileExtension = $file.Extension
		$fileGuid = [GUID]::NewGuid()	
		
		$directory = $taregtFolder + "\" + $year + "\" + "$monthNr - $month"
		if (!(Test-Path $Directory))
		{
			New-Item $directory -type directory | Out-Null
		}
		
		$newFileName = "$fileName-$fileGuid$fileExtension"
		$targetFile = "$directory\$newFileName"
		
		Copy-Item $file.FullName -Destination $targetFile
	}
	catch{
		Write-Host "Could not copy file $file"
	}
}