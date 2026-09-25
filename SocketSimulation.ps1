$hostName = "127.0.0.1"
$port = 7777

function Start-FakeClient {
    param(
        [string]$Name,
        [int]$ConnectDelay,
        [int[]]$SendIntervals,
        [bool]$Reconnect = $false
    )

    Start-Job -ScriptBlock {
        param($Name, $hostName, $port, $ConnectDelay, $SendIntervals, $Reconnect)

        Start-Sleep -Seconds $ConnectDelay

        function Connect-And-Run {
            param($SessionLabel)

            Write-Host "[$Name] Connecting ($SessionLabel)..."

            $client = New-Object System.Net.Sockets.TcpClient
            $client.Connect($hostName, $port)

            $stream = $client.GetStream()
            $writer = New-Object System.IO.StreamWriter($stream)
            $writer.AutoFlush = $true

            foreach ($delay in $SendIntervals) {
                Start-Sleep -Seconds $delay

                $message = "$Name :: packet :: $(Get-Date -Format HH:mm:ss.fff)"
                Write-Host "[$Name] SEND -> $message"

                $writer.WriteLine($message)
            }

            Write-Host "[$Name] Disconnecting ($SessionLabel)..."

            $writer.Close()
            $stream.Close()
            $client.Close()
        }

        Connect-And-Run "initial"

        if ($Reconnect) {
            Start-Sleep -Seconds 3
            Connect-And-Run "reconnect"
        }

    } -ArgumentList $Name, $hostName, $port, $ConnectDelay, $SendIntervals, $Reconnect
}

# Client A
Start-FakeClient `
    -Name "Client-A" `
    -ConnectDelay 0 `
    -SendIntervals @(1, 2, 1) `
    -Reconnect $true

# Client B
Start-FakeClient `
    -Name "Client-B" `
    -ConnectDelay 2 `
    -SendIntervals @(2, 2)

# Client C
Start-FakeClient `
    -Name "Client-C" `
    -ConnectDelay 5 `
    -SendIntervals @(1, 1, 1)

Write-Host "Simulation running..."

Get-Job | Wait-Job

Write-Host "Simulation finished."

Get-Job | Remove-Job