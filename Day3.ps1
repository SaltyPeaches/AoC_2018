# Part 1
$in = Get-Content .\Inputs\Day3.txt
$grid = New-Object 'int[,]' 2000,2000

foreach($rect in $in){
    $rect = $rect -split ' '
    $ClaimID = $rect[0].Substring(1)
    
    # Get start position
    $rect[2] = $rect[2].Trim(':')
    [int]$x = ($rect[2].Split(','))[0]
    [int]$y = ($rect[2].Split(','))[1]

    # Get size
    [int]$width = ($rect[3].Split('x'))[0]
    [int]$height = ($rect[3].Split('x'))[1]

    # DRAW!
    for($i=$x;$i -lt ($x+$width);$i++){
        for($t=$y;$t -lt ($y+$height);$t++){
            $grid[$t,$i]++
        }
    }
}

$part1 = ($grid -ge 2 | measure).Count

# Part 2
foreach($rect in $in){
    $intact = $true
    $rect = $rect -split ' '
    $ClaimID = $rect[0].Substring(1)
    
    # Get start position
    $rect[2] = $rect[2].Trim(':')
    [int]$x = ($rect[2].Split(','))[0]
    [int]$y = ($rect[2].Split(','))[1]

    # Get size
    [int]$width = ($rect[3].Split('x'))[0]
    [int]$height = ($rect[3].Split('x'))[1]

    # Check Intact...ness?
    for($i=$x;$i -lt ($x+$width);$i++){
        for($t=$y;$t -lt ($y+$height);$t++){
            if($grid[$t,$i] -gt 1){
                $intact = $false
            }
        }
    }

    if($intact){
        $Part2 = $ClaimID
    }
}

write-host "Part 1: $Part1"
Write-Host "Part 2: $Part2"