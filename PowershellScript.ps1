# set user variables
$sourceDirectory = "D:\Users\Jesse\Videos\OBS\Coalition Stuff\Mapping\Livonia\TIFF Image Sequence 2"
$mapName = "Livonia"
$zoomLevels = 4



# operations
Write-Host "STARTING SCRIPT..."
Write-Host "STARTING SCRIPT..."
Write-Host "STARTING SCRIPT..."
Write-Host "STARTING SCRIPT..."

# get all files in source directory
$imageSequence = Get-ChildItem $sourceDirectory -Recurse

# init file counter
$counter = 0

# init first zoom level
$zoomsCount = 0

# start loop through zoom levels
for ($i = 0; $i -lt $zoomLevels; ($i++), $zoomsCount++)
{
    
    # create folder for current zoom level
    New-Item -Path ($sourceDirectory + "/" + $zoomsCount) -ItemType Directory
    Write-Host ("Zoom level:" + $zoomsCount)

    # create folder for each column in this zoom level (moving along x axis)
    $numColumns = [Math]::Pow(2, $zoomsCount)
    Write-Host ("Creating $numColumns columns")
    for ($currentColumn = 0; $currentColumn -lt $numColumns; $currentColumn++)
    {

        New-Item -Path ($sourceDirectory + "/" + $zoomsCount + "/" + $currentColumn) -ItemType Directory
        Write-Host ("Creating column $currentColumn in zoom level $zoomsCount")

        # copy images from image sequence into this column (each image is a row)
        $numRows = $numColumns
        $counterStop = $counter + $numRows
        for ($currentRow = 0; $counter -lt $counterStop; ($currentRow++, $counter++))
        {
            $tile = $imageSequence[$counter]
            Write-Host ("Copying file " + $tile + " to " + ($sourceDirectory + "/" + $zoomsCount + "/" + $currentColumn))
            Copy-Item ($sourceDirectory + "/" + $tile) -Destination ($sourceDirectory + "/" + $zoomsCount + "/" + $currentColumn)
            # rename to row
            Write-Host ("Renaming file " + $tile + " to " + ([string]$currentRow + ".tif"))
            Rename-Item -Path ($sourceDirectory + "/" + $zoomsCount + "/" + $currentColumn + "/" + $tile) -NewName ([string]$currentRow + ".tif")
        }
    }
}

# summarize output
Write-Host ("Copied a total of " + $counter + " files.")