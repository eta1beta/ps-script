﻿$srcFolder = "P:\Immagini\foto_telefoni"

$taregtFolder = "P:\ANNO"

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
		
        # Write-host $shellfile.ModifyDate
        # pause
        	
		if([string]::IsNullOrWhiteSpace($dateTaken)) {    
			# $parseDate =[datetime]$file.CreationTime  
            $parseDate =[datetime]$shellfile.ModifyDate  
		} 	
		else{
			#http://stackoverflow.com/questions/25474023/file-date-metadata-not-displaying-properly
			$dateTaken = ($dateTaken -replace [char]8206) -replace [char]8207
			$parseDate =[datetime]::ParseExact($dateTaken,"g",$null)
		}
		
        #write-host $parseDate
        #pause


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
		
		# Copy-Item $file.FullName -Destination $targetFile
        Move-Item $file.FullName -Destination $targetFile
        # Write-Host $file.FullName $targetFile


	}
	catch{
		Write-Host "Could not copy file $file"
	}
}