$in = Get-Content $PSScriptRoot\Inputs\Day5.txt
$alphabetsoup = [string[]][char[]](97..122)

function ReactPolymer{
    param(
        $polymer
    )

    $length = ''

    while($polymer.length -ne $length){
        $length = $polymer.length
        foreach($n in $alphabetsoup){
            $polymer = $polymer -creplace ($n.toLower()+$n.toUpper()),''
            $polymer = $polymer -creplace ($n.toUpper()+$n.toLower()),''
        }
    }

    return $polymer.Length
}

# Part 1
$part1 = ReactPolymer $in

# Part 2
$total = $alphabetsoup.Length
$loop = 0
$lengths = foreach($noodle in $alphabetsoup){
    $loop++
    Write-Progress -Activity "Evaluating possible polymers" -Status "$loop of $total" -PercentComplete (($loop/$total)*100)
    [PSCustomObject]@{
        Letter = $noodle
        Length = (ReactPolymer ($in -replace $noodle))
    } 
}

$part2 = $lengths | sort Length -desc | select -expandproperty Length -last 1

write-host "Part 1: $part1"
write-host "Part 2: $part2"