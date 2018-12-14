[int]$in = get-content $PSScriptRoot\Inputs\Day14.txt
[int]$Length = ([string]$in).Length
$One = $false
$Two = $false

# Because we're using a hashtable, we need to reverse the input to compare it to the last set of values for Part 2
$compare = [string]$in
$compare = $compare.ToCharArray()
[array]::Reverse($compare)
[int]$compare = $compare -join ''

# Index = Score
$start = @{
    0 = '3'
    1 = '7'
}

# Elf = Index
$elves = [PSCustomObject]@{
    1 = 0
    2 = 1
}

$iterations = 0
while(!$one -or !$two){
    # Calculate new recipe(s)
    $sum = [int]$start[$elves.1] + [int]$start[$elves.2]
    $recipes = if($sum -gt 9){
        [int[]](($sum -split '') -ne '')
    } else {
        $sum
    }

    # Add new recipes to scoreboard
    $newRecipes = $recipes.Count
    if($newRecipes -gt 1){
        for($n=0;$n-lt$newRecipes;$n++){
            $newIndex = $start.Count
            $start.Add($newIndex,[string]$recipes[$n])
        }
    } else {
        $newIndex = $start.Count
        $start.Add($newIndex,[string]$recipes)
    }

    # Move elves
    $e1Move = [int]$start[$elves.1]+1
    for($e1=0;$e1-lt$e1Move;$e1++){
        if($start[($elves.1+1)]){
            $elves.1++
        } else {
            $elves.1 = 0
        }
    }
    $e2Move = [int]$start[$elves.2]+1
    for($e2=0;$e2-lt$e2Move;$e2++){
        if($start[($elves.2+1)]){
            $elves.2++
        } else {
            $elves.2 = 0
        }
    }
    $iterations++

    # Check for Part 1
    if($iterations -eq ($in+10)){
        $one = $true
        [string]$Part1 = ($start[$in..($in+9)] -join '')
        write-host "Part 1: $Part1"
    }

    # Check for Part 2
    if(!$Two){
        if($start.Count -ge $Length){
            $endString = $start[($start.Count-$Length)..($start.Count-1)]
            [int]$String = $endString -join ''
            if($compare -eq $String){
                $Two = $true
                $Part2 = $start.Count-$Length
                write-host "Part 2: $Part2"
            }
        }
    }
}