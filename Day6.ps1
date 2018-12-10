$in = Get-Content I:\Scripts\AoC_2018\Inputs\Day6.txt
write-progress -id 1 -activity "Calculating Day 6" -Status "0% Complete" -PercentComplete 0
function Measure-Manhattan{
    param(
        [array]$p
    )

    $coldistances = [System.Collections.ArrayList]::new()
    $st = 0
    for($i=0;$i -lt $in.Count;$i++){
        $st = ($i/$in.Count)*100
        write-progress -id 6 -activity "Calculating for point ($($p[0]),$($p[1]))" -status "$st% Complete" -percentComplete $st -parentID 4
        $t = ($in[$i]).Split(', ')
        [int]$d = ([math]::Abs($t[0]-$p[0]))+([math]::Abs($t[2]-$p[1]))
        $colDistances += [PSCustomObject]@{
            Point = "P$i"
            Distance = $d
        }
    }
    $coldistances = $coldistances | sort Distance
    write-progress -id 6 -activity "Calculating for point ($($p[0]),$($p[1]))" -status "$st% Complete" -Completed -parentID 4
    if($coldistances[0].Distance -eq $coldistances[1].Distance){
        return '.'
    }else{
        return $colDistances[0].Point
    }
}

$topx = 0
$topy = 0

write-progress -id 1 -activity "Calculating Day 6" -Status "20% Complete" -PercentComplete 20
$perc = 0
for($i=0;$i -lt $in.Count;$i++){
    $perc = ($i/$in.count)*100
    write-progress -id 2 -activity "Grabbing max grid values" -Status "$perc% Complete" -PercentComplete $perc -ParentId 1
    $t = ($in[$i]).Split(', ')
    
    $topx = if($t[0] -gt $topx){$t[0]}else{$topx}
    $topy = if($t[2] -gt $topy){$t[2]}else{$topy}
}
write-progress -id 2 -activity "Grabbing max grid values" -Status "100% Complete" -PercentComplete 100 -ParentId 1
$max = 371
$grid = New-Object 'string[,]' $max,$max

write-progress -id 1 -activity "Calculating Day 6" -Status "40% Complete" -PercentComplete 40
$perc = 0
for($i=0;$i -lt $in.Count;$i++){
    $perc = ($i/$in.count)*100
    Write-Progress -ID 3 -Activity "Drawing points to grid" -status "$perc% Complete" -PercentComplete $perc -ParentId 1
    $t = ($in[$i]).Split(', ')
    $grid[$t[0],$t[2]] = "P$i"
}
Write-Progress -ID 3 -Activity "Drawing points to grid" -status "100% Complete" -PercentComplete 100 -ParentId 1

# Draw closest points
$perc = 0
write-progress -id 1 -activity "Calculating Day 6" -Status "60% Complete" -PercentComplete 60
for($x=0;$x -lt $max;$x++){
    for($y=0;$y -lt $max;$y++){
        $perc = ($x/$max)*100
        Write-Progress -ID 4 -Activity "Calculating nearest points" -status "$perc% Complete" -PercentComplete $perc -ParentId 1
        if($null -eq $grid[$x,$y]){
            $grid[$x,$y] = Measure-Manhattan @($x,$y)
        }
    }
}
Write-Progress -ID 4 -Activity "Calculating nearest points" -status "100% Complete" -PercentComplete 100 -ParentId 1

# Group and select for Part 1
write-progress -id 1 -activity "Calculating Day 6" -Status "80% Complete" -PercentComplete 80
$pointswithborder = @()
$perc = 0
for($x=0;$x -lt $max;$x++){
    for($y=0;$y -lt $max;$y++){
        $perc = ($x/$max)*100
        Write-Progress -ID 5 -Activity "Looking for points with infinite area" -status "$perc% Complete" -PercentComplete $perc -ParentId 1
        if($x -eq 0 -or $x -eq $max -or $y -eq 0 -or $y -eq $max){
            $pointswithborder+=$grid[$x,$y]
        }
    }
}    
$grid | group | ?{$_.Name -notin $pointswithborder} | sort Count -desc
#return $grid