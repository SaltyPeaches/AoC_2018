$in = Get-Content $PSScriptRoot\Inputs\Day13.txt
$height = $in.Count
$width = 0
$carts = @()
$cartCount = 0
[string]$Part1 = $null
$turns = @{
    '0' = '^'
    '1' = 'v'
    '2' = '>'
}

$in | foreach{if($_.Length -gt $width){$width = $_.Length}}

$grid = New-Object 'string[,]' $height,$width
for($x=0;$x-lt$height;$x++){
    $xline = $in[$x].ToCharArray()
    for($y=0;$y-lt$width;$y++){
        if($xline[$y] -in @('<','>','v','^')){
            $carts+=[pscustomobject]@{
                Cart = $cartCount
                Direction = $xline[$y]
                xPos = $x
                yPos = $y
                nextTurn = 'Left'
                Track = $null
                InService = $true
            }
            $cartCount++
        }
        $grid[$x,$y] = $xline[$y]
    }
}

foreach($cart in $carts){
    $checkTrack = $grid[($cart.xPos+1),$cart.yPos]+$grid[($cart.xPos-1),$cart.yPos]+$grid[$cart.xPos,($cart.yPos+1)]+$grid[$cart.xPos,($cart.yPos-1)]
    $track = switch($cart.Direction){
        '>'{'-'}
        '<'{'-'}
        '^'{'|'}
        'v'{'|'}
    }
    $cart.Track=$track
}
# write-host "Starting position..."
# for($r=0;$r-lt$height;$r++){
#     [string]$write = ''
#     for($l=0;$l-lt$width;$l++){
#         $write += $grid[$r,$l]
#     }
#     $write
# }
# $carts

$ticks = 0
while(($carts | ?{$_.InService}).Count -gt 1){
    foreach($cart in ($carts | ?{$_.InService} | sort xPos | sort yPos)){
        # Need an If block in here, in case a cart collides with a cart which has not processed through the tick yet
        if($cart.InService){
        $newY = switch($cart.Direction){
            '<'{$cart.yPos-1}
            '>'{$cart.yPos+1}
            DEFAULT{$cart.yPos}
        }
        $newX = switch($cart.Direction){
            '^'{$cart.xPos-1}
            'v'{$cart.xPos+1}
            DEFAULT{$cart.xPos}
        }
        $newTurn = switch($grid[$newX,$newY]){
            '+'{switch($cart.nextTurn){
                    'Left'{'Straight'}
                    'Straight'{'Right'}
                    'Right'{'Left'}
                }
            }
            DEFAULT{$cart.nextTurn}
        }
        $newDirection = switch($grid[$newX,$newY]){
            '-'{$cart.Direction}
            '\'{
                switch($cart.Direction){
                    '>'{'v'}
                    'v'{'>'}
                    '<'{'^'}
                    '^'{'<'}
                }
            }
            '/'{
                switch($cart.Direction){
                    '>'{'^'}
                    'v'{'<'}
                    '<'{'v'}
                    '^'{'>'}
                }
            }
            '|'{$cart.Direction}
            '+'{
                switch($cart.nextTurn){
                    'Left'{
                        switch($cart.Direction){
                            '>'{'^'}
                            '<'{'v'}
                            '^'{'<'}
                            'v'{'>'}
                        }
                    }
                    'Straight'{
                        $cart.Direction
                    }
                    'Right'{
                        switch($cart.Direction){
                            '>'{'v'}
                            '<'{'^'}
                            '^'{'>'}
                            'v'{'<'}
                        }
                    }
                }
            }
        }

        # Check for Collision
        if($carts | ?{$_.xPos -eq $newX -and $_.yPos -eq $newY -and $_.InService}){
            if(!$Part1){$Part1 = '('+[string]$newY+','+[string]($newX-1)+')'}
            $oldX = $cart.xPos
            $oldY = $cart.yPos
            $oldTrack = $cart.Track
            $carts | ?{$_.xPos -eq $newX -and $_.yPos -eq $newY -and $_.InService} | foreach{$_.InService = $false;$newTrack=$_.Track}

            # Adjust cart object values
            $cart.xPos = $newX
            $cart.yPos = $newY
            $cart.Direction = $newDirection
            $cart.nextTurn = $newTurn
            $cart.Track = $grid[$newX,$newY]
            $cart.InService = $false

            # Reset new position on grid
            $grid[$cart.xPos,$cart.yPos] = $newTrack
            
            # Reset old position on grid
            $grid[$oldX,$oldY] = $oldTrack
        } else {
            $oldX = $cart.xPos
            $oldY = $cart.yPos
            $oldTrack = $cart.Track

            # Adjust cart object values
            $cart.xPos = $newX
            $cart.yPos = $newY
            $cart.Direction = $newDirection
            $cart.nextTurn = $newTurn
            $cart.Track = $grid[$newX,$newY]

            # Draw to new position on grid
            $grid[$cart.xPos,$cart.yPos] = $cart.Direction
            
            # Reset old position on grid
            $grid[$oldX,$oldY] = $oldTrack
        }
    }
    }
    $ticks++
    # write-host "After $ticks ticks..."
    # for($r=0;$r-lt$height;$r++){
    #     [string]$write = ''
    #     for($l=0;$l-lt$width;$l++){
    #         $write += $grid[$r,$l]
    #     }
    #     $write
    # }
    $dead = ($carts | ?{!($_.InService)}).Count
    $perc = ($dead/($carts.Count))*100
    Write-Progress -id 0 -Activity "Completed $ticks ticks . . ." -Status "$dead of $($carts.Count) carts have crashed" -PercentComplete $perc
}

($carts | ?{$_.InService}).Count
$carts | ?{$_.InService} | foreach{$Part2 = '('+[string]$_.yPos+','+[string]$_.xPos+')'}
Write-Host "Part 1: $Part1"
Write-Host "Part 2: $Part2"