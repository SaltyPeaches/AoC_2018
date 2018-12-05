$in = Get-Content $PSScriptRoot\Inputs\Day4.txt
$loop = 0

# Hash to store guard IDs and arrays for minutes asleep
$guards = @{}

$in | sort-object {
    [void]($_ -match '\[(.*)\] (.*)')
    Get-Date $matches[1]
} | foreach { 
    [void]($_ -match '\[(.*)\] (.*)')
    $date = get-date $matches[1]
    $action = $matches[2]
    $loop++
    $perc = [math]::Round(($loop/($in.count))*100)

    Write-Progress -Activity "Evaluating sleepy time" -Status "$perc% Complete" -PercentComplete $perc
    switch -regex ($action)
    {
        'Guard #(\d+)' { 
            $script:guard = $matches[1]
            if (-not $guards.ContainsKey($script:guard)){ 
                $guards[$script:guard] = @(0) * 60 
            }
        }
        'sleep' { 
            # Start sleep
            $script:sleep = $date 
        }
        'wakes' {
            # Wake up and increment each minute asleep
            $script:sleep.Minute..($date.Minute-1)| foreach {
                $guards[$script:guard][$_]++
            }
        }
    }
}

# Part 1: Most Sleepy, & Most Common Sleepy-Time
$mostSleepy = $guards.GetEnumerator() | 
    sort { 
        $_.Value | measure -sum | % sum 
    } | select -Last 1
$minute1 = $mostSleepy.Value.IndexOf(($mostSleepy.Value | sort)[-1])

# Part 2: Most Consistently Sleepy
$mostSame = $guards.GetEnumerator() | 
    sort { 
        ($_.Value | sort)[-1] 
    } | select -Last 1
$minute2 = $mostSame.Value.IndexOf(($mostSame.Value | sort)[-1])

write-host "Part 1: "($minute1*$mostSleepy.Name)
write-host "Part 2: "($minute2*$mostsame.Name)