# Part 1
$in = Get-Content .\Inputs\Day2.txt

$Part1 = ($in | ?{[bool]($_.ToCharArray() | Group | ?{$_.count -eq 2})} | Measure).Count * ($in | ?{[bool]($_.ToCharArray() | Group | ?{$_.count -eq 3})} | Measure).Count

# Part 2
$found = $false
$in | foreach{
    if(!$found){
        $checkline = $_
        foreach ($line in $in) {
            $differences = 0
            for ($i = 0; $i -lt $line.length; $i++){
                if ($checkline[$i] -ne $line[$i]){
                    $differences++
                }
            }

            if ($differences -eq 1) {
                $Part2 = -join (Compare $checkline.ToCharArray() $line.ToCharArray() -IncludeEqual | ?{$_.SideIndicator -eq '=='} | select -ExpandProperty InputObject)
                $found = $true
                break
            }
        }
    }
}

write-host "Part 1: $Part1"
write-host "Part 2: $Part2"