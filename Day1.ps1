# Part 1
$inp = Get-Content .\Day1_input.txt
[int]$frequency = 0

foreach($line in $inp){
    $frequency+=[int]$line
}

# Part 2
[int]$freq2 = 0
$hash = @{}
$dupfound = $false

while(!$dupfound){
    for($i = 0;$i -lt $inp.length;$i++){
        $freq2+=$inp[$i]
        if($hash[$freq2]){
            $dupfound = $true
            break
        } else {
            $hash[$freq2]++
        }
    }
}

write-host "Part 1: $frequency"
write-host "Part 2: $freq2"